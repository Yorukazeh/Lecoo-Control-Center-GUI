import QtQuick
import QtQuick.Layouts
import io.lecooctrl.gui

// Material 3 list item with optional leading and trailing content.
RippleButton {
    id: root
    property string headline: "Headline"
    property string supportingText: ""
    property string leadingIcon: ""
    property string trailingIcon: ""
    property bool showDivider: false
    default property alias trailingContent: trailingSlot.data

    implicitHeight: root.supportingText.length > 0 ? 72 : 56
    implicitWidth: 360
    buttonRadius: 0
    padding: 0
    colBackground: ColorUtils.transparentize(Appearance.colors.colOnSurface, 1)
    colBackgroundHover: ColorUtils.applyAlpha(Appearance.colors.colOnSurface, 0.08)
    colBackgroundActive: ColorUtils.applyAlpha(Appearance.colors.colOnSurface, 0.12)
    colRipple: ColorUtils.applyAlpha(Appearance.colors.colOnSurface, 0.12)

    contentItem: Item {
        implicitHeight: root.implicitHeight
        implicitWidth: root.implicitWidth

        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                leftMargin: 16
            }
            visible: root.showDivider
            height: 1
            color: Appearance.colors.colOutlineVariant
        }

        MaterialSymbol {
            id: leading
            visible: root.leadingIcon.length > 0
            anchors {
                left: parent.left
                leftMargin: 16
                verticalCenter: parent.verticalCenter
            }
            text: root.leadingIcon
            iconSize: 24
            color: Appearance.colors.colOnSurfaceVariant
        }

        ColumnLayout {
            anchors {
                left: leading.visible ? leading.right : parent.left
                leftMargin: 16
                right: trailingArea.left
                rightMargin: 12
                verticalCenter: parent.verticalCenter
            }
            spacing: 0

            StyledText {
                Layout.fillWidth: true
                text: root.headline
                color: Appearance.colors.colOnSurface
                font.pixelSize: 16
                elide: Text.ElideRight
            }
            StyledText {
                Layout.fillWidth: true
                visible: root.supportingText.length > 0
                text: root.supportingText
                color: Appearance.colors.colOnSurfaceVariant
                font.pixelSize: 14
                elide: Text.ElideRight
            }
        }

        RowLayout {
            id: trailingArea
            anchors {
                right: parent.right
                rightMargin: 16
                verticalCenter: parent.verticalCenter
            }
            spacing: 8

            Item {
                id: trailingSlot
                Layout.alignment: Qt.AlignVCenter
                implicitWidth: childrenRect.width
                implicitHeight: childrenRect.height
            }

            MaterialSymbol {
                visible: root.trailingIcon.length > 0
                text: root.trailingIcon
                iconSize: 24
                color: Appearance.colors.colOnSurfaceVariant
            }
        }
    }
}
