import QtQuick
import Qt5Compat.GraphicalEffects
import io.lecooctrl.gui

/** Render a compatible soft shadow behind a rounded target. */
Item {
    id: root

    /** Item whose rounded bounds the shadow follows. */
    required property var target

    property real blur: 0.9 * Appearance.sizes.elevationMargin
    property color color: Appearance.colors.colShadow
    property vector2d offset: Qt.vector2d(0.0, 1.0)
    property real spread: 1
    property bool cached: true

    // The surrounding Loader already fills the target, so match its geometry.
    anchors.fill: parent

    Rectangle {
        id: shadowShape
        anchors.fill: parent
        radius: root.target ? root.target.radius : 0
        color: root.color
        visible: false
    }

    DropShadow {
        anchors.fill: shadowShape
        source: shadowShape
        radius: root.blur
        samples: 1 + 2 * Math.ceil(root.blur)
        color: root.color
        horizontalOffset: root.offset.x
        verticalOffset: root.offset.y
        spread: root.spread
        cached: root.cached
    }
}
