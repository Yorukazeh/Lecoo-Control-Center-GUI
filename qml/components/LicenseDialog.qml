import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import io.lecooctrl.gui

/** Display a compiled-in legal document without runtime I/O. */
Popup {
    id: root

    property string documentName: ""
    property string heading: ""
    property string documentText: ""
    property string loadError: ""

    function reload() {
        root.documentText = "";
        root.loadError = "";
        if (root.documentName.length === 0)
            return;

        const text = backend.legalDocument(root.documentName);
        if (text.length > 0)
            root.documentText = text;
        else
            root.loadError = I18n.t("about.loadFailed", root.documentName);
    }

    onDocumentNameChanged: root.reload()
    onOpened: root.reload()

    parent: Overlay.overlay
    anchors.centerIn: parent
    width: Math.min(720, parent ? parent.width - 96 : 720)
    height: Math.min(600, parent ? parent.height - 96 : 600)
    padding: 0
    modal: true
    dim: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    background: Rectangle {
        radius: Appearance.rounding.verylarge
        color: Appearance.colors.colSurfaceContainerLow
        border.width: 1
        border.color: Appearance.colors.colOutlineVariant
    }

    contentItem: ColumnLayout {
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            Layout.margins: 20
            Layout.bottomMargin: 14
            spacing: 12

            MaterialSymbol {
                text: "gavel"
                iconSize: 22
                color: Appearance.colors.colPrimary
            }

            StyledText {
                Layout.fillWidth: true
                text: root.heading
                color: Appearance.colors.colOnSurface
                font.pixelSize: 18
                font.weight: Font.Medium
                wrapMode: Text.WordWrap
            }

            IconButton {
                buttonIcon: "close"
                onClicked: root.close()
            }
        }

        Divider {}

        StyledFlickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 20
            Layout.rightMargin: 8
            Layout.topMargin: 14
            Layout.bottomMargin: 20
            contentWidth: width
            contentHeight: body.implicitHeight

            StyledText {
                id: body
                width: parent.width
                text: root.loadError.length > 0 ? root.loadError : root.documentText
                color: root.loadError.length > 0 ? Appearance.colors.colError : Appearance.colors.colOnSurfaceVariant
                font.family: Appearance.font.family.monospace
                font.pixelSize: 11
                textFormat: Text.PlainText
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }
        }
    }
}
