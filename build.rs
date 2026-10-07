use cxx_qt_build::{CxxQtBuilder, QResource, QResources, QmlFile, QmlModule};

#[cfg(windows)]
fn configure_windows_icon() {
    let mut resource = winres::WindowsResource::new();
    resource.set_icon("assets/app-icon.ico");
    resource.set("ProductName", "Lecoo Control Center");
    resource.set("FileDescription", "Lecoo Control Center");
    resource.compile().expect("failed to embed the Windows application icon");
}

#[cfg(not(windows))]
fn configure_windows_icon() {}

/// QML components registered into the module's resource folder.
const MD3_COMPONENTS: &[&str] = &[
    "Card.qml",
    "Chip.qml",
    "CircularProgress.qml",
    "Divider.qml",
    "IconButton.qml",
    "ListTile.qml",
    "MaterialButton.qml",
    "MaterialSymbol.qml",
    "NavigationRail.qml",
    "NavigationRailButton.qml",
    "PointingHandInteraction.qml",
    "RippleButton.qml",
    "SegmentedButton.qml",
    "SettingsRow.qml",
    "StyledFlickable.qml",
    "StyledProgressBar.qml",
    "StyledRectangularShadow.qml",
    "StyledScrollBar.qml",
    "StyledSlider.qml",
    "StyledSwitch.qml",
    "StyledText.qml",
    "StyledToolTip.qml",
    "WavyLine.qml",
];

/// Application specific components built on top of the MD3 primitives.
const APP_COMPONENTS: &[&str] = &[
    "MetricCard.qml",
    "FanPanel.qml",
    "StatusCard.qml",
    "PageScroll.qml",
    "ProfileSelector.qml",
    "SchemeCard.qml",
    "StatusRailButton.qml",
    "LicenseDialog.qml",
];

fn main() {
    configure_windows_icon();

    let mut qml_files = vec![
        QmlFile::from("qml/main.qml"),
        // Design-token / helper singletons.
        QmlFile::from("qml/md3/Appearance.qml").singleton(true),
        QmlFile::from("qml/md3/ColorUtils.qml").singleton(true),
        QmlFile::from("qml/i18n/I18n.qml").singleton(true),
    ];

    qml_files.extend(MD3_COMPONENTS.iter().map(|name| QmlFile::from(format!("qml/md3/{name}"))));
    qml_files.extend(APP_COMPONENTS.iter().map(|name| QmlFile::from(format!("qml/components/{name}"))));

    let builder =
        CxxQtBuilder::new_qml_module(QmlModule::new("io.lecooctrl.gui").qml_files(qml_files).depends([
            "QtQuick.Controls",
            "QtQuick.Effects",
            "Qt5Compat.GraphicalEffects",
        ]))
        .qrc_resources(
            QResources::new().resources([
                // Application icon used by QGuiApplication on Linux and Windows.
                QResource::new().prefix("/").file("assets/app-icon.png"),
                // Register the bundled icon and text fonts.
                QResource::new().prefix("/").file("assets/fonts/MaterialIconsRound-Regular.otf"),
                QResource::new().prefix("/").file("assets/fonts/NotoSansSC-VF.ttf"),
                // Register JavaScript modules used by the palette.
                QResource::new().prefix("/qt/qml/io/lecooctrl/gui").file("qml/md3/PaletteGen.js"),
                // The colour maths PaletteGen.js imports from the same directory.
                QResource::new()
                    .prefix("/qt/qml/io/lecooctrl/gui")
                    .file("qml/md3/MaterialColorUtilities.js"),
                // External translation tables imported by I18n.qml.
                QResource::new().prefix("/qt/qml/io/lecooctrl/gui").file("qml/i18n/Translations.js"),
                QResource::new()
                    .prefix("/qt/qml/io/lecooctrl/gui")
                    .file("qml/i18n/translations/zh_CN.js"),
                QResource::new()
                    .prefix("/qt/qml/io/lecooctrl/gui")
                    .file("qml/i18n/translations/en_US.js"),
            ]),
        )
        .files(["src/backend.rs"])
        .cpp_file("src/qt_shim.cpp")
        .qt_module("Quick")
        .qt_module("QuickControls2");

    // Compile the C++ shim as UTF-8 on MSVC.
    let builder = unsafe {
        builder.cc_builder(|cc| {
            if cc.get_compiler().is_like_msvc() {
                cc.flag("/utf-8");
            }
        })
    };

    builder.build();
}
