import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Effects
import QtCore
import io.lecooctrl.gui 1.0


// LECOO Control Center.
ApplicationWindow {
    id: appWindow
    visible: true
    width: 1280
    height: 800
    title: "Lecoo Control Center"
    color: Appearance.colors.colLayer0

    Settings {
        id: settings
        category: "appearance"
        property bool darkModeStored: true
        property bool followSystemStored: false
        property int themeIndexStored: 1
        property bool customThemeStored: false
        property real customHueStored: 285
        property real customChromaStored: 26
        property string schemeVariantStored: "tonalSpot"
        property string languageStored: ""
        property string profileStored: "default"
        property string chargeStored: "balanced"
        property string kbdModeStored: "medium"
        property int kbdPwmStored: 160
        property int ledBrightnessStored: 128
        property int windowWidthStored: 0
        property int windowHeightStored: 0
    }

    property int currentPage: 0
    property bool themeTransitionRunning: false
    property bool themeRippleActive: false
    property bool pendingThemeDarkMode: true
    // Store the pre-theme backdrop for transparent pixels and the window gutter.
    property color frozenBackdrop: Appearance.colors.colLayer0
    property real rippleProgress: 0
    property var themeSnapshotGrab: null
    // Store the reveal origin in window coordinates.
    property real rippleX: 0
    property real rippleY: 0
    // Item the running reveal grows from, so a window resize can recompute the centre.
    property var rippleOrigin: null
    // Store the origin supplied by a system-theme change.
    property var followSystemOrigin: null
    readonly property real coverRadius: Math.hypot(width, height) + 2
    readonly property real rippleRadius: rippleProgress * coverRadius
    property int railPreference: 0 // 0 = auto, 1 = expanded, -1 = collapsed

    readonly property real railMargin: 10
    readonly property real railSpacing: 10
    readonly property real railExpandedWidth: 220
    readonly property real railCollapsedWidth: 72
    readonly property real pageMinWidth: 520
    readonly property real pageMinViewport: pageMinWidth + 48
    readonly property real expandedSpace: 2 * railMargin + railSpacing + railExpandedWidth
    readonly property real collapsedSpace: 2 * railMargin + railSpacing + railCollapsedWidth
    readonly property bool railCanExpand: width - expandedSpace >= pageMinViewport
    readonly property bool railExpanded: railPreference < 0 ? false : railCanExpand
    readonly property real pageAvailableWidth: Math.max(0, width - (railExpanded ? expandedSpace : collapsedSpace) - 48)

    property bool followSystemTheme: settings.followSystemStored
    property string selectedProfile: settings.profileStored
    property string selectedCharge: settings.chargeStored
    property string kbdMode: settings.kbdModeStored
    property int kbdPwm: settings.kbdPwmStored
    property int ledBrightness: settings.ledBrightnessStored
    property string noticeKey: ""
    readonly property string noticeText: noticeKey.length > 0 ? I18n.t(noticeKey) : ""
    property string languageSetting: settings.languageStored
    readonly property string effectiveLanguage: languageSetting.length > 0
        ? languageSetting
        : (Qt.uiLanguage.indexOf("zh") === 0 ? "zh_CN" : "en_US")

    function toggleRail() {
        railPreference = railExpanded ? -1 : 1
    }

    // Finish the reveal and release its temporary frame.
    function finishThemeRipple() {
        themeRippleWatchdog.stop()
        themeRippleActive = false
        themeTransitionRunning = false
        themeSnapshot.source = ""
        themeSnapshotGrab = null
        rippleOrigin = null
    }

    // Start the reveal after the old-theme frame is ready.
    function startThemeRipple() {
        if (themeRippleActive || !themeTransitionRunning)
            return
        if (themeSnapshot.status !== Image.Ready)
            return

        themeRippleWatchdog.stop()
        themeRippleActive = true
        rippleProgress = 0
        Appearance.darkMode = pendingThemeDarkMode
        // Refresh the origin after the snapshot is ready.
        refreshRippleCenter()
        rippleAnimation.restart()
    }

    // Apply the theme immediately if the snapshot cannot be created.
    function forceThemeRipple() {
        if (!themeTransitionRunning)
            return

        Appearance.darkMode = pendingThemeDarkMode
        finishThemeRipple()
    }

    // Recompute the reveal origin after layout or window changes.
    function refreshRippleCenter() {
        if (!rippleOrigin)
            return
        var centre = rippleOrigin.mapToItem(appWindow.contentItem,
            rippleOrigin.width / 2, rippleOrigin.height / 2)
        rippleX = centre.x
        rippleY = centre.y
    }

    // Capture the old theme and reveal the new palette from the requested origin.
    function revealTheme(origin, dark) {
        if (themeTransitionRunning || Appearance.darkMode === dark)
            return false

        rippleOrigin = origin
        refreshRippleCenter()

        // Capture the backdrop before changing the palette.
        frozenBackdrop = Appearance.colors.colLayer0
        pendingThemeDarkMode = dark
        themeTransitionRunning = true
        themeSnapshotGrab = appContent.grabToImage(function(result) {
            // Ignore a late snapshot callback after the transition ends.
            if (!themeTransitionRunning)
                return
            if (!result) {
                forceThemeRipple()
                return
            }
            themeSnapshotGrab = result
            themeSnapshot.source = result.url
            startThemeRipple()
        })
        themeRippleWatchdog.restart()
        return true
    }

    // Toggle the theme from the navigation rail and stop following the system.
    function toggleThemeMode() {
        followSystemTheme = false
        revealTheme(themeModeButton, !Appearance.darkMode)
    }

    // Toggle dark mode and restore the switch if the transition is refused.
    function setDarkMode(control, dark) {
        followSystemTheme = false
        if (!revealTheme(control, dark))
            control.checked = Qt.binding(function() { return Appearance.darkMode })
    }

    // Toggle system-theme following and pass its reveal origin to applySystemTheme().
    function setFollowSystemTheme(control, enabled) {
        if (!enabled) {
            followSystemTheme = false
            return
        }
        followSystemOrigin = control
        followSystemTheme = true
    }

    // Clear a stalled theme transition.
    Timer {
        id: themeRippleWatchdog
        interval: 700
        repeat: false
        onTriggered: appWindow.forceThemeRipple()
    }

    ControlCenter { id: backend }

    Timer {
        id: noticeTimer
        interval: 4000
        repeat: false
        onTriggered: appWindow.noticeKey = ""
    }

    Timer {
        id: monitorTimer
        interval: 1000
        repeat: true
        running: backend.monitoring
        onTriggered: backend.refreshAll()
    }

    function showNotice(key) {
        appWindow.noticeKey = key
        noticeTimer.restart()
    }

    // Apply the system theme with an optional reveal origin.
    function applySystemTheme(origin) {
        if (!appWindow.followSystemTheme)
            return
        var dark = Application.styleHints.colorScheme === Qt.Dark
        if (Appearance.darkMode === dark)
            return
        if (!origin || !appWindow.revealTheme(origin, dark))
            Appearance.darkMode = dark
    }

    // Handle window placement across screens and scale factors.
    readonly property int windowTitleBarHeight: 32
    readonly property int windowMinReachableWidth: 96
    readonly property int windowScreenMargin: 24
    // Keep the window at or above the layout's minimum size.
    readonly property int windowMinWidth: 800
    readonly property int windowMinHeight: 600

    // Restore undersized windows without changing managed states.
    function clampWindowSize() {
        if (appWindow.visibility !== Window.Windowed)
            return
        if (appWindow.width < appWindow.windowMinWidth)
            appWindow.width = appWindow.windowMinWidth
        if (appWindow.height < appWindow.windowMinHeight)
            appWindow.height = appWindow.windowMinHeight
    }

    // Preserve the user size while crossing mixed-DPI monitors.
    property real rememberedWidth: 0
    property real rememberedHeight: 0
    // Mark programmatic resizes so they are not persisted.
    property bool settlingWindow: false

    function rememberWindowSize() {
        if (appWindow.visibility !== Window.Windowed || appWindow.settlingWindow)
            return
        if (appWindow.width < appWindow.windowMinWidth
                || appWindow.height < appWindow.windowMinHeight)
            return
        appWindow.rememberedWidth = appWindow.width
        appWindow.rememberedHeight = appWindow.height
    }

    function settleWindowAfterCrossing() {
        if (appWindow.visibility !== Window.Windowed || appWindow.rememberedWidth <= 0)
            return
        if (Math.abs(appWindow.width - appWindow.rememberedWidth) < 0.5
                && Math.abs(appWindow.height - appWindow.rememberedHeight) < 0.5)
            return
        appWindow.settlingWindow = true
        appWindow.width = appWindow.rememberedWidth
        appWindow.height = appWindow.rememberedHeight
        settleGuard.restart()
    }

    // Return the screen under the cursor.
    function screenUnderCursor() {
        var screens = Qt.application.screens
        if (!screens)
            return null
        var cursorScreen = backend.cursorScreenName()
        for (var i = 0; i < screens.length; ++i) {
            if (screens[i].name === cursorScreen)
                return screens[i]
        }
        return null
    }

    // Center the window on a screen while respecting its bounds.
    function placeWindowOn(targetScreen) {
        var screens = Qt.application.screens
        var target = targetScreen ? targetScreen : appWindow.screen
        if (!target && screens && screens.length > 0)
            target = screens[0]
        if (!target || target.width <= 0)
            return

        // Use the intended size instead of transient move geometry.
        var wantWidth = appWindow.width
        var wantHeight = appWindow.height
        var maxWidth = target.width - 2 * appWindow.windowScreenMargin
        var maxHeight = target.height - 2 * appWindow.windowScreenMargin
        // Clamp the target size to layout and screen limits.
        if (wantWidth > maxWidth)
            wantWidth = Math.max(appWindow.windowMinWidth, maxWidth)
        else if (wantWidth < appWindow.windowMinWidth)
            wantWidth = appWindow.windowMinWidth
        if (wantHeight > maxHeight)
            wantHeight = Math.max(appWindow.windowMinHeight, maxHeight)
        else if (wantHeight < appWindow.windowMinHeight)
            wantHeight = appWindow.windowMinHeight

        // Set vertical position before horizontal position.
        appWindow.y = Math.round(target.virtualY + (target.height - wantHeight) / 2)
        appWindow.x = Math.round(target.virtualX + (target.width - wantWidth) / 2)
        if (appWindow.width !== wantWidth)
            appWindow.width = wantWidth
        if (appWindow.height !== wantHeight)
            appWindow.height = wantHeight

        // Placement diagnostics are available through Qt's stderr logging.
    }

    // Check whether enough of the title bar remains visible.
    function windowReachableOn(targetScreen) {
        if (!targetScreen || targetScreen.width <= 0)
            return false
        if (appWindow.y < targetScreen.virtualY
                || appWindow.y + appWindow.windowTitleBarHeight > targetScreen.virtualY + targetScreen.height)
            return false
        var left = Math.max(appWindow.x, targetScreen.virtualX)
        var right = Math.min(appWindow.x + appWindow.width, targetScreen.virtualX + targetScreen.width)
        return (right - left) >= appWindow.windowMinReachableWidth
    }

    // Move an unreachable window back onto a screen.
    function ensureWindowOnScreen() {
        // Leave maximized and fullscreen windows to the window manager.
        if (appWindow.visibility === Window.Maximized || appWindow.visibility === Window.FullScreen)
            return

        var screens = Qt.application.screens
        if (!screens || screens.length === 0)
            return
        for (var i = 0; i < screens.length; ++i) {
            if (appWindow.windowReachableOn(screens[i]))
                return
        }

        appWindow.placeWindowOn(appWindow.screenUnderCursor())
    }

    Component.onCompleted: {
        // Load platform font families before the first frame.
        Appearance.systemFontFamily = backend.systemFontFamily()
        Appearance.systemFixedFontFamily = backend.fixedFontFamily()
        I18n.language = appWindow.effectiveLanguage
        if (settings.windowWidthStored >= appWindow.windowMinWidth)
            appWindow.width = settings.windowWidthStored
        if (settings.windowHeightStored >= appWindow.windowMinHeight)
            appWindow.height = settings.windowHeightStored
        Appearance.darkMode = settings.darkModeStored
        Appearance.themeIndex = settings.themeIndexStored
        Appearance.customTheme = settings.customThemeStored
        Appearance.customHue = settings.customHueStored
        Appearance.customChroma = settings.customChromaStored
        Appearance.schemeVariant = settings.schemeVariantStored
        appWindow.applySystemTheme()
        backend.refreshAll()
        backend.refreshInfo()
        backend.refreshPowerProfile()
        // Place the window after restoring its saved size.
        appWindow.placeWindowOn(appWindow.screenUnderCursor())
    }

    Connections {
        target: Appearance
        function onDarkModeChanged() {
            settings.darkModeStored = Appearance.darkMode
        }
        function onThemeIndexChanged() {
            settings.themeIndexStored = Appearance.themeIndex
        }
        function onCustomThemeChanged() {
            settings.customThemeStored = Appearance.customTheme
        }
        function onCustomHueChanged() {
            settings.customHueStored = Appearance.customHue
        }
        function onCustomChromaChanged() {
            settings.customChromaStored = Appearance.customChroma
        }
        function onSchemeVariantChanged() {
            settings.schemeVariantStored = Appearance.schemeVariant
        }
    }

    onFollowSystemThemeChanged: {
        settings.followSystemStored = followSystemTheme
        appWindow.applySystemTheme(appWindow.followSystemOrigin)
        appWindow.followSystemOrigin = null
    }

    onSelectedProfileChanged: settings.profileStored = selectedProfile
    onSelectedChargeChanged: settings.chargeStored = selectedCharge
    onKbdModeChanged: settings.kbdModeStored = kbdMode
    onKbdPwmChanged: settings.kbdPwmStored = kbdPwm
    onLedBrightnessChanged: settings.ledBrightnessStored = ledBrightness

    // Recheck placement when the assigned screen changes.
    onScreenChanged: {
        appWindow.ensureWindowOnScreen()
        settleTimer.restart()
    }

    // Reconcile geometry when the screen scale changes.
    readonly property real windowScale: appWindow.screen
                                        ? appWindow.screen.devicePixelRatio : 1
    onWindowScaleChanged: settleTimer.restart()

    Timer {
        id: settleTimer
        // Wait briefly for monitor crossing to settle.
        interval: 350
        onTriggered: appWindow.settleWindowAfterCrossing()
    }

    Timer {
        id: settleGuard
        // Clear the resize guard after geometry settles.
        interval: 800
        onTriggered: appWindow.settlingWindow = false
    }

    Timer {
        id: rememberSizeTimer
        // Save geometry after resize events become quiet.
        interval: 500
        onTriggered: appWindow.rememberWindowSize()
    }

    onVisibilityChanged: {
        // Restore visibility after a screen disappears.
        if (appWindow.visibility === Window.Windowed)
            appWindow.ensureWindowOnScreen()
    }

    // Persist the window size after resizing and closing.
    onWidthChanged: {
        appWindow.clampWindowSize()
        windowSizeSaveTimer.restart()
        rememberSizeTimer.restart()
        if (themeRippleActive)
            refreshRippleCenter()
    }
    onHeightChanged: {
        appWindow.clampWindowSize()
        windowSizeSaveTimer.restart()
        rememberSizeTimer.restart()
        if (themeRippleActive)
            refreshRippleCenter()
    }

    Timer {
        id: windowSizeSaveTimer
        interval: 400
        repeat: false
        onTriggered: {
            settings.windowWidthStored = appWindow.width
            settings.windowHeightStored = appWindow.height
            settings.sync()
        }
    }

    onClosing: {
        settings.windowWidthStored = appWindow.width
        settings.windowHeightStored = appWindow.height
        settings.sync()
    }
    onEffectiveLanguageChanged: I18n.language = effectiveLanguage
    onLanguageSettingChanged: settings.languageStored = languageSetting

    Connections {
        target: Application.styleHints
        function onColorSchemeChanged() {
            appWindow.applySystemTheme()
        }
    }

    Connections {
        target: backend
        function onStatusMessageChanged() {
            if (backend.statusMessage.length > 0)
                appWindow.showNotice(backend.statusMessage)
        }
        function onErrorMessageChanged() {
            if (backend.errorMessage.length > 0)
                errorPopup.open()
        }
        function onPowerProfileChanged() {
            if (["silent", "default", "perf"].indexOf(backend.powerProfile) !== -1)
                appWindow.selectedProfile = backend.powerProfile
        }
    }

    RowLayout {
        id: appContent
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Rectangle {
            id: navRail
            Layout.fillHeight: true
            implicitWidth: appWindow.railExpanded ? appWindow.railExpandedWidth : appWindow.railCollapsedWidth
            color: Appearance.colors.colLayer1
            radius: Appearance.rounding.normal
            clip: true

            Behavior on implicitWidth {
                animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 4

                Item {
                    id: railHeader
                    Layout.fillWidth: true
                    implicitHeight: 56

                    HoverHandler {
                        id: headerHover
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: appWindow.toggleRail()
                    }

                    Rectangle {
                        id: logo
                        width: appWindow.railExpanded ? 40 : 34
                        height: width
                        radius: Appearance.rounding.small
                        // Center the logo in the rail's icon column.
                        readonly property real leadingZone: Math.min(parent.width, 56)
                        x: (leadingZone - width) / 2
                        anchors.verticalCenter: parent.verticalCenter
                        gradient: Gradient {
                            GradientStop {
                                position: 0
                                color: Appearance.colors.colPrimary
                            }
                            GradientStop {
                                position: 1
                                color: Appearance.colors.colTertiary
                            }
                        }

                        MaterialSymbol {
                            anchors.centerIn: parent
                            text: "grid_view"
                            // Use icon sizes that align both glyphs to their tiles.
                            iconSize: appWindow.railExpanded ? 22 : 20
                            color: Appearance.colors.colOnPrimary
                        }
                    }

                    ColumnLayout {
                        visible: appWindow.railExpanded
                        anchors {
                            left: logo.right
                            leftMargin: 10
                            verticalCenter: parent.verticalCenter
                        }
                        spacing: 0

                        StyledText {
                            text: "LECOO"
                            color: Appearance.colors.colOnSurface
                            font.pixelSize: 15
                            font.weight: Font.Medium
                            elide: Text.ElideRight
                        }
                        StyledText {
                            text: "Control Center"
                            color: Appearance.colors.colSubtext
                            font.pixelSize: 12
                            typeScale: "labelMedium"
                        }
                    }

                    MaterialSymbol {
                        visible: appWindow.railExpanded
                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }
                        text: "menu_open"
                        iconSize: 20
                        color: Appearance.colors.colOnSurfaceVariant
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 1
                    color: Appearance.colors.colOutlineVariant
                    opacity: 0.5
                }

                NavigationRailButton {
                    expanded: appWindow.railExpanded
                    buttonIcon: "dashboard"
                    buttonText: I18n.t("nav.dashboard")
                    toggled: appWindow.currentPage === 0
                    onPressed: appWindow.currentPage = 0
                }
                NavigationRailButton {
                    expanded: appWindow.railExpanded
                    buttonIcon: "tune"
                    buttonText: I18n.t("nav.controls")
                    toggled: appWindow.currentPage === 1
                    onPressed: appWindow.currentPage = 1
                }
                NavigationRailButton {
                    expanded: appWindow.railExpanded
                    buttonIcon: "info"
                    buttonText: I18n.t("nav.info")
                    toggled: appWindow.currentPage === 2
                    onPressed: appWindow.currentPage = 2
                }
                NavigationRailButton {
                    expanded: appWindow.railExpanded
                    buttonIcon: "palette"
                    buttonText: I18n.t("nav.palette")
                    toggled: appWindow.currentPage === 3
                    onPressed: appWindow.currentPage = 3
                }

                Item { Layout.fillHeight: true }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 1
                    color: Appearance.colors.colOutlineVariant
                    opacity: 0.5
                }

                NavigationRailButton {
                    id: themeModeButton
                    expanded: appWindow.railExpanded
                    buttonIcon: Appearance.darkMode ? "dark_mode" : "light_mode"
                    buttonText: Appearance.darkMode ? I18n.t("sidebar.darkMode") : I18n.t("sidebar.lightMode")
                    onPressed: appWindow.toggleThemeMode()
                }
                NavigationRailButton {
                    expanded: appWindow.railExpanded
                    buttonIcon: "palette"
                    buttonText: Appearance.customTheme ? I18n.t("sidebar.customTheme") : I18n.themeName(Appearance.theme.name)
                    onPressed: {
                        Appearance.customTheme = false
                        Appearance.themeIndex = (Appearance.themeIndex + 1) % Appearance.themes.length
                    }
                }
                NavigationRailButton {
                    expanded: appWindow.railExpanded
                    buttonIcon: "refresh"
                    buttonText: I18n.t("sidebar.refresh")
                    onPressed: backend.refreshAll()
                }
                StatusRailButton {
                    expanded: appWindow.railExpanded
                    dotColor: backend.connected ? Appearance.colors.colSuccess : Appearance.colors.colError
                    buttonText: backend.connected ? I18n.t("sidebar.online") : I18n.t("sidebar.offline")
                    onPressed: backend.refreshAll()
                }
            }
        }

        StackLayout {
            id: pageStack
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: appWindow.currentPage

            PageScroll {
                id: dashboardPage
                active: StackLayout.isCurrentItem

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 14

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        StyledText {
                            text: I18n.t("dashboard.welcome")
                            color: Appearance.colors.colOnSurface
                            font.pixelSize: 28
                            font.weight: Font.Medium
                        }
                        StyledText {
                            text: !backend.connected
                                ? I18n.t("dashboard.subtitleOffline")
                                : backend.monitoring
                                    ? I18n.t("dashboard.subtitleOnline")
                                    : I18n.t("dashboard.subtitleMonitorOff")
                            color: Appearance.colors.colOnSurfaceVariant
                            font.pixelSize: 13
                        }
                    }

                    MaterialButton {
                        variant: MaterialButton.Variant.Filled
                        buttonText: I18n.t("dashboard.refresh")
                        buttonIcon: "refresh"
                        onClicked: backend.refreshAll()
                    }
                }

                Card {
                    Layout.fillWidth: true
                    implicitHeight: 156
                    colBackground: Appearance.colors.colPrimaryContainer

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 20

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            StyledText {
                                text: backend.connected ? I18n.t("dashboard.ok") : I18n.t("dashboard.waiting")
                                color: Appearance.colors.colOnPrimaryContainer
                                font.pixelSize: 22
                                font.weight: Font.Medium
                            }
                            StyledText {
                                Layout.fillWidth: true
                                text: backend.connected ? I18n.t("dashboard.detailOnline") : I18n.t("dashboard.detailOffline")
                                color: Appearance.colors.colOnPrimaryContainer
                                font.pixelSize: 12
                                opacity: 0.85
                            }
                            StyledText {
                                Layout.fillWidth: true
                                visible: backend.lastUpdate.length > 0
                                text: I18n.t("dashboard.dataSource", backend.lastUpdate)
                                color: Appearance.colors.colOnPrimaryContainer
                                font.pixelSize: 11
                                opacity: 0.7
                            }
                        }

                        Rectangle {
                            Layout.preferredWidth: 1
                            Layout.preferredHeight: 72
                            color: Appearance.colors.colOnPrimaryContainer
                            opacity: 0.3
                        }

                        ColumnLayout {
                            Layout.preferredWidth: 180
                            spacing: 4
                            StyledText {
                                text: I18n.t("dashboard.currentProfile")
                                color: Appearance.colors.colOnPrimaryContainer
                                font.pixelSize: 12
                                opacity: 0.85
                            }
                            StyledText {
                                text: backend.powerProfile.length > 0 ? backend.powerProfile : appWindow.selectedProfile
                                color: Appearance.colors.colOnPrimaryContainer
                                font.pixelSize: 20
                                font.weight: Font.Medium
                            }
                            StyledText {
                                text: I18n.t("dashboard.ecConfig")
                                color: Appearance.colors.colOnPrimaryContainer
                                font.pixelSize: 11
                                opacity: 0.7
                            }
                        }
                    }
                }

                GridLayout {
                    Layout.fillWidth: true
                    columns: appWindow.pageAvailableWidth < 720 ? 2 : 4
                    columnSpacing: 14
                    rowSpacing: 14

                    MetricCard {
                        label: I18n.t("metric.cpuTemp")
                        value: backend.cpuTemperature > 0 ? backend.cpuTemperature : "--"
                        unit: "°C"
                        progress: backend.cpuTemperature / 100.0
                        accent: Appearance.colors.colError
                        icon: "thermostat"
                    }
                    MetricCard {
                        label: I18n.t("metric.sysTemp")
                        value: backend.systemTemperature > 0 ? backend.systemTemperature : "--"
                        unit: "°C"
                        progress: backend.systemTemperature / 100.0
                        accent: Appearance.colors.colTertiary
                        icon: "device_thermostat"
                    }
                    MetricCard {
                        label: I18n.t("metric.cpuFan")
                        value: backend.cpuFanRpm > 0 ? backend.cpuFanRpm : "--"
                        unit: "RPM"
                        progress: backend.cpuFanRpm / 7000.0
                        accent: Appearance.colors.colPrimary
                        icon: "cyclone"
                    }
                    MetricCard {
                        label: I18n.t("metric.gpuFan")
                        value: backend.gpuFanRpm > 0 ? backend.gpuFanRpm : "--"
                        unit: "RPM"
                        progress: backend.gpuFanRpm / 7000.0
                        accent: Appearance.colors.colSecondary
                        icon: "air"
                    }
                }

                GridLayout {
                    Layout.fillWidth: true
                    columns: appWindow.pageAvailableWidth < 820 ? 1 : 2
                    columnSpacing: 14
                    rowSpacing: 14

                    Card {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumWidth: 300
                        implicitHeight: 172
                        title: I18n.t("dashboard.perfTitle")
                        leadingIcon: "bolt"
                        subtitle: I18n.t("dashboard.perfSubtitle")

                        ProfileSelector {
                            selected: appWindow.selectedProfile
                            onProfileChosen: function (key) {
                                appWindow.selectedProfile = key
                                backend.applyPowerProfile(key)
                            }
                        }

                        StyledText {
                            Layout.fillWidth: true
                            Layout.topMargin: 4
                            text: appWindow.noticeText
                            color: Appearance.colors.colOnSurfaceVariant
                            font.pixelSize: 12
                            elide: Text.ElideRight
                        }
                    }

                    Card {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 300
                        Layout.maximumWidth: 340
                        Layout.minimumWidth: 200
                        Layout.fillHeight: true
                        implicitHeight: 172

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8
                            StyledText {
                                text: I18n.t("dashboard.monitorTitle")
                                color: Appearance.colors.colOnSurface
                                font.pixelSize: 16
                                font.weight: Font.Medium
                            }
                            StyledText {
                                Layout.fillWidth: true
                                text: backend.monitoring ? I18n.t("dashboard.monitorOn") : I18n.t("dashboard.monitorOff")
                                color: Appearance.colors.colOnSurfaceVariant
                                font.pixelSize: 12
                            }
                            StyledSwitch {
                                text: backend.monitoring ? I18n.t("dashboard.monitorEnabled") : I18n.t("dashboard.monitorDisabled")
                                checked: backend.monitoring
                                onToggled: backend.toggleMonitoring(checked)
                            }
                        }
                    }
                }
            }

            PageScroll {
                id: controlsPage
                active: StackLayout.isCurrentItem

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    StyledText {
                        text: I18n.t("controls.title")
                        color: Appearance.colors.colOnSurface
                        font.pixelSize: 28
                        font.weight: Font.Medium
                    }
                    StyledText {
                        text: I18n.t("controls.subtitle")
                        color: Appearance.colors.colOnSurfaceVariant
                        font.pixelSize: 13
                    }
                }

                Card {
                    Layout.fillWidth: true
                    implicitHeight: 108
                    title: I18n.t("controls.perfTitle")
                    leadingIcon: "bolt"

                    ProfileSelector {
                        selected: appWindow.selectedProfile
                        onProfileChosen: function (key) {
                            appWindow.selectedProfile = key
                            backend.applyPowerProfile(key)
                        }
                    }
                }

                GridLayout {
                    Layout.fillWidth: true
                    columns: appWindow.pageAvailableWidth < 940 ? 1 : 2
                    columnSpacing: 14
                    rowSpacing: 14

                    FanPanel {
                        target: "cpu"
                        accent: Appearance.colors.colPrimary
                        onModeSelected: function (mode, pwm) {
                            backend.applyFanMode(target, mode, pwm)
                        }
                    }

                    FanPanel {
                        target: "gpu"
                        accent: Appearance.colors.colSecondary
                        onModeSelected: function (mode, pwm) {
                            backend.applyFanMode(target, mode, pwm)
                        }
                    }

                    Card {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        title: I18n.t("charge.title")
                        leadingIcon: "battery_charging_full"
                        subtitle: I18n.t("charge.subtitle")

                        Flow {
                            Layout.fillWidth: true
                            spacing: 8

                            Repeater {
                                model: [
                                    { key: "full", label: I18n.t("charge.full"), icon: "battery_full" },
                                    { key: "high", label: I18n.t("charge.high"), icon: "battery_5_bar" },
                                    { key: "balanced", label: I18n.t("charge.balanced"), icon: "balance" },
                                    { key: "lifespan", label: I18n.t("charge.lifespan"), icon: "eco" },
                                    { key: "desk", label: I18n.t("charge.desk"), icon: "power" }
                                ]
                                delegate: Chip {
                                    required property var modelData
                                    buttonText: modelData.label
                                    leadingIcon: modelData.icon
                                    toggled: appWindow.selectedCharge === modelData.key
                                    onClicked: {
                                        appWindow.selectedCharge = modelData.key
                                        backend.applyChargePreset(modelData.key)
                                    }
                                }
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.topMargin: 6
                            spacing: 8
                            MaterialSymbol {
                                text: "info"
                                iconSize: 18
                                color: Appearance.colors.colOnSurfaceVariant
                            }
                            StyledText {
                                Layout.fillWidth: true
                                text: I18n.t("charge.current", I18n.t("charge." + appWindow.selectedCharge))
                                color: Appearance.colors.colOnSurfaceVariant
                                font.pixelSize: 12
                            }
                        }
                    }

                    Card {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        title: I18n.t("kbd.title")
                        leadingIcon: "keyboard"
                        subtitle: I18n.t("kbd.subtitle")

                        Flow {
                            Layout.fillWidth: true
                            spacing: 8

                            Repeater {
                                model: [
                                    { key: "off", label: I18n.t("kbd.off"), icon: "power_settings_new" },
                                    { key: "low", label: I18n.t("kbd.low"), icon: "brightness_low" },
                                    { key: "medium", label: I18n.t("kbd.medium"), icon: "brightness_medium" },
                                    { key: "high", label: I18n.t("kbd.high"), icon: "brightness_high" },
                                    { key: "custom", label: I18n.t("kbd.custom"), icon: "tune" }
                                ]
                                delegate: Chip {
                                    required property var modelData
                                    buttonText: modelData.label
                                    leadingIcon: modelData.icon
                                    toggled: appWindow.kbdMode === modelData.key
                                    onClicked: {
                                        appWindow.kbdMode = modelData.key
                                        if (modelData.key !== "custom")
                                            backend.applyKeyboardMode(modelData.key, appWindow.kbdPwm)
                                    }
                                }
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.topMargin: 4
                            spacing: 12
                            enabled: appWindow.kbdMode === "custom"
                            opacity: appWindow.kbdMode === "custom" ? 1 : 0.5

                            StyledText {
                                text: "PWM"
                                color: Appearance.colors.colOnSurfaceVariant
                                font.pixelSize: 13
                            }
                            StyledSlider {
                                id: kbdPwmSlider
                                Layout.fillWidth: true
                                enabled: appWindow.kbdMode === "custom"
                                from: 0
                                to: 255
                                onValueChanged: {
                                    if (pressed)
                                        appWindow.kbdPwm = Math.round(value)
                                }

                                // Sync the model while the slider is not held.
                                Connections {
                                    target: appWindow
                                    function onKbdPwmChanged() {
                                        if (!kbdPwmSlider.pressed
                                                && Math.abs(kbdPwmSlider.value - appWindow.kbdPwm) > 0.01)
                                            kbdPwmSlider.value = appWindow.kbdPwm
                                    }
                                }
                            }
                            StyledText {
                                Layout.preferredWidth: 40
                                horizontalAlignment: Text.AlignRight
                                text: appWindow.kbdPwm
                                color: Appearance.colors.colPrimary
                                font.pixelSize: 13
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.topMargin: 4
                            MaterialButton {
                                variant: MaterialButton.Variant.Filled
                                buttonText: I18n.t("action.apply")
                                buttonIcon: "check"
                                enabled: appWindow.kbdMode === "custom"
                                buttonColor: down ? Appearance.colors.colPrimaryActive : hovered ? Appearance.colors.colPrimaryHover : Appearance.colors.colPrimary
                                onClicked: backend.applyKeyboardMode(appWindow.kbdMode, appWindow.kbdPwm)
                            }
                            Item { Layout.fillWidth: true }
                        }
                    }
                }

                Card {
                    Layout.fillWidth: true
                    implicitHeight: 214
                    title: I18n.t("led.title")
                    leadingIcon: "lightbulb"
                    subtitle: I18n.t("led.subtitle")

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        StyledText {
                            text: I18n.t("led.brightness")
                            color: Appearance.colors.colOnSurfaceVariant
                            font.pixelSize: 13
                        }
                        StyledSlider {
                            id: ledBrightnessSlider
                            Layout.fillWidth: true
                            from: 0
                            to: 255
                            onValueChanged: {
                                if (pressed)
                                    appWindow.ledBrightness = Math.round(value)
                            }

                            // Sync brightness while the slider is not held.
                            Connections {
                                target: appWindow
                                function onLedBrightnessChanged() {
                                    if (!ledBrightnessSlider.pressed
                                            && Math.abs(ledBrightnessSlider.value - appWindow.ledBrightness) > 0.01)
                                        ledBrightnessSlider.value = appWindow.ledBrightness
                                }
                            }
                        }
                        StyledText {
                            Layout.preferredWidth: 40
                            horizontalAlignment: Text.AlignRight
                            text: appWindow.ledBrightness
                            color: Appearance.colors.colPrimary
                            font.pixelSize: 13
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10
                        MaterialButton {
                            variant: MaterialButton.Variant.Tonal
                            buttonText: I18n.t("led.auto")
                            buttonIcon: "auto_mode"
                            onClicked: backend.applyLedMode("auto", 0)
                        }
                        MaterialButton {
                            variant: MaterialButton.Variant.Filled
                            buttonText: I18n.t("action.apply")
                            buttonIcon: "check"
                            onClicked: backend.applyLedMode("custom", appWindow.ledBrightness)
                        }
                        Item { Layout.fillWidth: true }
                    }
                }
            }

            PageScroll {
                id: infoPage
                active: StackLayout.isCurrentItem

                Component.onCompleted: backend.refreshCliInfo()

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 14

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        StyledText {
                            text: I18n.t("info.title")
                            color: Appearance.colors.colOnSurface
                            font.pixelSize: 28
                            font.weight: Font.Medium
                        }
                        StyledText {
                            text: I18n.t("info.subtitle")
                            color: Appearance.colors.colOnSurfaceVariant
                            font.pixelSize: 13
                        }
                    }

                    MaterialButton {
                        variant: MaterialButton.Variant.Filled
                        buttonText: I18n.t("info.reload")
                        buttonIcon: "refresh"
                        onClicked: {
                            backend.refreshInfo()
                            backend.refreshPowerProfile()
                        }
                    }
                }

                Card {
                    Layout.fillWidth: true
                    Layout.minimumHeight: 150
                    colBackground: Appearance.colors.colPrimaryContainer
                    title: I18n.t("info.controllerTitle")
                    colContent: Appearance.colors.colOnPrimaryContainer
                    leadingIcon: "memory"

                    StyledText {
                        Layout.fillWidth: true
                        text: backend.controllerInfo.length > 0 ? backend.controllerInfo : I18n.t("info.waiting")
                        color: Appearance.colors.colOnPrimaryContainer
                        font.pixelSize: 16
                        wrapMode: Text.WordWrap
                    }
                    StyledText {
                        Layout.fillWidth: true
                        text: I18n.t("info.controllerSource")
                        color: Appearance.colors.colOnPrimaryContainer
                        font.pixelSize: 11
                        opacity: 0.75
                    }
                }

                GridLayout {
                    Layout.fillWidth: true
                    columns: appWindow.pageAvailableWidth < 760 ? 2 : 4
                    columnSpacing: 14
                    rowSpacing: 14

                    StatusCard {
                        label: I18n.t("info.connection")
                        value: backend.connected ? I18n.t("info.connected") : I18n.t("info.disconnected")
                        valueColor: backend.connected ? Appearance.colors.colSuccess : Appearance.colors.colError
                        caption: I18n.t("info.connectionCaption")
                        icon: "hub"
                    }
                    StatusCard {
                        label: I18n.t("info.version")
                        value: "v" + backend.appVersion
                        valueColor: Appearance.colors.colPrimary
                        caption: "Qt 6 · QML · Material 3"
                        icon: "dns"
                    }
                    StatusCard {
                        label: I18n.t("info.lastAction")
                        value: backend.lastUpdate.length > 0 ? backend.lastUpdate : "--"
                        caption: backend.statusMessage.length > 0
                            ? I18n.t(backend.statusMessage)
                            : ""
                        icon: "lan"
                    }
                    StatusCard {
                        label: I18n.t("info.os")
                        value: backend.osInfo
                        valueColor: Appearance.colors.colTertiary
                        caption: backend.osVersion
                        icon: "computer"
                    }
                }

                Card {
                    Layout.fillWidth: true
                    title: I18n.t("about.title")
                    subtitle: I18n.t("about.subtitle")
                    leadingIcon: "info"

                    SettingsRow {
                        icon: "apps"
                        title: I18n.t("about.appName")
                        subtitle: I18n.t("about.appCopyright")
                        StyledText {
                            text: "v" + backend.appVersion
                            color: Appearance.colors.colPrimary
                            font.pixelSize: 13
                            font.family: Appearance.font.family.numbers
                        }
                    }

                    SettingsRow {
                        icon: "code"
                        title: I18n.t("about.sourceTitle")
                        subtitle: I18n.t("about.sourceSubtitle")
                        MaterialButton {
                            variant: MaterialButton.Variant.Tonal
                            buttonText: I18n.t("about.viewSource")
                            buttonIcon: "open_in_new"
                            onClicked: Qt.openUrlExternally("https://github.com/Yorukazeh/Lecoo-Control-Center-GUI")
                        }
                    }

                    Divider {}

                    SettingsRow {
                        icon: "terminal"
                        title: I18n.t("about.cliTitle")
                        subtitle: backend.cliPath.length > 0 ? backend.cliPath : I18n.t("about.cliMissing")
                        StyledText {
                            text: backend.cliVersion.length > 0 ? "v" + backend.cliVersion : "--"
                            color: backend.cliVersion.length > 0 ? Appearance.colors.colSuccess : Appearance.colors.colError
                            font.pixelSize: 13
                            font.family: Appearance.font.family.numbers
                        }
                    }

                    SettingsRow {
                        icon: "code"
                        title: I18n.t("about.cliSourceTitle")
                        subtitle: I18n.t("about.cliSourceSubtitle")
                        MaterialButton {
                            variant: MaterialButton.Variant.Tonal
                            buttonText: I18n.t("about.viewSource")
                            buttonIcon: "open_in_new"
                            onClicked: Qt.openUrlExternally("https://github.com/LaVashikk/Lecoo-Control-Center")
                        }
                    }

                    StyledText {
                        Layout.fillWidth: true
                        text: I18n.t("about.cliNote")
                        color: Appearance.colors.colOnSurfaceVariant
                        font.pixelSize: 11
                        wrapMode: Text.WordWrap
                    }
                }

            }

            PageScroll {
                id: palettePage
                active: StackLayout.isCurrentItem

                readonly property color onSeed: ColorUtils.contrastingText(Appearance.customLivePrimaryColor)

                component ValueBadge: Rectangle {
                    id: badge
                    property alias text: badgeText.text
                    implicitWidth: badgeText.implicitWidth + 26
                    implicitHeight: 36
                    radius: Appearance.rounding.unsharpenmore
                    color: Appearance.colors.colSurfaceContainerHighest
                    StyledText {
                        id: badgeText
                        anchors.centerIn: parent
                        color: Appearance.colors.colOnSurfaceVariant
                        font.pixelSize: 15
                        font.family: Appearance.font.family.numbers
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    StyledText {
                        text: I18n.t("palette.title")
                        color: Appearance.colors.colOnSurface
                        font.pixelSize: 28
                        font.weight: Font.Medium
                    }
                    StyledText {
                        text: I18n.t("palette.subtitle")
                        color: Appearance.colors.colOnSurfaceVariant
                        font.pixelSize: 13
                    }
                }

                Card {
                    Layout.fillWidth: true
                    title: I18n.t("palette.appearanceTitle")
                    leadingIcon: "palette"
                    subtitle: I18n.t("palette.appearanceSubtitle")

                    SettingsRow {
                        icon: "dark_mode"
                        title: I18n.t("palette.darkMode")
                        subtitle: I18n.t("palette.darkModeSubtitle")
                        StyledSwitch {
                            id: darkModeSwitch
                            checked: Appearance.darkMode
                            onToggled: appWindow.setDarkMode(darkModeSwitch, checked)
                        }
                    }

                    SettingsRow {
                        icon: "brightness_auto"
                        title: I18n.t("palette.followSystem")
                        subtitle: I18n.t("palette.followSystemSubtitle")
                        StyledSwitch {
                            id: followSystemSwitch
                            checked: appWindow.followSystemTheme
                            onToggled: appWindow.setFollowSystemTheme(followSystemSwitch, checked)
                        }
                    }

                    Divider {
                        Layout.topMargin: 4
                        Layout.bottomMargin: 4
                    }

                    StyledText {
                        text: I18n.t("palette.presetAccents")
                        color: Appearance.colors.colOnSurface
                        font.pixelSize: 14
                        font.weight: Font.Medium
                    }

                    Flow {
                        Layout.fillWidth: true
                        spacing: 8

                        Repeater {
                            model: Appearance.themes
                            delegate: Chip {
                                required property var modelData
                                required property int index
                                buttonText: I18n.themeName(modelData.name)
                                leadingIcon: modelData.icon
                                toggled: !Appearance.customTheme && Appearance.themeIndex === index
                                onClicked: {
                                    Appearance.customTheme = false
                                    Appearance.themeIndex = index
                                }
                            }
                        }
                    }

                    StyledText {
                        text: I18n.t("palette.language")
                        color: Appearance.colors.colOnSurface
                        font.pixelSize: 14
                        font.weight: Font.Medium
                    }

                    Flow {
                        Layout.fillWidth: true
                        spacing: 8

                        Repeater {
                            model: [{ code: "", label: I18n.t("palette.languageAuto") }].concat(I18n.availableLanguages)
                            delegate: Chip {
                                required property var modelData
                                buttonText: modelData.label
                                leadingIcon: "translate"
                                toggled: appWindow.languageSetting === modelData.code
                                onClicked: appWindow.languageSetting = modelData.code
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 84
                    radius: Appearance.rounding.full
                    // Keep the color preview synchronized with the selected hue.
                    color: Appearance.customLivePrimaryColor

                    StyledText {
                        anchors.centerIn: parent
                        text: Appearance.customLivePrimaryHex.toUpperCase()
                        color: palettePage.onSeed
                        font.pixelSize: 26
                        font.weight: Font.Medium
                        font.family: Appearance.font.family.numbers
                    }
                }

                Flow {
                    Layout.fillWidth: true
                    spacing: 12

                    MaterialButton {
                        buttonText: Appearance.customTheme ? I18n.t("palette.usingCustom") : I18n.t("palette.useCustom")
                        buttonIcon: Appearance.customTheme ? "check" : "palette"
                        variant: Appearance.customTheme ? MaterialButton.Variant.Filled : MaterialButton.Variant.Tonal
                        onClicked: Appearance.customTheme = true
                    }

                    MaterialButton {
                        buttonText: I18n.t("palette.random")
                        buttonIcon: "casino"
                        variant: MaterialButton.Variant.Tonal
                        onClicked: {
                            Appearance.customTheme = true
                            Appearance.customHue = Math.random() * 360
                            Appearance.customChroma = 20 + Math.random() * 60
                        }
                    }

                    MaterialButton {
                        buttonText: I18n.t("palette.reset")
                        buttonIcon: "restart_alt"
                        variant: MaterialButton.Variant.Outlined
                        onClicked: Appearance.customTheme = false
                    }
                }

                Card {
                    Layout.fillWidth: true
                    title: I18n.t("palette.seedTitle")
                    leadingIcon: "colorize"
                    subtitle: I18n.t("palette.seedSubtitle")

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 26

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            RowLayout {
                                Layout.fillWidth: true
                                StyledText {
                                    text: I18n.t("palette.hue")
                                    color: Appearance.colors.colOnSurface
                                    font.pixelSize: 16
                                }
                                Item { Layout.fillWidth: true }
                                ValueBadge {
                                    text: Math.round(Appearance.customHue) + "°"
                                }
                            }

                            StyledSlider {
                                id: hueSlider
                                Layout.fillWidth: true
                                from: 0
                                to: 360
                                usePercentTooltip: false
                                // Update the palette on every hue value change.
                                onPressedChanged: {
                                    Appearance.instantColors = pressed
                                    if (pressed)
                                        Appearance.beginChipDrag()
                                    else
                                        Appearance.endChipDrag()
                                }
                                onValueChanged: {
                                    if (pressed) {
                                        Appearance.customTheme = true
                                        Appearance.customHue = value
                                    }
                                }
                                // Sync the slider when changes come from elsewhere.
                                Connections {
                                    target: Appearance
                                    function onCustomHueChanged() {
                                        if (!hueSlider.pressed
                                                && Math.abs(hueSlider.value - Appearance.customHue) > 0.01)
                                            hueSlider.value = Appearance.customHue
                                    }
                                }
                            }
                        }
                    }
                }

                Card {
                    Layout.fillWidth: true
                    title: I18n.t("palette.schemeTitle")
                    leadingIcon: "format_paint"
                    subtitle: I18n.t("palette.schemeSubtitle")

                    GridLayout {
                        Layout.fillWidth: true
                        columns: appWindow.pageAvailableWidth < 380 ? 2 : (appWindow.pageAvailableWidth < 520 ? 3 : 4)
                        columnSpacing: 12
                        rowSpacing: 12

                        Repeater {
                            model: Appearance.variantList()
                            delegate: SchemeCard {}
                        }
                    }
                }
            }
        }
    }

    // Keep the old theme visible beneath the reveal.
    Item {
        id: themeOldFrame
        anchors.fill: parent
        visible: false

        Rectangle {
            anchors.fill: parent
            color: appWindow.frozenBackdrop
        }

        Image {
            id: themeSnapshot
            // Paint the captured content at its original size and position.
            x: appContent.x
            y: appContent.y
            width: appContent.width
            height: appContent.height
            fillMode: Image.Stretch
            cache: false
            onStatusChanged: {
                if (status === Image.Ready)
                    appWindow.startThemeRipple()
            }
        }
    }

    // Reveal the new theme through a growing circular mask.
    MultiEffect {
        id: themeRippleLayer
        anchors.fill: parent
        z: 20
        visible: appWindow.themeRippleActive
        source: themeOldFrame
        maskEnabled: true
        maskSource: rippleMask
        maskInverted: true
        autoPaddingEnabled: false
    }

    // Provide the hidden circular mask for the reveal.
    Item {
        id: rippleMask
        anchors.fill: parent
        visible: false
        layer.enabled: true

        Rectangle {
            x: appWindow.rippleX - appWindow.rippleRadius
            y: appWindow.rippleY - appWindow.rippleRadius
            width: Math.max(0, appWindow.rippleRadius * 2)
            height: width
            radius: width / 2
            color: "white"
            antialiasing: true
        }
    }

    SequentialAnimation {
        id: rippleAnimation
        NumberAnimation {
            target: appWindow
            property: "rippleProgress"
            from: 0
            to: 1
            duration: 750
            // Fast off the mark, then slowing down as it settles into the final radius.
            easing.type: Easing.OutCubic
        }
        ScriptAction {
            script: appWindow.finishThemeRipple()
        }
    }

    LicenseDialog {
        id: legalDialog
    }

    Popup {
        id: errorPopup
        x: Math.max(20, appWindow.width - width - 28)
        y: Math.max(20, appWindow.height - height - 28)
        width: Math.min(520, appWindow.width - 56)
        padding: 18
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            radius: Appearance.rounding.large
            color: Appearance.colors.colErrorContainer
            border.width: 1
            border.color: Appearance.colors.colError
        }

        contentItem: RowLayout {
            spacing: 12
            MaterialSymbol {
                Layout.alignment: Qt.AlignTop
                text: "error"
                iconSize: 22
                color: Appearance.colors.colError
            }
            StyledText {
                Layout.fillWidth: true
                text: I18n.t(backend.errorMessage)
                color: Appearance.colors.colOnErrorContainer
                font.pixelSize: 13
                wrapMode: Text.WordWrap
            }
        }
    }
}
