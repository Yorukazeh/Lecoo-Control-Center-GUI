import QtQuick
import QtQuick.Controls
import io.lecooctrl.gui

/** Small Material 3 tooltip shown while the parent control is hovered. */
ToolTip {
    id: root
    padding: 8
    delay: 450
    background: Rectangle {
        radius: Appearance.rounding.unsharpen + 2
        color: Appearance.colors.colTooltip
    }
    contentItem: StyledText {
        text: root.text
        color: Appearance.colors.colOnTooltip
        font.pixelSize: Appearance.font.pixelSize.smaller
    }
    visible: parent ? (parent.hovered === undefined ? false : parent.hovered) : false
}
