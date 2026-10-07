import QtQuick
import QtQuick.Controls
import io.lecooctrl.gui

/** Minimal, auto-hiding Material scrollbar. */
ScrollBar {
    id: root

    policy: ScrollBar.AsNeeded
    topPadding: Appearance.rounding.normal
    bottomPadding: Appearance.rounding.normal
    active: hovered || pressed

    contentItem: Rectangle {
        implicitWidth: 5
        implicitHeight: root.visualSize
        radius: width / 2
        color: Appearance.colors.colOnSurfaceVariant

        opacity: root.policy === ScrollBar.AlwaysOn || (root.active && root.size < 1.0) ? 0.5 : 0
        Behavior on opacity {
            NumberAnimation {
                duration: 350
                easing.type: Easing.OutCubic
            }
        }
    }
}
