import QtQuick
import QtQuick.Controls
import io.lecooctrl.gui

/** Flickable with smooth wheel scrolling and a Material scrollbar. */
Flickable {
    id: root
    maximumFlickVelocity: 3500
    boundsBehavior: Flickable.DragOverBounds

    property real scrollTargetY: 0
    property real mouseScrollDeltaThreshold: 120

    ScrollBar.vertical: StyledScrollBar {}

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        onWheel: function (wheelEvent) {
            const delta = wheelEvent.angleDelta.y / root.mouseScrollDeltaThreshold;
            const scrollFactor = Math.abs(wheelEvent.angleDelta.y) >= root.mouseScrollDeltaThreshold ? 60 : 100;
            const maxY = Math.max(0, root.contentHeight - root.height);
            const base = scrollAnim.running ? root.scrollTargetY : root.contentY;
            const targetY = Math.max(0, Math.min(base - delta * scrollFactor, maxY));
            root.scrollTargetY = targetY;
            root.contentY = targetY;
            wheelEvent.accepted = true;
        }
    }

    Behavior on contentY {
        NumberAnimation {
            id: scrollAnim
            duration: Appearance.animation.scroll.duration
            easing.type: Appearance.animation.scroll.type
            easing.bezierCurve: Appearance.animation.scroll.bezierCurve
        }
    }

    onContentYChanged: {
        if (!scrollAnim.running)
            root.scrollTargetY = root.contentY;
    }
}
