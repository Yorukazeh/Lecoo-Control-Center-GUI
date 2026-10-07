import QtQuick
import QtQuick.Layouts
import io.lecooctrl.gui

/** Show a metric value with an optional icon and progress bar. */
Card {
    id: card

    property string label: ""
    property var value: "--"
    property string unit: ""
    property real progress: 0
    property color accent: Appearance.colors.colPrimary
    property string icon: "sensors"

    Layout.fillWidth: true
    Layout.minimumWidth: 170
    implicitHeight: 152
    title: card.label
    leadingIcon: card.icon
    colBackground: Appearance.colors.colSurfaceContainerLow

    RowLayout {
        Layout.fillWidth: true
        spacing: 6

        StyledText {
            Layout.alignment: Qt.AlignBottom
            text: card.value
            color: Appearance.colors.colOnSurface
            font.pixelSize: 34
            font.weight: Font.Medium
        }

        StyledText {
            Layout.alignment: Qt.AlignBottom
            Layout.bottomMargin: 7
            text: card.unit
            color: Appearance.colors.colOnSurfaceVariant
            font.pixelSize: 13
        }

        Item { Layout.fillWidth: true }
    }

    StyledProgressBar {
        Layout.fillWidth: true
        Layout.topMargin: 2
        value: Math.max(0, Math.min(1, card.progress))
        highlightColor: card.accent
        trackColor: Appearance.colors.colSurfaceContainerHighest
        valueBarHeight: 6
    }
}
