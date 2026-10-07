import QtQuick
import QtQuick.Layouts
import io.lecooctrl.gui

/** Preview and select a Material color-scheme variant. */
Rectangle {
    id: card

    required property var modelData

    readonly property bool selected: Appearance.customTheme && Appearance.schemeVariant === card.modelData.id

    Layout.fillWidth: true
    Layout.minimumWidth: 120
    implicitHeight: 104
    // Round selected cards more strongly.
    radius: card.selected ? Appearance.rounding.verylarge : Appearance.rounding.normal
    color: card.selected ? Appearance.colors.colSecondaryContainer : Appearance.colors.colSurfaceContainerLow
    border.width: card.selected ? 2 : 1
    border.color: card.selected ? Appearance.colors.colPrimary : Appearance.colors.colOutlineVariant

    Behavior on radius {
        animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
    }
    Behavior on color {
        animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
    }
    Behavior on border.width {
        animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 12

        Row {
            Layout.alignment: Qt.AlignHCenter
            spacing: 7

            Repeater {
                model: Appearance.variantDots(card.modelData.id)
                delegate: Rectangle {
                    required property var modelData
                    width: 26
                    height: 26
                    radius: 13
                    color: modelData
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 6

            MaterialSymbol {
                visible: card.selected
                text: "check_circle"
                iconSize: 18
                color: Appearance.colors.colPrimary
            }

            StyledText {
                text: card.modelData.name
                color: card.selected ? Appearance.colors.colOnSecondaryContainer : Appearance.colors.colOnSurface
                font.pixelSize: 15
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            Appearance.customTheme = true
            Appearance.schemeVariant = card.modelData.id
        }
    }
}
