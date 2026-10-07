<div align="center">

# Lecoo Control Center GUI

CN [中文 Readme 在这](README_CN.md)

</div>

Lecoo Control Center GUI is an unofficial graphical interface version of the Lecoo Control Center, built using Qt 6, Rust, and QML, and designed specifically for laptops based on the Emdoor chassis (such as Lecoo Pro 14 and Lecoo N155).

The GUI is an independent client. Hardware access is provided by the external [`lecoo-ctrl`](https://github.com/LaVashikk/Lecoo-Control-Center) CLI and its `lecoo-ec-daemon` backend. The GUI invokes the CLI as a subprocess and does not access the EC or `/dev` directly.

## Features

- Dashboard with connection state, temperatures, fan speeds, power profile, and live monitoring.
- Silent, balanced, and performance power profiles.
- Automatic, full-speed, and custom PWM modes for CPU and GPU fans.
- Charging limits at 100%, 95%, 80%, 60%, and 40%.
- Keyboard backlight and LED ring controls.
- Device, controller, GUI version, and operating system information.
- Light/dark mode, system theme following, Chinese/English localization, preset themes, and a custom Material You palette.
- Persistent settings through `QSettings`.

## Screenshot

<div>
<img src="screenshot\screenshot.png" alt="screenshot" >
</div>

## Supported platforms

- Linux: Ubuntu 24.04+, Debian 13+, Arch Linux (GLIBC ≥ 2.39)
- Windows: Windows 10 20H1+, Windows 11

## Requirements

- Qt 6.5 or newer:
  - Qt Quick
  - Qt QML
  - Qt Quick Controls 2
  - Qt GUI
  - Qt 5 Compatibility Module
  - Qt Shader Tools
- Rust stable, edition 2024.
- An installed or otherwise available `lecoo-ctrl` executable.
- `lecoo-ec-daemon` for hardware control.

## Build (For Developers)

```bash
cargo build --release
```

The executable is written to `target/release/` or `target\release\` on Windows.

### Configure `lecoo-ctrl`

The GUI checks `LECOO_CTRL` first and then falls back to the system `PATH`.

Linux:

```bash
export LECOO_CTRL=/path/to/lecoo-ctrl
./target/release/Lecoo-Control-Center-GUI
```

Windows PowerShell:

```powershell
$env:LECOO_CTRL = "C:\path\to\lecoo-ctrl.exe"
.\target\release\Lecoo-Control-Center-GUI.exe
```

Live monitoring periodically invokes the CLI for temperature and fan data; it does not run an unbounded monitoring subprocess.

## Windows packaging

Windows builds require Visual Studio 2022 Build Tools, the MSVC Rust toolchain, and Qt 6.5+ for MSVC.

```powershell
cargo build --release
.\scripts\package-windows.ps1 -QtBin C:\Qt\6.8.3\msvc2022_64\bin
```

The script deploys Qt DLLs, QML modules, platform plugins, the MSVC runtime, and the bundled font license into `target\release\`. It then removes Cargo build-only directories.

Useful options:

```powershell
# Deploy an existing release build without rebuilding
.\scripts\package-windows.ps1 -QtBin C:\Qt\6.8.3\msvc2022_64\bin -NoBuild

# Keep Cargo incremental build directories
.\scripts\package-windows.ps1 -QtBin C:\Qt\6.8.3\msvc2022_64\bin -KeepBuildFiles
```

`cargo build --release` alone does not deploy the Qt runtime.

## Project layout

```text
.
├── assets/              # Application icon, bundled icon and text fonts, and their licenses
├── qml/                 # Main window, Material 3 components, and translations
├── src/                 # Rust backend and Qt bridge
├── scripts/             # Windows packaging helpers
├── build.rs             # QML, resource, and Windows icon setup
├── deny.toml            # Dependency license policy
├── LICENSE              # GPL-3.0-only
└── THIRD-PARTY-NOTICES.md
```

## Checks

```bash
cargo fmt --check
cargo check
cargo test
cargo deny check
```

## License

This project is licensed under **GPL-3.0-only**; see [LICENSE](LICENSE).

QML design references the Material Design 3 style. The bundled icon font, Material Icons Round, is distributed under Apache License 2.0, and the bundled text font, Noto Sans SC, under the SIL Open Font License 1.1. Font licenses and dependency notices are listed in [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).

`lecoo-ctrl` and `lecoo-ec-daemon` are separate MIT-licensed projects: <https://github.com/LaVashikk/Lecoo-Control-Center>.
