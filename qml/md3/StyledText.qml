import QtQuick
import io.lecooctrl.gui

// Themed text element using application fonts and colors.
Text {
    id: root
    property bool animateChange: false
    property real animationDistanceX: 0
    property real animationDistanceY: 6

    renderType: Text.NativeRendering
    verticalAlignment: Text.AlignVCenter

    /** Apply an optional Material 3 type-scale token to the text. */
    property string typeScale: ""
    readonly property var typeToken: typeScale !== "" && Appearance.font.scale[typeScale]
                                     ? Appearance.font.scale[typeScale] : null

    property bool shouldUseNumberFont: /^\d+$/.test(root.text)
    property var defaultFont: shouldUseNumberFont ? Appearance.font.family.numbers : Appearance.font.family.main

    /** Resolve the variable-font weight without creating a font binding loop. */
    readonly property int variableWeight: root.typeToken ? root.typeToken.weight : Font.Normal

    font {
        hintingPreference: Font.PreferDefaultHinting
        family: defaultFont
        pixelSize: Appearance?.font.pixelSize.small ?? 15
        weight: root.variableWeight
        letterSpacing: root.typeToken ? root.typeToken.spacing : 0
        // Pass the resolved weight to the variable font axis.
        variableAxes: ({ "wght": root.variableWeight })
    }
    color: Appearance?.colors.colOnLayer0 ?? "white"
    linkColor: Appearance?.m3colors.m3primary
}
