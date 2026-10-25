//! Keep the system power mode aligned with the EC performance profile on Windows and Linux.

use std::fmt;

/// A system power mode shared by Windows and Linux.
#[derive(Clone, Copy, PartialEq, Eq, Debug)]
pub enum Overlay {
    Balanced,
    Saver,
    Perf,
}

impl Overlay {
    pub fn for_profile(profile: &str) -> Option<Self> {
        match profile {
            "silent" => Some(Self::Saver),
            "default" => Some(Self::Balanced),
            "perf" => Some(Self::Perf),
            _ => None,
        }
    }
}

/// A failed system power-mode operation.
#[derive(Clone, PartialEq, Eq, Debug)]
pub enum OverlayError {
    Unavailable,
    Denied,
    Failed(String),
    Unsupported,
}

impl OverlayError {
    pub fn message_key(&self) -> &'static str {
        match self {
            Self::Unavailable => "backend.error.overlay_unavailable",
            Self::Denied => "backend.error.overlay_denied",
            Self::Failed(_) => "backend.error.overlay_failed",
            Self::Unsupported => "backend.error.overlay_unsupported",
        }
    }
}

impl fmt::Display for OverlayError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::Unavailable => f.write_str("power mode is not available on this system"),
            Self::Denied => f.write_str("not authorized to change the system power mode"),
            Self::Failed(detail) => write!(f, "could not change the system power mode: {detail}"),
            Self::Unsupported => f.write_str("system power mode changes are not supported on this platform"),
        }
    }
}

#[cfg(windows)]
mod imp {
    use super::{Overlay, OverlayError};
    use std::{ffi::c_void, ptr};

    #[repr(C)]
    #[derive(Clone, Copy, PartialEq, Eq, Debug)]
    pub struct Guid {
        data1: u32,
        data2: u16,
        data3: u16,
        data4: [u8; 8],
    }

    impl Guid {
        const fn new(data1: u32, data2: u16, data3: u16, data4: [u8; 8]) -> Self {
            Self { data1, data2, data3, data4 }
        }
    }

    // Microsoft overlay GUIDs.
    const BALANCED: Guid = Guid::new(0x0000_0000, 0x0000, 0x0000, [0; 8]);
    const SAVER: Guid =
        Guid::new(0x961c_c777, 0x2547, 0x4f9d, [0x81, 0x74, 0x7d, 0x86, 0x18, 0x1b, 0x8a, 0x7a]);
    const PERF: Guid =
        Guid::new(0xded5_74b5, 0x45a0, 0x4f42, [0x87, 0x37, 0x46, 0x34, 0x5c, 0x09, 0xc2, 0x38]);

    const ERROR_INVALID_PARAMETER: u32 = 87;

    fn guid_of(overlay: Overlay) -> Guid {
        match overlay {
            Overlay::Balanced => BALANCED,
            Overlay::Saver => SAVER,
            Overlay::Perf => PERF,
        }
    }

    fn overlay_of(guid: Guid) -> Option<Overlay> {
        if guid == BALANCED {
            Some(Overlay::Balanced)
        } else if guid == SAVER {
            Some(Overlay::Saver)
        } else if guid == PERF {
            Some(Overlay::Perf)
        } else {
            None
        }
    }

    type SetOverlay = unsafe extern "system" fn(*const Guid) -> u32;
    type GetOverlay = unsafe extern "system" fn(*mut Guid) -> u32;

    #[link(name = "kernel32")]
    unsafe extern "system" {
        fn LoadLibraryW(name: *const u16) -> *mut c_void;
        fn GetProcAddress(module: *mut c_void, name: *const u8) -> *mut c_void;
    }

    fn resolve() -> Option<(SetOverlay, GetOverlay)> {
        use std::sync::atomic::{AtomicPtr, Ordering};

        static SET: AtomicPtr<c_void> = AtomicPtr::new(ptr::null_mut());
        static GET: AtomicPtr<c_void> = AtomicPtr::new(ptr::null_mut());

        let cached = SET.load(Ordering::Acquire);
        if !cached.is_null() {
            let set = unsafe { std::mem::transmute::<*mut c_void, SetOverlay>(cached) };
            let get = unsafe { std::mem::transmute::<*mut c_void, GetOverlay>(GET.load(Ordering::Acquire)) };
            return Some((set, get));
        }

        let dll: Vec<u16> = "powrprof.dll".encode_utf16().chain(std::iter::once(0)).collect();
        // SAFETY: the name is NUL-terminated and the call has no other contract.
        let module = unsafe { LoadLibraryW(dll.as_ptr()) };
        if module.is_null() {
            return None;
        }

        // SAFETY: `module` is a live module handle and the names are NUL-terminated.
        let set = unsafe { GetProcAddress(module, c"PowerSetActiveOverlayScheme".as_ptr().cast()) };
        // SAFETY: as above.
        let get = unsafe { GetProcAddress(module, c"PowerGetEffectiveOverlayScheme".as_ptr().cast()) };
        if set.is_null() || get.is_null() {
            return None;
        }

        SET.store(set, Ordering::Release);
        GET.store(get, Ordering::Release);

        // SAFETY: both pointers were just checked non-null and come from the same DLL.
        unsafe {
            Some((
                std::mem::transmute::<*mut c_void, SetOverlay>(set),
                std::mem::transmute::<*mut c_void, GetOverlay>(get),
            ))
        }
    }

    /// Change the Windows power mode without elevation.
    pub fn set_overlay(overlay: Overlay) -> Result<(), OverlayError> {
        let Some((set, _)) = resolve() else {
            return Err(OverlayError::Unsupported);
        };
        let guid = guid_of(overlay);
        // SAFETY: `guid` is valid for the duration of the call.
        let rc = unsafe { set(&guid) };
        match rc {
            0 => Ok(()),
            ERROR_INVALID_PARAMETER => Err(OverlayError::Unavailable),
            other => Err(OverlayError::Failed(format!("Win32 error {other}"))),
        }
    }

    /// Read the active Windows power mode, or `None` for an unknown overlay.
    pub fn effective_overlay() -> Result<Option<Overlay>, OverlayError> {
        let Some((_, get)) = resolve() else {
            return Err(OverlayError::Unsupported);
        };
        let mut guid = Guid::new(0, 0, 0, [0; 8]);
        // SAFETY: the callee only writes through the pointer it is given.
        let rc = unsafe { get(&mut guid) };
        match rc {
            0 => Ok(overlay_of(guid)),
            other => Err(OverlayError::Failed(format!("Win32 error {other}"))),
        }
    }

    #[cfg(test)]
    pub fn guid_bytes(overlay: Overlay) -> [u8; 16] {
        let guid = guid_of(overlay);
        let mut bytes = [0u8; 16];
        bytes[0..4].copy_from_slice(&guid.data1.to_le_bytes());
        bytes[4..6].copy_from_slice(&guid.data2.to_le_bytes());
        bytes[6..8].copy_from_slice(&guid.data3.to_le_bytes());
        bytes[8..16].copy_from_slice(&guid.data4);
        bytes
    }
}

#[cfg(windows)]
pub use imp::{effective_overlay, set_overlay};

#[cfg(target_os = "linux")]
mod imp {
    use super::{Overlay, OverlayError};
    use std::process::Command;

    const BUS_NAME: &str = "org.freedesktop.UPower.PowerProfiles";
    const OBJECT_PATH: &str = "/org/freedesktop/UPower/PowerProfiles";
    const INTERFACE: &str = "org.freedesktop.UPower.PowerProfiles";

    #[derive(Clone, Copy)]
    enum Client {
        Busctl,
        Gdbus,
        DbusSend,
        PowerProfilesCtl,
    }

    /// Tried in order until one succeeds.
    const CLIENTS: [Client; 4] = [Client::Busctl, Client::Gdbus, Client::DbusSend, Client::PowerProfilesCtl];

    enum CallError {
        Missing,
        Failed(String),
    }

    pub(super) fn profile_name(overlay: Overlay) -> &'static str {
        match overlay {
            Overlay::Balanced => "balanced",
            Overlay::Saver => "power-saver",
            Overlay::Perf => "performance",
        }
    }

    pub(super) fn overlay_of(name: &str) -> Option<Overlay> {
        match name {
            "balanced" => Some(Overlay::Balanced),
            "power-saver" => Some(Overlay::Saver),
            "performance" => Some(Overlay::Perf),
            _ => None,
        }
    }

    fn run(client: Client, arguments: &[String]) -> Result<String, CallError> {
        let program = match client {
            Client::Busctl => "busctl",
            Client::Gdbus => "gdbus",
            Client::DbusSend => "dbus-send",
            Client::PowerProfilesCtl => "powerprofilesctl",
        };
        let output = match Command::new(program).args(arguments).output() {
            Ok(output) => output,
            Err(error) if error.kind() == std::io::ErrorKind::NotFound => {
                return Err(CallError::Missing);
            }
            Err(error) => return Err(CallError::Failed(error.to_string())),
        };
        if output.status.success() {
            return Ok(String::from_utf8_lossy(&output.stdout).into_owned());
        }
        let stderr = String::from_utf8_lossy(&output.stderr);
        let detail = if stderr.trim().is_empty() {
            format!("{program} exited with {}", output.status)
        } else {
            stderr.trim().to_owned()
        };
        Err(CallError::Failed(detail))
    }

    pub(super) fn double_quoted(text: &str) -> Option<String> {
        let start = text.find('"')?;
        let rest = &text[start + 1..];
        let end = rest.find('"')?;
        Some(rest[..end].to_owned())
    }

    pub(super) fn single_quoted(text: &str) -> Option<String> {
        let start = text.find('\'')?;
        let rest = &text[start + 1..];
        let end = rest.find('\'')?;
        Some(rest[..end].to_owned())
    }

    fn read(client: Client) -> Result<Option<Overlay>, CallError> {
        let arguments: Vec<String> = match client {
            Client::Busctl => ["--system", "get-property", BUS_NAME, OBJECT_PATH, INTERFACE, "ActiveProfile"]
                .iter()
                .map(|argument| (*argument).to_owned())
                .collect(),
            Client::Gdbus => [
                "call",
                "--system",
                "--dest",
                BUS_NAME,
                "--object-path",
                OBJECT_PATH,
                "--method",
                "org.freedesktop.DBus.Properties.Get",
                INTERFACE,
                "ActiveProfile",
            ]
            .iter()
            .map(|argument| (*argument).to_owned())
            .collect(),
            Client::DbusSend => vec![
                "--system".to_owned(),
                "--print-reply".to_owned(),
                format!("--dest={BUS_NAME}"),
                OBJECT_PATH.to_owned(),
                "org.freedesktop.DBus.Properties.Get".to_owned(),
                format!("string:{INTERFACE}"),
                "string:ActiveProfile".to_owned(),
            ],
            Client::PowerProfilesCtl => vec!["get".to_owned()],
        };

        let stdout = run(client, &arguments)?;
        let name = match client {
            Client::Busctl | Client::DbusSend => double_quoted(&stdout),
            Client::Gdbus => single_quoted(&stdout),
            Client::PowerProfilesCtl => Some(stdout.trim().to_owned()),
        };
        let name = name
            .filter(|name| !name.is_empty())
            .ok_or_else(|| CallError::Failed(format!("unexpected output: {}", stdout.trim())))?;
        Ok(overlay_of(name.trim()))
    }

    fn write(client: Client, profile: &str) -> Result<(), CallError> {
        let arguments: Vec<String> = match client {
            Client::Busctl => vec![
                "--system".to_owned(),
                "set-property".to_owned(),
                BUS_NAME.to_owned(),
                OBJECT_PATH.to_owned(),
                INTERFACE.to_owned(),
                "ActiveProfile".to_owned(),
                "s".to_owned(),
                profile.to_owned(),
            ],
            Client::Gdbus => vec![
                "call".to_owned(),
                "--system".to_owned(),
                "--dest".to_owned(),
                BUS_NAME.to_owned(),
                "--object-path".to_owned(),
                OBJECT_PATH.to_owned(),
                "--method".to_owned(),
                "org.freedesktop.DBus.Properties.Set".to_owned(),
                INTERFACE.to_owned(),
                "ActiveProfile".to_owned(),
                format!("<'{profile}'>"),
            ],
            Client::DbusSend => vec![
                "--system".to_owned(),
                "--print-reply".to_owned(),
                format!("--dest={BUS_NAME}"),
                OBJECT_PATH.to_owned(),
                "org.freedesktop.DBus.Properties.Set".to_owned(),
                format!("string:{INTERFACE}"),
                "string:ActiveProfile".to_owned(),
                format!("variant:string:{profile}"),
            ],
            Client::PowerProfilesCtl => vec!["set".to_owned(), profile.to_owned()],
        };
        run(client, &arguments).map(|_| ())
    }

    /// Map client failures to the error shown by the UI.
    pub(super) fn aggregate_error(failures: Vec<String>) -> OverlayError {
        if failures.is_empty() {
            return OverlayError::Unsupported;
        }
        let combined = failures.join("\n").to_lowercase();
        if combined.contains("unknownservice")
            || combined.contains("servicenotfound")
            || combined.contains("name has no owner")
            || combined.contains("not provided by any .service")
            || combined.contains("failed to connect")
            || combined.contains("could not connect")
            || combined.contains("failed to communicate")
            || combined.contains("connection refused")
            || combined.contains("no such file or directory")
        {
            return OverlayError::Unavailable;
        }
        if combined.contains("accessdenied")
            || combined.contains("access denied")
            || combined.contains("notauthorized")
            || combined.contains("not authorized")
            || combined.contains("authentication")
            || combined.contains("permission denied")
        {
            return OverlayError::Denied;
        }
        OverlayError::Failed(failures.into_iter().next().unwrap_or_default())
    }

    /// Apply the profile through the first working D-Bus client.
    pub fn set_overlay(overlay: Overlay) -> Result<(), OverlayError> {
        let profile = profile_name(overlay);
        let mut failures = Vec::new();
        for client in CLIENTS {
            match write(client, profile) {
                Ok(()) => return Ok(()),
                Err(CallError::Missing) => {}
                Err(CallError::Failed(message)) => failures.push(message),
            }
        }
        Err(aggregate_error(failures))
    }

    /// Read the active system profile, or `None` if it is unknown.
    pub fn effective_overlay() -> Result<Option<Overlay>, OverlayError> {
        let mut failures = Vec::new();
        for client in CLIENTS {
            match read(client) {
                Ok(overlay) => return Ok(overlay),
                Err(CallError::Missing) => {}
                Err(CallError::Failed(message)) => failures.push(message),
            }
        }
        Err(aggregate_error(failures))
    }
}

#[cfg(target_os = "linux")]
pub use imp::{effective_overlay, set_overlay};

#[cfg(not(any(windows, target_os = "linux")))]
mod imp {
    use super::{Overlay, OverlayError};

    pub fn set_overlay(_overlay: Overlay) -> Result<(), OverlayError> {
        Err(OverlayError::Unsupported)
    }

    pub fn effective_overlay() -> Result<Option<Overlay>, OverlayError> {
        Err(OverlayError::Unsupported)
    }
}

#[cfg(not(any(windows, target_os = "linux")))]
pub use imp::{effective_overlay, set_overlay};

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn profile_mapping_covers_the_three_gui_profiles() {
        assert_eq!(Overlay::for_profile("silent"), Some(Overlay::Saver));
        assert_eq!(Overlay::for_profile("default"), Some(Overlay::Balanced));
        assert_eq!(Overlay::for_profile("perf"), Some(Overlay::Perf));
        assert_eq!(Overlay::for_profile("turbo"), None);
        assert_eq!(Overlay::for_profile(""), None);
    }

    #[test]
    fn error_codes_map_to_message_keys() {
        assert_eq!(OverlayError::Unavailable.message_key(), "backend.error.overlay_unavailable");
        assert_eq!(OverlayError::Denied.message_key(), "backend.error.overlay_denied");
        assert_eq!(
            OverlayError::Failed("Win32 error 5".to_owned()).message_key(),
            "backend.error.overlay_failed"
        );
        assert_eq!(OverlayError::Unsupported.message_key(), "backend.error.overlay_unsupported");
        assert!(OverlayError::Failed("Win32 error 5".to_owned()).to_string().contains('5'));
    }

    #[cfg(target_os = "linux")]
    #[test]
    fn linux_dbus_output_is_parsed() {
        assert_eq!(imp::double_quoted("s \"balanced\"").as_deref(), Some("balanced"));
        assert_eq!(
            imp::double_quoted("variant       string \"power-saver\"").as_deref(),
            Some("power-saver")
        );
        assert_eq!(imp::single_quoted("(<'performance'>,)").as_deref(), Some("performance"));

        assert_eq!(imp::overlay_of("power-saver"), Some(Overlay::Saver));
        assert_eq!(imp::overlay_of("balanced"), Some(Overlay::Balanced));
        assert_eq!(imp::overlay_of("performance"), Some(Overlay::Perf));
        assert_eq!(imp::overlay_of("power-saver-2"), None);

        assert_eq!(imp::profile_name(Overlay::Saver), "power-saver");
        assert_eq!(imp::profile_name(Overlay::Balanced), "balanced");
        assert_eq!(imp::profile_name(Overlay::Perf), "performance");
    }

    #[cfg(target_os = "linux")]
    #[test]
    fn linux_failures_are_classified() {
        let unknown_service = imp::aggregate_error(vec![
            "Call to Set failed: org.freedesktop.DBus.Error.ServiceUnknown: The name \
             org.freedesktop.UPower.PowerProfiles was not provided by any .service files"
                .to_owned(),
        ]);
        assert_eq!(unknown_service, OverlayError::Unavailable);

        let denied = imp::aggregate_error(vec![
            "Error: GDBus.Error:org.freedesktop.DBus.Error.AccessDenied: Access Denied".to_owned(),
        ]);
        assert_eq!(denied, OverlayError::Denied);

        assert_eq!(imp::aggregate_error(Vec::new()), OverlayError::Unsupported);

        match imp::aggregate_error(vec!["something broke".to_owned()]) {
            OverlayError::Failed(detail) => assert_eq!(detail, "something broke"),
            other => panic!("expected a detailed failure, got {other:?}"),
        }
    }

    #[cfg(windows)]
    #[test]
    fn overlay_guids_use_the_win32_byte_order() {
        assert_eq!(
            imp::guid_bytes(Overlay::Saver),
            [0x77, 0xc7, 0x1c, 0x96, 0x47, 0x25, 0x9d, 0x4f, 0x81, 0x74, 0x7d, 0x86, 0x18, 0x1b, 0x8a, 0x7a]
        );
        assert_eq!(
            imp::guid_bytes(Overlay::Perf),
            [0xb5, 0x74, 0xd5, 0xde, 0xa0, 0x45, 0x42, 0x4f, 0x87, 0x37, 0x46, 0x34, 0x5c, 0x09, 0xc2, 0x38]
        );
    }
}

#[cfg(test)]
mod live_tests {
    use super::*;

    /// Verify write/read/restore against the real service when available.
    #[cfg(any(windows, target_os = "linux"))]
    #[test]
    fn set_and_read_back_each_overlay() {
        let Ok(original) = effective_overlay() else {
            return;
        };
        let original = original.unwrap_or(Overlay::Balanced);

        for overlay in [Overlay::Saver, Overlay::Perf, Overlay::Balanced] {
            match set_overlay(overlay) {
                Ok(()) => {
                    let now = effective_overlay().expect("read back");
                    assert_eq!(now, Some(overlay), "after setting {overlay:?} the OS reported {now:?}");
                }
                Err(OverlayError::Unavailable) | Err(OverlayError::Denied) => {}
                Err(error) => panic!("setting {overlay:?} failed: {error}"),
            }
        }

        let _ = set_overlay(original);
    }
}
