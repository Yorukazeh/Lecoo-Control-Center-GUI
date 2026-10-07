import QtQuick
import io.lecooctrl.gui

/** Render a Material Icons Round ligature as centered text. */
StyledText {
    id: root

    property real iconSize: Appearance?.font.pixelSize.small ?? 16

    renderType: Text.NativeRendering
    shouldUseNumberFont: false

    font {
        hintingPreference: Font.PreferNoHinting
        family: Appearance.font.family.iconMaterial
        pixelSize: iconSize
    }
}
