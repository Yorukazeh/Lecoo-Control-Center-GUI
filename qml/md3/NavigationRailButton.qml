import QtQuick
import QtQuick.Layouts
import io.lecooctrl.gui

// Navigation rail destination with an active indicator.
Item {
    id: root
    property bool toggled: false
    property string buttonIcon: "circle"
    property string buttonText: "Item"
    property bool expanded: false
    property int baseSize: 56
    property int baseHighlightHeight: 44
    signal pressed

    Layout.fillWidth: true
    implicitHeight: baseSize
    implicitWidth: baseSize
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
        color: root.toggled ? (mouseArea.pressed ? Appearance.colors.colSecondaryContainerActive : hoverHandler.hovered ? Appearance.colors.colSecondaryContainerHover : Appearance.colors.colSecondaryContainer) : (mouseArea.pressed ? Appearance.colors.colLayer1Active : hoverHandler.hovered ? Appearance.colors.colLayer1Hover : ColorUtils.transparentize(Appearance.colors.colLayer1Hover, 1))

        Behavior on color {
            animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
        }
    }

    MaterialSymbol {
        id: navRailButtonIcon
        x: (Math.min(root.width, root.baseSize) - implicitWidth) / 2
        anchors.verticalCenter: parent.verticalCenter
        iconSize: 24
        text: root.buttonIcon
        color: root.toggled ? Appearance.m3colors.m3onSecondaryContainer : Appearance.colors.colOnLayer1
        Behavior on color {
            animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
        }
    }

    StyledText {
        id: itemText
        visible: root.expanded && root.width > root.baseSize + 20
        opacity: visible ? 1 : 0
        anchors {
            left: navRailButtonIcon.right
            leftMargin: 12
            verticalCenter: parent.verticalCenter
        }
        text: root.buttonText
        typeScale: "labelLarge"
        // Use onSurfaceVariant for inactive navigation labels.
        color: root.toggled ? Appearance.colors.colOnSurface : Appearance.colors.colOnLayer1
        Behavior on opacity {
            animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
        }
    }
}
