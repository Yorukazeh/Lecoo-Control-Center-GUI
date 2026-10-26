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

    Behavior on leftRadius {
        NumberAnimation {
            duration: Appearance.animation.elementMoveFast.duration
            easing.type: Appearance.animation.elementMoveFast.type
            easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
        }
    }
    Behavior on rightRadius {
        NumberAnimation {
            duration: Appearance.animation.elementMoveFast.duration
            easing.type: Appearance.animation.elementMoveFast.type
            easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
        }
    }

    // Use onPrimary for selected segments and onSurface for unselected ones.
    readonly property color _on: root.toggled ? Appearance.colors.colOnPrimary : Appearance.colors.colOnSurface
    readonly property real _idleAlpha: Appearance.darkMode ? 0.15 : 0.12

    colBackground: ColorUtils.applyAlpha(Appearance.colors.colOnSurface, root._idleAlpha)
    colBackgroundHover: ColorUtils.applyAlpha(Appearance.colors.colOnSurface, root._idleAlpha + 0.06)
    colBackgroundActive: ColorUtils.applyAlpha(Appearance.colors.colOnSurface, root._idleAlpha + 0.12)
    colBackgroundToggled: Appearance.colors.colPrimary
    colBackgroundToggledHover: Appearance.colors.colPrimaryHover
    colBackgroundToggledActive: Appearance.colors.colPrimaryActive
    colRipple: root.toggled ? Appearance.colors.colPrimaryActive : ColorUtils.applyAlpha(root._on, 0.12)

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
