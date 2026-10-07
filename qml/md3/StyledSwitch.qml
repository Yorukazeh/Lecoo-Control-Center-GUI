import QtQuick
import QtQuick.Controls
import io.lecooctrl.gui

/** Implement the Material 3 switch track, thumb, label, and ripple. */
Switch {
    id: root

    /// Relative size of the switch.
    property real scale: 1.0

    /// Width and height of the switch track.
    readonly property real trackWidth: 52 * root.scale
    readonly property real trackHeight: 32 * root.scale

    // Keep the label beside the switch track.
    readonly property real labelSpacing: 10 * root.scale

    TextMetrics {
        id: labelMetrics
        font: label.font
        text: root.text
    }
    implicitWidth: root.trackWidth + (root.text.length > 0 ? root.labelSpacing + labelMetrics.width : 0)
    implicitHeight: root.trackHeight

    contentItem: StyledText {
        id: label
        anchors.left: parent.left
        anchors.leftMargin: root.trackWidth + root.labelSpacing
        anchors.verticalCenter: parent.verticalCenter
        text: root.text
        visible: root.text.length > 0
        color: root.enabled ? Appearance.colors.colOnSurface
                            : ColorUtils.applyAlpha(Appearance.colors.colOnSurface, 0.38)
        font.pixelSize: 14
        font.weight: Font.Medium
    }

    /// Icon drawn on the thumb while checked (a Material icon name).
    property string checkIcon: "check"
    property bool showCheckIcon: true

    property color checkedTrackColor: Appearance.colors.colPrimary
    property color checkedThumbColor: Appearance.colors.colOnPrimary
    property color checkedIconColor: Appearance.colors.colPrimary
    property color uncheckedTrackColor: Appearance.colors.colSurfaceContainerHighest
    property color uncheckedThumbColor: Appearance.colors.colOutline
    property color trackOutlineColor: Appearance.colors.colOutline

    // Apply Material 3 disabled colors.
    readonly property color disabledTrackColor: ColorUtils.applyAlpha(Appearance.colors.colOnSurface, 0.12)
    readonly property color disabledThumbColor: ColorUtils.applyAlpha(Appearance.colors.colOnSurface, 0.38)
    readonly property color disabledCheckedThumbColor: Appearance.colors.colLayer0

    PointingHandInteraction {}

    background: Rectangle {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: root.trackWidth
        height: root.trackHeight
        radius: height / 2
        color: !root.enabled ? root.disabledTrackColor
                             : (root.checked ? root.checkedTrackColor : root.uncheckedTrackColor)
        // The off track is outlined in Material 3, the on track is not.
        border.width: root.checked ? 0 : 2 * root.scale
        border.color: !root.enabled ? (root.checked ? "transparent" : root.disabledTrackColor)
                                    : (root.checked ? "transparent" : root.trackOutlineColor)

        Behavior on color {
            ColorAnimation { duration: Appearance.instantColors ? 0 : 150 }
        }
        Behavior on border.color {
            ColorAnimation { duration: Appearance.instantColors ? 0 : 150 }
        }

        // Render the ripple inside the track background so the control style does not cover it.
        Item {
            id: rippleClip
            anchors.fill: parent
            visible: root.enabled

            Rectangle {
                id: ripple
                readonly property real targetSize: Math.max(rippleClip.width, rippleClip.height) * 2.5
                property real size: 0
                // Clamp the expanding ripple to the track bounds.
                width: Math.min(size, rippleClip.width)
                height: Math.min(size, rippleClip.height)
                radius: height / 2
                // Center the ripple because the control does not expose the press position.
                x: (rippleClip.width - width) / 2
                y: (rippleClip.height - height) / 2
                color: root.checked ? root.checkedTrackColor : Appearance.colors.colOnSurface
                opacity: 0
            }
        }
    }

    indicator: Rectangle {
        readonly property real thumbSize: (root.checked ? 24 : 16) * root.scale
        readonly property real padChecked: 4 * root.scale
        readonly property real padUnchecked: 8 * root.scale

        width: thumbSize
        height: thumbSize
        radius: height / 2
        color: !root.enabled ? (root.checked ? root.disabledCheckedThumbColor : root.disabledThumbColor)
                             : (root.checked ? root.checkedThumbColor : root.uncheckedThumbColor)

        // Animate thumb travel and growth with separate properties.
        anchors.verticalCenter: parent.verticalCenter
        x: root.checked ? (root.trackWidth - width - padChecked) : padUnchecked

        Behavior on color {
            ColorAnimation { duration: Appearance.instantColors ? 0 : 150 }
        }
        Behavior on x {
            NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
        }
        Behavior on width {
            NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
        }

        MaterialSymbol {
            anchors.centerIn: parent
            visible: root.showCheckIcon
            text: root.checkIcon
            iconSize: 16 * root.scale
            color: root.enabled ? root.checkedIconColor
                                : ColorUtils.applyAlpha(Appearance.colors.colOnSurface, 0.38)
            // Scale the check mark in when enabled.
            scale: root.checked ? 1 : 0
            Behavior on scale {
                NumberAnimation { duration: 150; easing.type: Easing.OutBack }
            }
        }
    }

    NumberAnimation {
        id: rippleExpand
        target: ripple
        property: "size"
        to: ripple.targetSize
        duration: 450
        easing.type: Easing.OutQuart
    }
    NumberAnimation {
        id: rippleFadeIn
        target: ripple
        property: "opacity"
        to: 0.12
        duration: 200
    }
    NumberAnimation {
        id: rippleFadeOut
        target: ripple
        property: "opacity"
        to: 0
        duration: 300
    }

    onPressedChanged: {
        rippleExpand.stop()
        rippleFadeIn.stop()
        rippleFadeOut.stop()
        if (root.pressed) {
            ripple.size = 0
            ripple.opacity = 0
            rippleFadeIn.start()
            rippleExpand.start()
        } else {
            rippleFadeOut.start()
        }
    }
}
