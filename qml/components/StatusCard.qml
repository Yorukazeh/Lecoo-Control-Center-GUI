import QtQuick
import QtQuick.Layouts
import io.lecooctrl.gui

/** Show a label, value, and optional caption in an information card. */
Card {
    id: card

    property string label: I18n.t("info.connection")
    property string value: "--"
    property string caption: ""
    property color valueColor: Appearance.colors.colOnSurface
    property string icon: ""

    Layout.fillWidth: true
    Layout.minimumWidth: 175
    implicitHeight: 138
    title: card.label
    leadingIcon: card.icon
    colBackground: Appearance.colors.colSurfaceContainerLow

    StyledText {
        Layout.fillWidth: true
        text: card.value
        color: card.valueColor
        font.pixelSize: 22
        font.weight: Font.Medium
        elide: Text.ElideRight
    }

    StyledText {
        Layout.fillWidth: true
        visible: card.caption.length > 0
        text: card.caption
        color: Appearance.colors.colOnSurfaceVariant
        font.pixelSize: 12
        elide: Text.ElideRight
    }
}
