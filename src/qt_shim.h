#pragma once

#include <QString>

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

// OS description for the device-info page (QSysInfo is not exposed by cxx-qt-lib).
QString lecooOsName();
QString lecooOsVersion();
