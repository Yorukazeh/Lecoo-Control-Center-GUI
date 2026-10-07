import QtQuick
import io.lecooctrl.gui

// icon button
RippleButton {
    id: root
    enum Variant {
        Standard,
        Filled,
        Tonal,
        Outlined
    }

    property int variant: IconButton.Variant.Standard
    property string buttonIcon: "star"
    property bool selected: false

    implicitWidth: 40
    implicitHeight: 40
    buttonRadius: Appearance.rounding.full
    padding: 0

    property color _on: {
        if (root.selected) {
            switch (root.variant) {
            case IconButton.Variant.Filled:
                return Appearance.colors.colOnPrimary;
            case IconButton.Variant.Tonal:
                return Appearance.colors.colOnSecondaryContainer;
            default:
                return Appearance.colors.colPrimary;
            }
        }
        switch (root.variant) {
        case IconButton.Variant.Filled:
            return Appearance.colors.colOnPrimary;
        case IconButton.Variant.Tonal:
            return Appearance.colors.colOnSecondaryContainer;
        default:
            return Appearance.colors.colOnSurfaceVariant;
        }
    }

    colBackground: {
        switch (root.variant) {
        case IconButton.Variant.Filled:
            return Appearance.colors.colPrimary;
        case IconButton.Variant.Tonal:
            return Appearance.colors.colSecondaryContainer;
        default:
            return ColorUtils.transparentize(Appearance.colors.colOnSurfaceVariant, 1);
        }
    }
    colBackgroundHover: {
        if (root.variant === IconButton.Variant.Filled)
            return Appearance.colors.colPrimaryHover;
        if (root.variant === IconButton.Variant.Tonal)
            return Appearance.colors.colSecondaryContainerHover;
        return ColorUtils.mix(root.colBackground, root._on, 0.9);
    }
    colBackgroundActive: ColorUtils.mix(root.colBackground, root._on, 0.85)
    colRipple: ColorUtils.mix(root.colBackground, root._on, 0.8)
    border: root.variant === IconButton.Variant.Outlined
    colBorder: Appearance.colors.colOutline

    contentItem: MaterialSymbol {
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        iconSize: 22
        text: root.buttonIcon
        color: root._on
    }
}
