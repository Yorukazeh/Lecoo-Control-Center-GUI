import QtQuick
import io.lecooctrl.gui

/** Transparent MouseArea that only changes the cursor to a pointing hand. */
MouseArea {
    anchors.fill: parent
    onPressed: (mouse) => mouse.accepted = false
    cursorShape: Qt.PointingHandCursor
}
