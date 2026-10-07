import QtQuick
import QtQuick.Layouts
import io.lecooctrl.gui

// Material 3 filled card with optional header and actions.
Rectangle {
    id: root
    property string title: ""
    property string subtitle: ""
    property string leadingIcon: ""
    property bool interactive: false
    property bool elevated: false
    property color colBackground: Appearance.colors.colSurfaceContainerLow
    property color colContent: Appearance.colors.colOnSurface
    default property alias contentData: contentColumn.data

    radius: Appearance.rounding.normal
    color: root.interactive && hoverHandler.hovered ? Appearance.colors.colSurfaceContainerHigh : root.colBackground
    implicitWidth: 240
    implicitHeight: contentColumn.implicitHeight + 32
    border.width: 0

    HoverHandler {
        id: hoverHandler
        enabled: root.interactive
    }

    Behavior on color {
        animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
    }

    Loader {
        z: -1
        active: root.elevated
        anchors.fill: parent
        sourceComponent: StyledRectangularShadow {
            target: root
        }
    }

    ColumnLayout {
        id: contentColumn
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: 16
        }
        spacing: 8

        RowLayout {
            visible: root.title.length > 0 || root.leadingIcon.length > 0
            Layout.fillWidth: true
            spacing: 12

            MaterialSymbol {
                visible: root.leadingIcon.length > 0
                text: root.leadingIcon
                iconSize: 24
                color: Appearance.colors.colPrimary
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0
                StyledText {
                    visible: root.title.length > 0
                    Layout.fillWidth: true
                    text: root.title
                    color: root.colContent
                    font.pixelSize: Appearance.font.pixelSize.large
                    font.weight: Font.Medium
                }
                StyledText {
                    visible: root.subtitle.length > 0
                    Layout.fillWidth: true
                    text: root.subtitle
                    color: Appearance.colors.colOnSurfaceVariant
                    font.pixelSize: Appearance.font.pixelSize.smaller
                }
            }
        }
    }
}
