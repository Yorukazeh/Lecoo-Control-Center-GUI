import QtQuick
import QtQuick.Layouts
import io.lecooctrl.gui

// Material 3 chip with optional selection, elevation, and icons.
RippleButton {
    id: root
    property string leadingIcon: ""
    property string trailingIcon: ""
    property bool elevated: false
    property bool showCheckWhenSelected: true

    implicitHeight: 32
    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    horizontalPadding: 12
    verticalPadding: 0
    buttonRadius: Appearance.rounding.verysmall
    border: !root.toggled && !root.elevated
    colBorder: Appearance.colors.colOutline

    // Use onPrimary for selected chips.
    readonly property color _on: root.toggled ? Appearance.colors.colOnPrimary : Appearance.colors.colOnSurfaceVariant

    colBackground: root.elevated ? Appearance.colors.colSurfaceContainerLow : ColorUtils.transparentize(Appearance.colors.colOnSurfaceVariant, 1)
    colBackgroundHover: ColorUtils.mix(root.colBackground, root._on, 0.92)
    colBackgroundActive: ColorUtils.mix(root.colBackground, root._on, 0.85)
    colBackgroundToggled: Appearance.colors.colPrimary
    colBackgroundToggledHover: Appearance.colors.colPrimaryHover
    colBackgroundToggledActive: Appearance.colors.colPrimaryActive
    colRipple: root.toggled ? Appearance.colors.colPrimaryActive : ColorUtils.mix(root.colBackground, root._on, 0.8)

    Loader {
        z: -1
        active: root.elevated
        anchors.fill: parent
        sourceComponent: StyledRectangularShadow {
            target: root.background
            blur: 4
        }
    }

    contentItem: RowLayout {
        spacing: 0

        Loader {
            Layout.alignment: Qt.AlignVCenter
            active: root.leadingIcon && root.leadingIcon.length > 0
            visible: active
            sourceComponent: MaterialSymbol {
                text: root.leadingIcon
                iconSize: 18
                color: root._on
            }
        }

        StyledText {
            Layout.alignment: Qt.AlignVCenter
            Layout.leftMargin: (root.leadingIcon && root.leadingIcon.length > 0) ? 8 : 0
            text: root.buttonText
            color: root._on
            font.pixelSize: 14
            font.weight: Font.Medium
        }

        Loader {
            Layout.alignment: Qt.AlignVCenter
            active: root.trailingIcon && root.trailingIcon.length > 0
            visible: active
            sourceComponent: MaterialSymbol {
                text: root.trailingIcon
                iconSize: 18
                color: root._on
            }
        }
    }
}
