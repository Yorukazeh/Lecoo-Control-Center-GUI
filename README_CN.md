<div align="center">

# Lecoo Control Center GUI

EN [English Readme here](README.md)

</div>

Lecoo Control Center GUI是基于Lecoo Control Center打造的非官方图形界面版控制中心，使用 Qt 6、Rust 和 QML 构建，专为基于Emdoor底盘的笔记本电脑（如Lecoo Pro 14 / Lecoo N155）设计。

本程序是独立的 GUI 客户端。硬件访问由外部 [`lecoo-ctrl`](https://github.com/LaVashikk/Lecoo-Control-Center) 命令行程序及其 `lecoo-ec-daemon` 后端负责。GUI 通过子进程调用后端，不直接访问 EC 或 `/dev`。

## 功能

- **仪表盘**：显示连接状态、CPU/系统温度、CPU/GPU 风扇转速、当前性能模式和实时监控状态。
- **性能模式**：支持静音、平衡和性能模式。
- **风扇控制**：CPU 和 GPU 风扇均支持自动、全速和自定义 PWM。
- **充电策略**：支持 100%、95%、80%、60% 和 40% 充电上限。
- **键盘背光**：支持关闭、低、中、高和自定义 PWM 亮度。
- **LED 灯环**：支持自动模式和 0-255 范围的自定义亮度。
- **设备信息**：显示控制器信息、连接状态、GUI 版本、最后更新时间和操作系统信息。
- **界面设置**：支持浅色/深色模式、跟随系统、中英文切换、预设主题色和自定义 Material You 调色板。
- **持久化设置**：通过 `QSettings` 保存窗口尺寸、主题、语言及硬件控制选项。

## 截图

<div>
<img src="screenshot\screenshot.png" alt="screenshot" >
</div>

## 支持范围

- Linux: Ubuntu 24.04+, Debian 13+, Arch Linux (GLIBC ≥ 2.39)
- Windows: Windows 10 20H1+, Windows 11

## 运行要求

- Qt 6.5 或更高版本：
  - Qt Quick
  - Qt QML
  - Qt Quick Controls 2
  - Qt GUI
  - Qt 5 Compatibility Module
  - Qt Shader Tools
- Rust stable，edition 2024。
- 已安装或可定位的 `lecoo-ctrl`。
- 运行硬件控制功能时，需要后端项目提供的 `lecoo-ec-daemon`。

## 构建（面向开发者）

```bash
cargo build --release
```

Linux 构建产物：

```text
target/release/Lecoo-Control-Center-GUI
```

Windows 构建产物：

```text
target\release\Lecoo-Control-Center-GUI.exe
```

## 配置后端 CLI

程序首先检查 `LECOO_CTRL` 环境变量；如果没有设置，则回退到系统 `PATH`。

Linux：

```bash
export LECOO_CTRL=/path/to/lecoo-ctrl
./target/release/Lecoo-Control-Center-GUI
```

Windows PowerShell：

```powershell
$env:LECOO_CTRL = "C:\path\to\lecoo-ctrl.exe"
.\target\release\Lecoo-Control-Center-GUI.exe
```

如果不设置 `LECOO_CTRL`，将 `lecoo-ctrl` 安装到系统 `PATH` 即可。

实时监控由 GUI 内部定时器执行，按固定间隔调用 CLI 查询温度和风扇数据，不运行无限循环的监控子进程。

## Windows 打包

Windows 构建需要 Visual Studio 2022 Build Tools、MSVC Rust toolchain，以及 Qt 6.5+ 的 MSVC 版本。

```powershell
cargo build --release
.\scripts\package-windows.ps1 -QtBin C:\Qt\6.8.3\msvc2022_64\bin
```

打包脚本会：

1. 使用 `windeployqt` 部署 Qt DLL、QML 模块和平台插件。
2. 部署 MSVC 运行库和内置字体许可证。
3. 将 EXE、Qt 运行时和插件放在 `target\release\` 中。
4. 删除 Cargo 构建专用的中间目录。

常用选项：

```powershell
# 不重新构建，只部署已有的 release 构建
.\scripts\package-windows.ps1 -QtBin C:\Qt\6.8.3\msvc2022_64\bin -NoBuild

# 保留 Cargo 增量构建目录
.\scripts\package-windows.ps1 -QtBin C:\Qt\6.8.3\msvc2022_64\bin -KeepBuildFiles
```

单独运行 `cargo build --release` 不会部署 Qt 运行时；发布 Windows 程序时应使用打包脚本。

## 项目结构

```text
.
├── assets/              # 应用图标、字体和字体许可证
├── qml/                 # 主窗口、Material 3 组件和翻译
├── src/                 # Rust 后端和 Qt 桥接
├── scripts/             # Windows 打包辅助脚本
├── build.rs             # QML、资源和 Windows 图标构建配置
├── deny.toml            # 依赖许可证策略
├── LICENSE              # GPL-3.0-only
└── THIRD-PARTY-NOTICES.md
```

## 检查

```bash
cargo fmt --check
cargo check
cargo test
cargo deny check
```

## 许可证和致谢

本项目使用 **GPL-3.0-only**，详见 [LICENSE](LICENSE)。

QML 设计参考Material Design 3风格设计。内置图标字体 Material Icons Round 使用 Apache License 2.0，内置文本字体 Noto Sans SC 使用 SIL Open Font License 1.1。字体许可证和依赖声明见 [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md)。

`lecoo-ctrl` 和 `lecoo-ec-daemon` 属于独立的 MIT 许可证后端项目：<https://github.com/LaVashikk/Lecoo-Control-Center>。
