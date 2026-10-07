import QtQuick
import QtQuick.Layouts
import io.lecooctrl.gui

/** Show a navigation-rail row with a colored status dot. */
Item {
    id: root

    property bool toggled: false
    property color dotColor: Appearance.colors.colSuccess
    property string buttonText: ""
    property bool expanded: false
    property int baseSize: 56
    property int baseHighlightHeight: 44
    signal pressed

    Layout.fillWidth: true
    implicitHeight: root.baseSize
    implicitWidth: root.baseSize
    opacity: root.enabled ? 1 : 0.4

    HoverHandler {
        id: hoverHandler
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onPressed: root.pressed()
    }

    Rectangle {
        id: itemBackground
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        width: root.width
        height: root.baseHighlightHeight
        radius: Appearance.rounding.full
        color: mouseArea.pressed ? Appearance.colors.colLayer1Active : hoverHandler.hovered ? Appearance.colors.colLayer1Hover : "transparent"

        Behavior on color {
            animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
        }
    }

    Rectangle {
        id: dot
        width: 12
        height: 12
        radius: 6
        anchors.verticalCenter: parent.verticalCenter
        x: (Math.min(root.width, root.baseSize) - width) / 2
        color: root.dotColor

        Behavior on color {
            animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
        }
    }

    StyledText {
        id: itemText
        visible: root.expanded && root.width > root.baseSize + 20
        opacity: visible ? 1 : 0
        anchors {
            left: dot.right
            leftMargin: 12
            verticalCenter: parent.verticalCenter
        }
        text: root.buttonText
        font.pixelSize: 14
        color: Appearance.colors.colSubtext
    }
}
