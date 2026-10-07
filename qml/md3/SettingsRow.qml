import QtQuick
import QtQuick.Layouts
import io.lecooctrl.gui

/** A label + control row, mimicking Material 3's settings rows. */
RowLayout {
    id: root
    property string title: "Setting"
    property string subtitle: ""
    property string icon: ""
    property bool descriptionOnTop: false
    default property alias control: controlSlot.data

    Layout.fillWidth: true
    spacing: 12
    implicitHeight: 48

    MaterialSymbol {
        visible: root.icon.length > 0
        Layout.alignment: Qt.AlignVCenter
        text: root.icon
        iconSize: 22
        color: Appearance.colors.colOnSurfaceVariant
    }

    ColumnLayout {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignVCenter
        spacing: 0
        StyledText {
            Layout.fillWidth: true
            text: root.title
            color: Appearance.colors.colOnSurface
            font.pixelSize: 15
            elide: Text.ElideRight
        }
        StyledText {
            Layout.fillWidth: true
            visible: root.subtitle.length > 0
            text: root.subtitle
            color: Appearance.colors.colOnSurfaceVariant
            font.pixelSize: 12
            elide: Text.ElideRight
        }
    }

    RowLayout {
        id: controlSlot
        Layout.alignment: Qt.AlignVCenter
        spacing: 8
    }
}
