pragma Singleton
import QtQuick
import io.lecooctrl.gui
import "PaletteGen.js" as PaletteGen

// Application design tokens and writable theme settings.
QtObject {
    id: root

    // Store appearance mode and preset theme.
    property bool darkMode: true
    property int themeIndex: 1

    // Store the custom palette seed.
    property bool customTheme: false
    property real customHue: 285
    property real customChroma: 26
    property string schemeVariant: "tonalSpot"

    // Generate the built-in themes.
    readonly property var themes: [
        { "name": "Mauve",  "icon": "blur_on",               "hue": 305.5, "chroma": 5.4,  "variant": "neutral" },
        { "name": "Purple", "icon": "palette",               "hue": 299.0, "chroma": 47.9, "variant": "expressive" },
        { "name": "Blue",   "icon": "water_drop",            "hue": 264.3, "chroma": 38.6, "variant": "tonalSpot" },
        { "name": "Green",  "icon": "eco",                   "hue": 145.4, "chroma": 35.6, "variant": "tonalSpot" },
        { "name": "Peach",  "icon": "local_fire_department", "hue": 29.7,  "chroma": 40.5, "variant": "expressive" },
        { "name": "Gold",   "icon": "star",                  "hue": 89.7,  "chroma": 38.4, "variant": "tonalSpot" }
    ]

    readonly property var theme: themes[Math.max(0, Math.min(themes.length - 1, themeIndex))]

    // Generate the active palette.
    readonly property var customPalette: PaletteGen.generate(customHue, customChroma, darkMode, schemeVariant)
    // Expose the generated primary role.
    readonly property string customPrimaryHex: customPalette.primary
    readonly property color customPrimaryColor: customPrimaryHex

    // Keep the seed preview bound to the active palette.
    readonly property string customLivePrimaryHex: customPalette.primary
    readonly property color customLivePrimaryColor: customLivePrimaryHex

    readonly property var presetPalette: PaletteGen.generate(theme.hue, theme.chroma, darkMode, theme.variant)
    // Generate the success palette.
    readonly property var successPalette: PaletteGen.generate(145, 48, darkMode, "tonalSpot")
    readonly property var pal: customTheme ? customPalette : presetPalette
    readonly property string activeThemeName: customTheme ? "Custom" : theme.name

    // Expose palette-page helpers.
    function variantList() {
        return PaletteGen.variantList();
    }
    // Hold the chip preview hue during dragging.
    property real chipHue: 0
    property bool chipDragging: false

    readonly property Timer chipTimer: Timer {
        interval: 200
        repeat: true
        running: false
        onTriggered: Appearance.chipHue = Appearance.customHue
    }

    // Sync chip previews after external hue changes.
    readonly property Connections chipHueSync: Connections {
        target: Appearance
        function onCustomHueChanged() {
            if (!Appearance.chipDragging)
                Appearance.chipHue = Appearance.customHue
        }
    }

    function beginChipDrag() {
        chipDragging = true
        chipHue = customHue
        chipTimer.start()
    }

    function endChipDrag() {
        chipDragging = false
        chipTimer.stop()
        chipHue = customHue
    }

    function variantDots(variantId) {
        return PaletteGen.variantDots(chipHue, customChroma, darkMode, variantId);
    }

    // Choose the outer background tone.
    readonly property real backgroundTone: darkMode ? 5 : 98.5

    function backgroundAt(tone) {
        return customTheme
            ? PaletteGen.neutralTone(customHue, customChroma, darkMode, schemeVariant, tone)
            : PaletteGen.neutralTone(theme.hue, theme.chroma, darkMode, theme.variant, tone);
    }

    // Disable color transitions during hue dragging.
    property bool instantColors: false

    // Expose generated Material 3 roles.
    readonly property QtObject m3colors: QtObject {
        // Primary roles.
        readonly property color m3primary: root.pal.primary
        readonly property color m3onPrimary: root.pal.onPrimary
        readonly property color m3primaryContainer: root.pal.primaryContainer
        readonly property color m3onPrimaryContainer: root.pal.onPrimaryContainer
        readonly property color m3inversePrimary: root.pal.inversePrimary
        readonly property color m3primaryFixed: root.pal.primaryFixed
        readonly property color m3primaryFixedDim: root.pal.primaryFixedDim
        readonly property color m3onPrimaryFixed: root.pal.onPrimaryFixed
        readonly property color m3onPrimaryFixedVariant: root.pal.onPrimaryFixedVariant

        // Secondary roles.
        readonly property color m3secondary: root.pal.secondary
        readonly property color m3onSecondary: root.pal.onSecondary
        readonly property color m3secondaryContainer: root.pal.secondaryContainer
        readonly property color m3onSecondaryContainer: root.pal.onSecondaryContainer
        readonly property color m3secondaryFixed: root.pal.secondaryFixed
        readonly property color m3secondaryFixedDim: root.pal.secondaryFixedDim
        readonly property color m3onSecondaryFixed: root.pal.onSecondaryFixed
        readonly property color m3onSecondaryFixedVariant: root.pal.onSecondaryFixedVariant

        // Tertiary roles.
        readonly property color m3tertiary: root.pal.tertiary
        readonly property color m3onTertiary: root.pal.onTertiary
        readonly property color m3tertiaryContainer: root.pal.tertiaryContainer
        readonly property color m3onTertiaryContainer: root.pal.onTertiaryContainer
        readonly property color m3tertiaryFixed: root.pal.tertiaryFixed
        readonly property color m3tertiaryFixedDim: root.pal.tertiaryFixedDim
        readonly property color m3onTertiaryFixed: root.pal.onTertiaryFixed
        readonly property color m3onTertiaryFixedVariant: root.pal.onTertiaryFixedVariant

        // Error roles.
        readonly property color m3error: root.pal.error
        readonly property color m3onError: root.pal.onError
        readonly property color m3errorContainer: root.pal.errorContainer
        readonly property color m3onErrorContainer: root.pal.onErrorContainer

        // Success roles
        readonly property color m3success: root.successPalette.primary
        readonly property color m3onSuccess: root.successPalette.onPrimary
        readonly property color m3successContainer: root.successPalette.primaryContainer
        readonly property color m3onSuccessContainer: root.successPalette.onPrimaryContainer

        // Surface roles.
        readonly property color m3background: root.pal.background
        readonly property color m3onBackground: root.pal.onBackground
        readonly property color m3surface: root.pal.surface
        readonly property color m3onSurface: root.pal.onSurface
        readonly property color m3surfaceDim: root.pal.surfaceDim
        readonly property color m3surfaceBright: root.pal.surfaceBright
        readonly property color m3surfaceContainerLowest: root.pal.surfaceContainerLowest
        readonly property color m3surfaceContainerLow: root.pal.surfaceContainerLow
        readonly property color m3surfaceContainer: root.pal.surfaceContainer
        readonly property color m3surfaceContainerHigh: root.pal.surfaceContainerHigh
        readonly property color m3surfaceContainerHighest: root.pal.surfaceContainerHighest
        readonly property color m3surfaceVariant: root.pal.surfaceVariant
        readonly property color m3onSurfaceVariant: root.pal.onSurfaceVariant
        readonly property color m3inverseSurface: root.pal.inverseSurface
        readonly property color m3inverseOnSurface: root.pal.inverseOnSurface
        readonly property color m3outline: root.pal.outline
        readonly property color m3outlineVariant: root.pal.outlineVariant
        readonly property color m3surfaceTint: root.pal.surfaceTint
        readonly property color m3shadow: root.pal.shadow
        readonly property color m3scrim: root.pal.scrim

        // Application layer role.
        readonly property color m3trackContainer: root.pal.trackContainer
    }

    readonly property QtObject colors: QtObject {
        // Use the configured neutral tone for the outer background.
        readonly property color colLayer0: root.backgroundTone < 0
            ? (root.darkMode ? root.m3colors.m3background : root.pal.surfaceContainerLowest)
            : root.backgroundAt(root.backgroundTone)
        readonly property color colOnLayer0: root.m3colors.m3onBackground
        readonly property color colLayer0Border: ColorUtils.mix(root.m3colors.m3outlineVariant, colLayer0, 0.4)

        // Navigation and secondary surfaces.
        readonly property color colLayer1: root.darkMode
            ? root.backgroundAt(9)
            : root.m3colors.m3surfaceContainerLow
        readonly property color colOnLayer1: root.m3colors.m3onSurfaceVariant
        readonly property color colOnLayer1Inactive: ColorUtils.mix(colOnLayer1, colLayer1, 0.45)
        readonly property color colLayer1Hover: ColorUtils.mix(colLayer1, colOnLayer1, 0.92)
        readonly property color colLayer1Active: ColorUtils.mix(colLayer1, colOnLayer1, 0.85)

        // Cards and fields.
        readonly property color colLayer2Base: root.darkMode
            ? root.backgroundAt(13)
            : root.m3colors.m3surfaceContainer
        readonly property color colLayer2: colLayer2Base
        readonly property color colOnLayer2: root.m3colors.m3onSurface
        readonly property color colLayer2Hover: ColorUtils.mix(colLayer2, colOnLayer2, 0.92)
        readonly property color colLayer2Active: ColorUtils.mix(colLayer2, colOnLayer2, 0.85)

        // Popups and elevated containers.
        readonly property color colLayer3Base: root.darkMode
            ? root.backgroundAt(15)
            : root.m3colors.m3surfaceContainerHigh
        readonly property color colLayer3: colLayer3Base
        readonly property color colOnLayer3: root.m3colors.m3onSurface
        readonly property color colLayer3Hover: ColorUtils.mix(colLayer3, colOnLayer3, 0.92)
        readonly property color colLayer3Active: ColorUtils.mix(colLayer3, colOnLayer3, 0.85)

        readonly property color colLayer4Base: root.darkMode
            ? root.backgroundAt(19)
            : root.m3colors.m3surfaceContainerHighest
        readonly property color colLayer4: colLayer4Base
        readonly property color colOnLayer4: root.m3colors.m3onSurface
        readonly property color colLayer4Hover: ColorUtils.mix(colLayer4, colOnLayer4, 0.92)
        readonly property color colLayer4Active: ColorUtils.mix(colLayer4, colOnLayer4, 0.85)

        // Primary roles.
        readonly property color colPrimary: root.m3colors.m3primary
        readonly property color colOnPrimary: root.m3colors.m3onPrimary
        readonly property color colPrimaryHover: ColorUtils.mix(root.m3colors.m3primary, colOnPrimary, 0.92)
        readonly property color colPrimaryActive: ColorUtils.mix(root.m3colors.m3primary, colOnPrimary, 0.85)
        readonly property color colPrimaryContainer: root.m3colors.m3primaryContainer
        readonly property color colOnPrimaryContainer: root.m3colors.m3onPrimaryContainer
        readonly property color colPrimaryContainerHover: ColorUtils.mix(colPrimaryContainer, colOnPrimaryContainer, 0.92)
        readonly property color colPrimaryContainerActive: ColorUtils.mix(colPrimaryContainer, colOnPrimaryContainer, 0.85)

        // Secondary roles.
        readonly property color colSecondary: root.m3colors.m3secondary
        readonly property color colOnSecondary: root.m3colors.m3onSecondary
        readonly property color colSecondaryHover: ColorUtils.mix(root.m3colors.m3secondary, colOnSecondary, 0.92)
        readonly property color colSecondaryActive: ColorUtils.mix(root.m3colors.m3secondary, colOnSecondary, 0.85)
        readonly property color colSecondaryContainer: root.m3colors.m3secondaryContainer
        readonly property color colOnSecondaryContainer: root.m3colors.m3onSecondaryContainer
        readonly property color colSecondaryContainerHover: ColorUtils.mix(colSecondaryContainer, colOnSecondaryContainer, 0.92)
        readonly property color colSecondaryContainerActive: ColorUtils.mix(colSecondaryContainer, colOnSecondaryContainer, 0.85)
        readonly property color colTrackContainer: root.m3colors.m3trackContainer

        // Tertiary roles.
        readonly property color colTertiary: root.m3colors.m3tertiary
        readonly property color colOnTertiary: root.m3colors.m3onTertiary
        readonly property color colTertiaryContainer: root.m3colors.m3tertiaryContainer
        readonly property color colOnTertiaryContainer: root.m3colors.m3onTertiaryContainer
        readonly property color colTertiaryContainerHover: ColorUtils.mix(colTertiaryContainer, colOnTertiaryContainer, 0.92)
        readonly property color colTertiaryContainerActive: ColorUtils.mix(colTertiaryContainer, colOnTertiaryContainer, 0.85)

        // Error and success roles
        readonly property color colError: root.m3colors.m3error
        readonly property color colOnError: root.m3colors.m3onError
        readonly property color colErrorContainer: root.m3colors.m3errorContainer
        readonly property color colOnErrorContainer: root.m3colors.m3onErrorContainer
        readonly property color colErrorHover: ColorUtils.mix(colError, colOnError, 0.92)
        readonly property color colSuccess: root.m3colors.m3success
        readonly property color colOnSuccess: root.m3colors.m3onSuccess
        readonly property color colSuccessContainer: root.m3colors.m3successContainer
        readonly property color colOnSuccessContainer: root.m3colors.m3onSuccessContainer

        // Surface aliases
        readonly property color colSurfaceContainerLowest: root.darkMode
            ? root.backgroundAt(7)
            : root.m3colors.m3surfaceContainerLowest
        readonly property color colSurfaceContainerLow: root.darkMode
            ? root.backgroundAt(9)
            : root.m3colors.m3surfaceContainerLow
        readonly property color colSurfaceContainer: root.darkMode
            ? root.backgroundAt(13)
            : root.m3colors.m3surfaceContainer
        readonly property color colSurfaceContainerHigh: root.darkMode
            ? root.backgroundAt(15)
            : root.m3colors.m3surfaceContainerHigh
        readonly property color colSurfaceContainerHighest: root.darkMode
            ? root.backgroundAt(19)
            : root.m3colors.m3surfaceContainerHighest
        readonly property color colSurfaceVariant: root.m3colors.m3surfaceVariant
        readonly property color colOnSurface: root.m3colors.m3onSurface
        readonly property color colOnSurfaceVariant: root.m3colors.m3onSurfaceVariant
        readonly property color colInverseSurface: root.m3colors.m3inverseSurface
        readonly property color colInverseOnSurface: root.m3colors.m3inverseOnSurface

        // Miscellaneous roles
        readonly property color colOutline: root.m3colors.m3outline
        readonly property color colOutlineVariant: root.m3colors.m3outlineVariant
        readonly property color colSubtext: root.m3colors.m3outline
        readonly property color colShadow: ColorUtils.transparentize(root.m3colors.m3shadow, 0.5)
        readonly property color colScrim: ColorUtils.transparentize(root.m3colors.m3scrim, 0.5)
        readonly property color colTooltip: root.m3colors.m3inverseSurface
        readonly property color colOnTooltip: root.m3colors.m3inverseOnSurface
    }

    readonly property QtObject rounding: QtObject {
        readonly property int unsharpen: 4
        readonly property int unsharpenmore: 8
        readonly property int verysmall: 8
        readonly property int small: 12
        readonly property int normal: 16
        readonly property int large: 24
        readonly property int verylarge: 28
        readonly property int full: 9999
        readonly property int screenRounding: large
        readonly property int windowRounding: 18
    }

    readonly property QtObject sizes: QtObject {
        readonly property real elevationMargin: 10
        readonly property real fabShadowRadius: 5
        readonly property real barHeight: 44
        readonly property real navRailWidth: 96
        readonly property real navRailExpandedWidth: 210
        readonly property real sidebarWidth: 400
        readonly property real contentMaxWidth: 900
    }

    // Store platform font families.
    property string systemFontFamily: ""
    property string systemFixedFontFamily: ""

    // Load the application text font.
    property FontLoader textFont: FontLoader {
        source: "qrc:/assets/fonts/NotoSansSC-VF.ttf"
    }
    readonly property string textFamily: root.textFont.name || root.systemFontFamily

    // Load the shared icon font.
    property FontLoader iconFont: FontLoader {
        source: "qrc:/assets/fonts/MaterialIconsRound-Regular.otf"
    }

    readonly property QtObject font: QtObject {
        readonly property QtObject family: QtObject {
            readonly property string main: root.textFamily
            readonly property string numbers: root.textFamily
            readonly property string title: root.textFamily
            // Use the loaded icon family or its fallback.
            readonly property string iconMaterial: root.iconFont.name || "Material Icons Round"
            readonly property string monospace: root.systemFixedFontFamily
            readonly property string iconNerd: root.systemFixedFontFamily
        }
        readonly property QtObject pixelSize: QtObject {
            readonly property int smallest: 10
            readonly property int smaller: 12
            readonly property int smallie: 13
            readonly property int small: 15
            readonly property int normal: 16
            readonly property int large: 17
            readonly property int larger: 19
            readonly property int huge: 22
            readonly property int hugeass: 23
            readonly property int title: huge
        }
        // Define the type scale.
        readonly property var scale: ({
            "displayLarge": { "size": 57, "weight": Font.Normal, "spacing": -0.25 },
            "displayMedium": { "size": 45, "weight": Font.Normal, "spacing": 0.0 },
            "displaySmall": { "size": 36, "weight": Font.Normal, "spacing": 0.0 },
            "headlineLarge": { "size": 32, "weight": Font.Normal, "spacing": 0.0 },
            "headlineMedium": { "size": 28, "weight": Font.Normal, "spacing": 0.0 },
            "headlineSmall": { "size": 24, "weight": Font.Normal, "spacing": 0.0 },
            "titleLarge": { "size": 22, "weight": Font.Medium, "spacing": 0.0 },
            "titleMedium": { "size": 16, "weight": Font.Medium, "spacing": 0.15 },
            "titleSmall": { "size": 14, "weight": Font.Medium, "spacing": 0.1 },
            "bodyLarge": { "size": 16, "weight": Font.Normal, "spacing": 0.5 },
            "bodyMedium": { "size": 14, "weight": Font.Normal, "spacing": 0.25 },
            "bodySmall": { "size": 12, "weight": Font.Normal, "spacing": 0.4 },
            "labelLarge": { "size": 14, "weight": Font.Medium, "spacing": 0.1 },
            "labelMedium": { "size": 12, "weight": Font.Medium, "spacing": 0.5 },
            "labelSmall": { "size": 11, "weight": Font.Medium, "spacing": 0.5 }
        })
    }

    readonly property QtObject animationCurves: QtObject {
        readonly property list<real> expressiveFastSpatial: [0.42, 1.67, 0.21, 0.90, 1, 1]
        readonly property list<real> expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1.00, 1, 1]
        readonly property list<real> expressiveSlowSpatial: [0.39, 1.29, 0.35, 0.98, 1, 1]
        readonly property list<real> expressiveEffects: [0.34, 0.80, 0.34, 1.00, 1, 1]
        readonly property list<real> emphasized: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
        readonly property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
        readonly property list<real> emphasizedAccel: [0.3, 0, 0.8, 0.15, 1, 1]
        readonly property list<real> standard: [0.2, 0, 0, 1, 1, 1]
        readonly property list<real> standardDecel: [0, 0, 0, 1, 1, 1]
        readonly property real expressiveFastSpatialDuration: 350
        readonly property real expressiveDefaultSpatialDuration: 500
        readonly property real expressiveSlowSpatialDuration: 650
        readonly property real expressiveEffectsDuration: 200
    }

    readonly property QtObject animation: QtObject {
        readonly property QtObject elementMove: QtObject {
            readonly property int duration: 500
            readonly property int type: Easing.BezierSpline
            readonly property list<real> bezierCurve: root.animationCurves.expressiveDefaultSpatial
            readonly property int velocity: 650
            readonly property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMove.duration
                    easing.type: root.animation.elementMove.type
                    easing.bezierCurve: root.animation.elementMove.bezierCurve
                }
            }
        }
        readonly property QtObject elementMoveSmall: QtObject {
            readonly property int duration: 350
            readonly property int type: Easing.BezierSpline
            readonly property list<real> bezierCurve: root.animationCurves.expressiveFastSpatial
            readonly property int velocity: 650
            readonly property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMoveSmall.duration
                    easing.type: root.animation.elementMoveSmall.type
                    easing.bezierCurve: root.animation.elementMoveSmall.bezierCurve
                }
            }
        }
        readonly property QtObject elementMoveFast: QtObject {
            readonly property int duration: 200
            readonly property int type: Easing.BezierSpline
            readonly property list<real> bezierCurve: root.animationCurves.expressiveEffects
            readonly property int velocity: 850
            readonly property Component colorAnimation: Component {
                ColorAnimation {
                    // Disable color animation during hue dragging.
                    duration: root.instantColors ? 0 : root.animation.elementMoveFast.duration
                    easing.type: root.animation.elementMoveFast.type
                    easing.bezierCurve: root.animation.elementMoveFast.bezierCurve
                }
            }
            readonly property Component numberAnimation: Component {
                NumberAnimation {
                    alwaysRunToEnd: true
                    duration: root.animation.elementMoveFast.duration
                    easing.type: root.animation.elementMoveFast.type
                    easing.bezierCurve: root.animation.elementMoveFast.bezierCurve
                }
            }
        }
        readonly property QtObject clickBounce: QtObject {
            readonly property int duration: 400
            readonly property int type: Easing.BezierSpline
            readonly property list<real> bezierCurve: root.animationCurves.emphasized
            readonly property int velocity: 850
            readonly property Component numberAnimation: Component {
                NumberAnimation {
                    alwaysRunToEnd: true
                    duration: root.animation.clickBounce.duration
                    easing.type: root.animation.clickBounce.type
                    easing.bezierCurve: root.animation.clickBounce.bezierCurve
                }
            }
        }
        readonly property QtObject scroll: QtObject {
            readonly property int duration: 200
            readonly property int type: Easing.BezierSpline
            readonly property list<real> bezierCurve: root.animationCurves.standardDecel
        }
    }

    function mix(a, b, t) {
        return ColorUtils.mix(a, b, t);
    }
    function transparentize(c, a) {
        return ColorUtils.transparentize(c, a);
    }
}
