import QtQuick
import QtQuick.Layouts
import io.lecooctrl.gui

/** Vertical container for NavigationRailButton destinations. */
ColumnLayout {
    id: root
    property bool expanded: true
    property int currentIndex: 0
    default property alias contentData: railColumn.data

    spacing: 4

    ColumnLayout {
        id: railColumn
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignTop
        spacing: 4
    }
}
