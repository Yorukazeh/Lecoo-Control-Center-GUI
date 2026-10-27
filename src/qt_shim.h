#pragma once

#include <QObject>
#include <QString>
#include <QStringList>
#include <QGuiApplication>
#include <memory>

// Set the application icon.
void lecooSetApplicationIcon();

// Sets the Wayland app_id / X11 WM_CLASS (not exposed by cxx-qt-lib).
void lecooSetDesktopFileName(const QString &name);

// Select the Qt Quick Controls style.
void lecooSetQuickControlsStyle(const QString &style);

// Platform default UI text font family (no text font is bundled).
QString lecooSystemFontFamily();

// Platform default monospace font family (license viewer).
QString lecooFixedFontFamily();

// Return the screen under the cursor.
QString lecooCursorScreenName();

// Return the active Qt platform plugin name.
QString lecooPlatformName();

// OS description for the device-info page (QSysInfo is not exposed by cxx-qt-lib).
QString lecooOsName();
QString lecooOsVersion();

// QApplication is required by the native tray menu, even with Qt Quick windows.
std::unique_ptr<QGuiApplication> lecooNewApplication(const QStringList &args);
bool lecooTrayAvailable();
void lecooInitTray(QObject &controller);
// Five labels: Show, Silent, Balanced, Performance, Quit. Action IDs stay 0..4.
void lecooTraySetMenu(const QStringList &items, int checkedIndex, bool enabled);
