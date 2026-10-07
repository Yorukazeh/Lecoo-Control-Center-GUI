import QtQuick
import QtQuick.Layouts
import io.lecooctrl.gui

/** Provide a centered scrollable page with an entrance animation. */
StyledFlickable {
    id: root

    property real bottomPadding: 48
    // Set the width threshold for collapsing the navigation rail.
    property real minContentWidth: 520
    readonly property real availableWidth: Math.max(minContentWidth, Math.min(width - 48, 1180))

    /** Whether this page is the active one; drives the entrance animation. */
    property bool active: true
    /** Vertical offset (dp) the content floats up from. */
    property real enterOffset: 28

    default property alias contentData: column.data

    contentWidth: Math.max(width, root.availableWidth + 48)
    // Keep the inactive page offset inside the scrollable content.
    contentHeight: column.implicitHeight + root.bottomPadding + root.enterOffset

    ColumnLayout {
        id: column
        x: Math.max(24, (root.contentWidth - width) / 2)
        y: root.active ? 24 : 24 + root.enterOffset
        width: root.availableWidth
        spacing: 18
        opacity: root.active ? 1 : 0

        // Animate the page into view when it becomes active.
        Behavior on y {
            NumberAnimation {
                duration: 320
                easing.type: Easing.OutCubic
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: 220
                easing.type: Easing.OutCubic
            }
        }
    }
}
