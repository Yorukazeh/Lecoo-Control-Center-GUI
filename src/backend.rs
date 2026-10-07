use std::{
    path::{Path, PathBuf},
    pin::Pin,
    process::{Command, Output},
};

use cxx_qt::Threading;
use cxx_qt_lib::{QString, QTime};

#[cfg(windows)]
use std::os::windows::process::CommandExt;

/// Prevent Windows CLI calls from opening a console window.
#[cfg(windows)]
const CREATE_NO_WINDOW: u32 = 0x0800_0000;

#[cxx_qt::bridge]
pub mod qobject {
    unsafe extern "C++" {
        include!("cxx-qt-lib/qstring.h");
        type QString = cxx_qt_lib::QString;
    }

    // Expose Qt application identity helpers to QML.
    unsafe extern "C++" {
        include!("qt_shim.h");
        #[rust_name = "set_application_icon"]
        fn lecooSetApplicationIcon();
        #[rust_name = "set_desktop_file_name"]
        fn lecooSetDesktopFileName(name: &QString);
        #[rust_name = "set_quick_controls_style"]
        fn lecooSetQuickControlsStyle(style: &QString);
        #[rust_name = "shim_system_font_family"]
        fn lecooSystemFontFamily() -> QString;
        #[rust_name = "shim_fixed_font_family"]
        fn lecooFixedFontFamily() -> QString;
        #[rust_name = "cursor_screen_name"]
        fn lecooCursorScreenName() -> QString;
        #[rust_name = "os_product_name"]
        fn lecooOsName() -> QString;
        #[rust_name = "os_kernel_version"]
        fn lecooOsVersion() -> QString;
    }

    extern "RustQt" {
        #[qobject]
        #[qml_element]
        #[qproperty(bool, connected, cxx_name = "connected")]
        #[qproperty(bool, busy, cxx_name = "busy")]
        #[qproperty(bool, monitoring, cxx_name = "monitoring")]
        #[qproperty(i32, cpu_temperature, cxx_name = "cpuTemperature")]
        #[qproperty(i32, system_temperature, cxx_name = "systemTemperature")]
        #[qproperty(i32, cpu_fan_rpm, cxx_name = "cpuFanRpm")]
        #[qproperty(i32, gpu_fan_rpm, cxx_name = "gpuFanRpm")]
        #[qproperty(QString, power_profile, cxx_name = "powerProfile")]
        #[qproperty(QString, controller_info, cxx_name = "controllerInfo")]
        #[qproperty(QString, os_info, cxx_name = "osInfo")]
        #[qproperty(QString, os_version, cxx_name = "osVersion")]
        #[qproperty(QString, status_message, cxx_name = "statusMessage")]
        #[qproperty(QString, error_message, cxx_name = "errorMessage")]
        #[qproperty(QString, last_update, cxx_name = "lastUpdate")]
        #[qproperty(QString, app_version, cxx_name = "appVersion")]
        #[qproperty(QString, cli_path, cxx_name = "cliPath")]
        #[qproperty(QString, cli_version, cxx_name = "cliVersion")]
        type ControlCenter = super::ControlCenterRust;

        #[qinvokable]
        #[cxx_name = "refreshAll"]
        fn refresh_all(self: Pin<&mut Self>);

        #[qinvokable]
        #[cxx_name = "refreshInfo"]
        fn refresh_info(self: Pin<&mut Self>);

        #[qinvokable]
        #[cxx_name = "refreshPowerProfile"]
        fn refresh_power_profile(self: Pin<&mut Self>);

        #[qinvokable]
        #[cxx_name = "toggleMonitoring"]
        fn toggle_monitoring(self: Pin<&mut Self>, enabled: bool);

        #[qinvokable]
        #[cxx_name = "applyPowerProfile"]
        fn apply_power_profile(self: Pin<&mut Self>, profile: &QString);

        #[qinvokable]
        #[cxx_name = "applyFanMode"]
        fn apply_fan_mode(self: Pin<&mut Self>, target: &QString, mode: &QString, pwm: i32);

        #[qinvokable]
        #[cxx_name = "applyChargePreset"]
        fn apply_charge_preset(self: Pin<&mut Self>, preset: &QString);

        #[qinvokable]
        #[cxx_name = "applyKeyboardLevel"]
        fn apply_keyboard_level(self: Pin<&mut Self>, level: i32);

        #[qinvokable]
        #[cxx_name = "applyKeyboardMode"]
        fn apply_keyboard_mode(self: Pin<&mut Self>, mode: &QString, pwm: i32);

        #[qinvokable]
        #[cxx_name = "applyLedMode"]
        fn apply_led_mode(self: Pin<&mut Self>, mode: &QString, pwm: i32);

        #[qinvokable]
        #[cxx_name = "refreshCliInfo"]
        fn refresh_cli_info(self: Pin<&mut Self>);

        // Platform default font families, read once at startup (no text font is bundled).
        #[qinvokable]
        #[cxx_name = "systemFontFamily"]
        fn system_font_family(&self) -> QString;

        #[qinvokable]
        #[cxx_name = "fixedFontFamily"]
        fn fixed_font_family(&self) -> QString;

        // Return the screen under the cursor.
        #[qinvokable]
        #[cxx_name = "cursorScreenName"]
        fn cursor_screen_name(&self) -> QString;

        // Return a compiled-in legal document by name.
        #[qinvokable]
        #[cxx_name = "legalDocument"]
        fn legal_document(&self, name: &QString) -> QString;
    }

    // Enables `self.qt_thread()` so CLI work can run off the Qt event loop.
    impl cxx_qt::Threading for ControlCenter {}
}

pub struct ControlCenterRust {
    connected: bool,
    busy: bool,
    monitoring: bool,
    cpu_temperature: i32,
    system_temperature: i32,
    cpu_fan_rpm: i32,
    gpu_fan_rpm: i32,
    power_profile: QString,
    controller_info: QString,
    os_info: QString,
    os_version: QString,
    status_message: QString,
    error_message: QString,
    last_update: QString,
    app_version: QString,
    cli_path: QString,
    cli_version: QString,
}

impl Default for ControlCenterRust {
    fn default() -> Self {
        Self {
            connected: false,
            busy: false,
            monitoring: false,
            cpu_temperature: 0,
            system_temperature: 0,
            cpu_fan_rpm: 0,
            gpu_fan_rpm: 0,
            power_profile: QString::default(),
            controller_info: QString::default(),
            os_info: qobject::os_product_name(),
            os_version: qobject::os_kernel_version(),
            status_message: QString::default(),
            error_message: QString::default(),
            last_update: QString::default(),
            app_version: QString::from(env!("CARGO_PKG_VERSION")),
            cli_path: QString::default(),
            cli_version: QString::default(),
        }
    }
}

/// Resolve the CLI override or the executable found on PATH.
fn cli_candidates() -> Vec<PathBuf> {
    let mut candidates = Vec::new();

    if let Ok(path) = std::env::var("LECOO_CTRL") {
        let path = path.trim();
        if !path.is_empty() {
            candidates.push(PathBuf::from(path));
        }
    }

    candidates.push(PathBuf::from(if cfg!(windows) { "lecoo-ctrl.exe" } else { "lecoo-ctrl" }));
    candidates
}

fn run_command(binary: &Path, args: &[&str]) -> std::io::Result<Output> {
    let mut command = Command::new(binary);
    command.args(args);
    #[cfg(windows)]
    command.creation_flags(CREATE_NO_WINDOW);
    command.output()
}

fn command_result(output: Output) -> Result<String, String> {
    let stdout = String::from_utf8_lossy(&output.stdout).trim().to_owned();
    let stderr = String::from_utf8_lossy(&output.stderr).trim().to_owned();

    if output.status.success() {
        Ok(stdout)
    } else if stderr.is_empty() {
        Err(stdout)
    } else {
        Err(stderr)
    }
}

fn run_cli(args: &[&str]) -> Result<String, String> {
    for candidate in cli_candidates() {
        match run_command(&candidate, args) {
            Ok(output) => return command_result(output),
            Err(_) => continue,
        }
    }
    Err("backend.error.cli_unavailable".to_owned())
}

/// Return the absolute CLI path for the About card.
fn resolve_cli_path() -> Option<PathBuf> {
    if let Ok(raw) = std::env::var("LECOO_CTRL") {
        let trimmed = raw.trim();
        if !trimmed.is_empty() {
            let candidate = PathBuf::from(trimmed);
            if candidate.is_file() {
                return Some(candidate);
            }
        }
    }

    let name = if cfg!(windows) { "lecoo-ctrl.exe" } else { "lecoo-ctrl" };
    let search = std::env::var_os("PATH")?;
    std::env::split_paths(&search)
        .map(|dir| dir.join(name))
        .find(|candidate| candidate.is_file())
}

fn run_binary(binary: &Path, args: &[&str]) -> Result<String, String> {
    run_command(binary, args).map_err(|error| error.to_string()).and_then(command_result)
}

/// `lecoo-ctrl --version` prints `<bin> v<semver>`; keep just the version.
fn version_from_banner(banner: &str) -> String {
    let token = banner.split_whitespace().last().unwrap_or_default();
    match token.strip_prefix('v') {
        Some(rest) if rest.starts_with(|ch: char| ch.is_ascii_digit()) => rest.to_owned(),
        _ => token.to_owned(),
    }
}

fn numbers(text: &str) -> Vec<i32> {
    text.split(|ch: char| !ch.is_ascii_digit())
        .filter_map(|part| part.parse::<i32>().ok())
        .collect()
}

/// Return the local time as HH:MM:SS.
fn now_label() -> String {
    let now = QTime::current_time();
    format!("{:02}:{:02}:{:02}", now.hour(), now.minute(), now.second())
}

fn qstring(value: impl Into<String>) -> QString {
    QString::from(value.into())
}

/// Return a compiled-in legal document by name.
fn legal_document_text(name: &str) -> &'static str {
    match name {
        "license" => include_str!("../LICENSE"),
        "notices" => include_str!("../THIRD-PARTY-NOTICES.md"),
        _ => "",
    }
}

impl qobject::ControlCenter {
    fn begin(mut self: Pin<&mut Self>) {
        self.as_mut().set_busy(true);
        self.as_mut().set_error_message(QString::default());
    }

    fn finish(mut self: Pin<&mut Self>, message_key: &str) {
        self.as_mut().set_busy(false);
        self.as_mut().set_status_message(qstring(message_key));
        self.as_mut().set_last_update(qstring(now_label()));
    }

    fn fail(mut self: Pin<&mut Self>, error: impl Into<String>) {
        self.as_mut().set_busy(false);
        self.as_mut().set_connected(false);
        self.as_mut().set_error_message(qstring(error));
        self.as_mut().set_status_message(qstring("backend.error.operation_failed"));
    }

    /// Run blocking CLI work off the Qt thread and apply its result on the Qt thread.
    fn run_async<T, W, A>(self: Pin<&mut Self>, work: W, apply: A)
    where
        T: Send + 'static,
        W: FnOnce() -> T + Send + 'static,
        A: FnOnce(Pin<&mut Self>, T) + Send + 'static,
    {
        let qt_thread = self.qt_thread();
        std::thread::spawn(move || {
            let result = work();
            let _ = qt_thread.queue(move |obj| apply(obj, result));
        });
    }

    pub fn refresh_all(mut self: Pin<&mut Self>) {
        self.as_mut().begin();
        self.run_async(
            || (run_cli(&["temps"]), run_cli(&["fans"])),
            |mut obj, (temps, fans)| {
                let mut failed = None;
                match temps {
                    Ok(output) => {
                        let values = numbers(&output);
                        if values.len() >= 2 {
                            obj.as_mut().set_cpu_temperature(values[0]);
                            obj.as_mut().set_system_temperature(values[1]);
                        } else {
                            failed = Some("backend.error.parse_temps".to_owned());
                        }
                    }
                    Err(error) => failed = Some(error),
                }

                match fans {
                    Ok(output) => {
                        let values = numbers(&output);
                        if values.len() >= 2 {
                            obj.as_mut().set_cpu_fan_rpm(values[0]);
                            obj.as_mut().set_gpu_fan_rpm(values[1]);
                        } else if failed.is_none() {
                            failed = Some("backend.error.parse_fans".to_owned());
                        }
                    }
                    Err(error) => {
                        if failed.is_none() {
                            failed = Some(error);
                        }
                    }
                }

                if let Some(error) = failed {
                    obj.fail(error);
                } else {
                    obj.as_mut().set_connected(true);
                    obj.finish("backend.status.monitor_updated");
                }
            },
        );
    }

    pub fn refresh_info(mut self: Pin<&mut Self>) {
        self.as_mut().begin();
        self.run_async(
            || run_cli(&["info"]),
            |mut obj, result| match result {
                Ok(output) => {
                    obj.as_mut().set_connected(true);
                    obj.as_mut().set_controller_info(qstring(output));
                    obj.finish("backend.status.info_updated");
                }
                Err(error) => obj.fail(error),
            },
        );
    }

    /// Read the CLI path and version for the About card.
    pub fn refresh_cli_info(self: Pin<&mut Self>) {
        self.run_async(
            || match resolve_cli_path() {
                Some(binary) => {
                    let version = run_binary(&binary, &["--version"])
                        .map(|banner| version_from_banner(&banner))
                        .unwrap_or_default();
                    (binary.display().to_string(), version)
                }
                None => (String::new(), String::new()),
            },
            |mut obj, (path, version)| {
                obj.as_mut().set_cli_path(qstring(path));
                obj.as_mut().set_cli_version(qstring(version));
            },
        );
    }

    /// Return a requested legal document.
    pub fn legal_document(&self, name: &QString) -> QString {
        qstring(legal_document_text(&name.to_string()))
    }

    /// The platform's default UI text font family (nothing is bundled).
    pub fn system_font_family(&self) -> QString {
        qobject::shim_system_font_family()
    }

    /// The platform's default fixed-width font family (license viewer body).
    pub fn fixed_font_family(&self) -> QString {
        qobject::shim_fixed_font_family()
    }

    /// Name of the screen the mouse cursor is on (empty when unknown).
    pub fn cursor_screen_name(&self) -> QString {
        qobject::cursor_screen_name()
    }

    pub fn refresh_power_profile(self: Pin<&mut Self>) {
        self.run_async(
            || run_cli(&["power"]),
            |mut obj, result| {
                let Ok(output) = result else { return };
                let normalized = output.to_lowercase();
                let profile = if normalized.contains("performance") {
                    "perf"
                } else if normalized.contains("silent") {
                    "silent"
                } else if normalized.contains("default") {
                    "default"
                } else {
                    return;
                };
                obj.as_mut().set_power_profile(qstring(profile));
            },
        );
    }

    pub fn toggle_monitoring(mut self: Pin<&mut Self>, enabled: bool) {
        self.as_mut().set_monitoring(enabled);
        self.as_mut().set_status_message(qstring(if enabled {
            "backend.status.monitor_started"
        } else {
            "backend.status.monitor_paused"
        }));
    }

    pub fn apply_power_profile(mut self: Pin<&mut Self>, profile: &QString) {
        let profile = String::from(profile);
        if !matches!(profile.as_str(), "silent" | "default" | "perf") {
            self.fail("backend.error.unsupported_power_profile");
            return;
        }
        self.as_mut().begin();
        let profile_arg = profile.clone();
        self.run_async(
            move || run_cli(&["power", &profile_arg]),
            move |mut obj, result| match result {
                Ok(_) => {
                    obj.as_mut().set_power_profile(qstring(profile));
                    obj.finish("backend.status.power_applied");
                }
                Err(error) => obj.fail(error),
            },
        );
    }

    pub fn apply_fan_mode(mut self: Pin<&mut Self>, target: &QString, mode: &QString, pwm: i32) {
        let target = String::from(target);
        let mode = String::from(mode);
        if !matches!(target.as_str(), "cpu" | "gpu" | "both")
            || !matches!(mode.as_str(), "auto" | "full" | "custom")
        {
            self.fail("backend.error.unsupported_fan_mode");
            return;
        }

        self.as_mut().begin();
        let pwm_text = pwm.clamp(0, 255).to_string();
        let target_arg = target.clone();
        let mode_arg = mode.clone();
        self.run_async(
            move || {
                if mode_arg == "custom" {
                    run_cli(&["fan", &target_arg, &mode_arg, &pwm_text])
                } else {
                    run_cli(&["fan", &target_arg, &mode_arg])
                }
            },
            move |obj, result| match result {
                Ok(_) => {
                    let status_key = match target.as_str() {
                        "cpu" => "backend.status.fan_cpu_applied",
                        "gpu" => "backend.status.fan_gpu_applied",
                        _ => "backend.status.fan_both_applied",
                    };
                    obj.finish(status_key);
                }
                Err(error) => obj.fail(error),
            },
        );
    }

    pub fn apply_charge_preset(mut self: Pin<&mut Self>, preset: &QString) {
        let preset = String::from(preset);
        if !matches!(preset.as_str(), "full" | "high" | "balanced" | "lifespan" | "desk" | "freeze") {
            self.fail("backend.error.unsupported_charge_mode");
            return;
        }
        self.as_mut().begin();
        self.run_async(
            move || run_cli(&["charge", &preset]),
            |obj, result| match result {
                Ok(_) => obj.finish("backend.status.charge_applied"),
                Err(error) => obj.fail(error),
            },
        );
    }

    pub fn apply_keyboard_level(mut self: Pin<&mut Self>, level: i32) {
        let mode = match level.clamp(0, 3) {
            0 => "off",
            1 => "low",
            2 => "medium",
            _ => "high",
        };
        self.as_mut().begin();
        self.run_async(
            move || run_cli(&["kbd", mode]),
            |obj, result| match result {
                Ok(_) => obj.finish("backend.status.keyboard_applied"),
                Err(error) => obj.fail(error),
            },
        );
    }

    pub fn apply_keyboard_mode(mut self: Pin<&mut Self>, mode: &QString, pwm: i32) {
        let mode = String::from(mode);
        if !matches!(mode.as_str(), "off" | "low" | "medium" | "high" | "custom") {
            self.fail("backend.error.unsupported_keyboard_mode");
            return;
        }
        self.as_mut().begin();
        let pwm_text = pwm.clamp(0, 255).to_string();
        let mode_arg = mode.clone();
        self.run_async(
            move || {
                if mode_arg == "custom" {
                    run_cli(&["kbd", &mode_arg, &pwm_text])
                } else {
                    run_cli(&["kbd", &mode_arg])
                }
            },
            |obj, result| match result {
                Ok(_) => obj.finish("backend.status.keyboard_applied"),
                Err(error) => obj.fail(error),
            },
        );
    }

    pub fn apply_led_mode(mut self: Pin<&mut Self>, mode: &QString, pwm: i32) {
        let mode = String::from(mode);
        if !matches!(mode.as_str(), "auto" | "custom") {
            self.fail("backend.error.unsupported_led_mode");
            return;
        }
        self.as_mut().begin();
        let pwm_text = pwm.clamp(0, 255).to_string();
        let mode_arg = mode.clone();
        self.run_async(
            move || {
                if mode_arg == "custom" {
                    run_cli(&["led", &mode_arg, &pwm_text])
                } else {
                    run_cli(&["led", &mode_arg])
                }
            },
            |obj, result| match result {
                Ok(_) => obj.finish("backend.status.led_applied"),
                Err(error) => obj.fail(error),
            },
        );
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn version_banner_keeps_only_the_version() {
        assert_eq!(version_from_banner("lecoo-ctrl v0.5.2-beta"), "0.5.2-beta");
        assert_eq!(version_from_banner("lecoo-ctrl 1.2.3"), "1.2.3");
        assert_eq!(version_from_banner("lecoo-ctrl v2"), "2");
        assert_eq!(version_from_banner(""), "");
        // A trailing token that is not a version must survive untouched.
        assert_eq!(version_from_banner("vendor"), "vendor");
    }

    #[test]
    fn resolved_cli_path_points_at_a_file() {
        if let Some(path) = resolve_cli_path() {
            assert!(path.is_file(), "resolved CLI path must exist: {}", path.display());
        }
    }

    #[test]
    fn legal_documents_are_embedded() {
        let license = legal_document_text("license");
        assert!(license.contains("GNU GENERAL PUBLIC LICENSE"));
        assert!(license.contains("Version 3, 29 June 2007"));

        let notices = legal_document_text("notices");
        assert!(notices.starts_with("# Third-party notices"));
        assert!(notices.contains("GPL-3.0-only"));

        // Unknown documents return an empty string.
        assert_eq!(legal_document_text("does-not-exist"), "");
    }
}
