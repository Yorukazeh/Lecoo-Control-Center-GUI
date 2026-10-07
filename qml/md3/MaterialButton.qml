import QtQuick
import QtQuick.Layouts
import io.lecooctrl.gui

// Material 3 button supporting five visual variants.
RippleButton {
    id: root
    enum Variant {
        Filled,
        Tonal,
        Elevated,
        Outlined,
        Text
    }

    property int variant: MaterialButton.Variant.Filled
    property string buttonIcon: ""
    property bool iconOnly: false

    implicitHeight: 40
    implicitWidth: iconOnly ? implicitHeight : contentItem.implicitWidth + leftPadding + rightPadding
    horizontalPadding: iconOnly ? 0 : (root.variant === MaterialButton.Variant.Text ? 12 : 24)
    verticalPadding: 0
    buttonRadius: Appearance.rounding.full
    pointingHandCursor: true

    readonly property color _accent: {
        switch (root.variant) {
        case MaterialButton.Variant.Tonal:
            return Appearance.colors.colOnSecondaryContainer;
        case MaterialButton.Variant.Elevated:
        case MaterialButton.Variant.Outlined:
        case MaterialButton.Variant.Text:
            return Appearance.colors.colPrimary;
        default:
            return Appearance.colors.colOnPrimary;
        }
    }

    colBackground: {
        switch (root.variant) {
        case MaterialButton.Variant.Tonal:
            return Appearance.colors.colSecondaryContainer;
        case MaterialButton.Variant.Elevated:
            return Appearance.colors.colSurfaceContainerLow;
        case MaterialButton.Variant.Outlined:
        case MaterialButton.Variant.Text:
            return ColorUtils.transparentize(Appearance.colors.colPrimary, 1);
        default:
            return Appearance.colors.colPrimary;
        }
    }
    // Translucent state layer over whatever the (possibly transparent) background is
    colBackgroundHover: ColorUtils.mix(root.colBackground, root._accent, 0.92)
    colBackgroundActive: ColorUtils.mix(root.colBackground, root._accent, 0.85)
    colRipple: ColorUtils.mix(root.colBackground, root._accent, 0.8)
    border: root.variant === MaterialButton.Variant.Outlined
    colBorder: Appearance.colors.colOutline

    // Drop shadow only for the elevated variant
    Loader {
        z: -1
        active: root.variant === MaterialButton.Variant.Elevated
        anchors.fill: parent
        sourceComponent: StyledRectangularShadow {
            target: root.background
        }
    }

    // Center the button content explicitly.
    contentItem: Item {
        implicitWidth: buttonContent.implicitWidth
        implicitHeight: buttonContent.implicitHeight

        RowLayout {
            id: buttonContent
            anchors.centerIn: parent
            spacing: 8

            Loader {
                Layout.alignment: Qt.AlignVCenter
                active: root.buttonIcon && root.buttonIcon.length > 0
                visible: active
                sourceComponent: MaterialSymbol {
                    text: root.buttonIcon
                    iconSize: 18
                    color: root._accent
                }
            }

            StyledText {
                Layout.alignment: Qt.AlignVCenter
                visible: !root.iconOnly
                text: root.buttonText
                color: root._accent
                font.pixelSize: 14
                font.weight: Font.Medium
            }
        }
    }
}
