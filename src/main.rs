// Hide the Windows console in release builds.
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

mod backend;

use cxx_qt::casting::Upcast;
use cxx_qt_lib::{QGuiApplication, QQmlApplicationEngine, QQmlEngine, QString, QUrl};

fn main() {
    cxx_qt::init_qml_module!("io.lecooctrl.gui");

    // Use Qt's threaded render loop on Wayland.
    #[cfg(target_os = "linux")]
    if std::env::var_os("QSG_RENDER_LOOP").is_none() {
        // SAFETY: still single-threaded here, so no environment race is possible.
        unsafe {
            std::env::set_var("QSG_RENDER_LOOP", "threaded");
        }
    }

    let mut app = QGuiApplication::new();

    // Application identity; the desktop file name drives the Wayland app_id.
    if let Some(mut app_ref) = app.as_mut() {
        app_ref.as_mut().set_application_name(&QString::from("io.lecooctrl.gui"));
        app_ref.as_mut().set_organization_name(&QString::from("lecooctrl"));
        app_ref.as_mut().set_organization_domain(&QString::from("lecooctrl.gui"));
        app_ref.as_mut().set_application_version(&QString::from("0.5.2"));
        // Use the Basic Qt Quick Controls style.
        backend::qobject::set_quick_controls_style(&QString::from("Basic"));

        // Icon embedded by build.rs, so it stays valid in a packaged release.
        backend::qobject::set_application_icon();
        // Wayland app_id / X11 WM_CLASS.
        backend::qobject::set_desktop_file_name(&QString::from("io.lecooctrl.gui"));
    }

    let mut engine = QQmlApplicationEngine::new();

    if let Some(mut engine_ref) = engine.as_mut() {
        engine_ref
            .as_mut()
            .on_object_created(|_, object, url| {
                if object.is_null() {
                    eprintln!("GUI: QML root object creation failed: {url}");
                    std::process::exit(1);
                }
            })
            .release();

        let mut engine: std::pin::Pin<&mut QQmlEngine> = engine_ref.as_mut().upcast_pin();
        engine.as_mut().set_output_warnings_to_standard_error(true);
        engine.on_quit(|_| {}).release();
        engine_ref.as_mut().load(&QUrl::from("qrc:/qt/qml/io/lecooctrl/gui/qml/main.qml"));
    }

    if let Some(app_ref) = app.as_mut() {
        app_ref.exec();
    }
}
