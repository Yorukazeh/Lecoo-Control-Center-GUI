import QtQuick
import QtQuick.Layouts
import io.lecooctrl.gui

// Material 3 segmented button item.
RippleButton {
    id: root
    property string buttonIcon: ""
    property bool leftmost: false
    property bool rightmost: false
    property bool showCheckWhenSelected: true

    implicitHeight: 40
    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    horizontalPadding: 14
    verticalPadding: 0
    buttonRadius: 0

    leftRadius: (toggled || leftmost) ? (height / 2) : Appearance.rounding.unsharpenmore
    rightRadius: (toggled || rightmost) ? (height / 2) : Appearance.rounding.unsharpenmore

    // Use onPrimary for selected segments.
    readonly property color _on: root.toggled ? Appearance.colors.colOnPrimary : Appearance.colors.colOnSurfaceVariant

    colBackground: ColorUtils.transparentize(Appearance.colors.colOnSurfaceVariant, 1)
    colBackgroundHover: ColorUtils.mix(root.colBackground, root._on, 0.92)
    colBackgroundActive: ColorUtils.mix(root.colBackground, root._on, 0.85)
    colBackgroundToggled: Appearance.colors.colPrimary
    colBackgroundToggledHover: Appearance.colors.colPrimaryHover
    colBackgroundToggledActive: Appearance.colors.colPrimaryActive
    colRipple: root.toggled ? Appearance.colors.colPrimaryActive : ColorUtils.mix(root.colBackground, root._on, 0.8)
    border: !root.toggled
    colBorder: Appearance.colors.colOutline

    contentItem: Item {
        implicitWidth: segmentContent.implicitWidth
        implicitHeight: segmentContent.implicitHeight

        // Centre and constrain the label so long text elides.
        RowLayout {
            id: segmentContent
            anchors.centerIn: parent
            width: Math.min(implicitWidth, parent.width)
            spacing: 6

            MaterialSymbol {
                Layout.alignment: Qt.AlignVCenter
                visible: root.toggled && root.showCheckWhenSelected && root.buttonText.length > 0
                text: "check"
                iconSize: 18
                color: root._on
            }

            MaterialSymbol {
                Layout.alignment: Qt.AlignVCenter
                visible: root.buttonIcon.length > 0
                text: root.buttonIcon
                iconSize: 18
                color: root._on
            }

            StyledText {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                visible: root.buttonText.length > 0
                text: root.buttonText
                color: root._on
                font.pixelSize: 14
                font.weight: Font.Medium
            }
        }
    }
}
