pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import io.lecooctrl.gui

// Material 3 slider with optional stops and dividers.
Slider {
    id: root

    property list<real> stopIndicatorValues: []
    property list<real> dividerValues: []

    property real handleDefaultWidth: 5
    property real handlePressedWidth: 4
    property color highlightColor: Appearance.colors.colPrimary
    property color trackColor: Appearance.colors.colTrackContainer   // secondaryContainer one tone darker, or it reads as white
    property color handleColor: Appearance.colors.colPrimary
    property color dotColor: Appearance.m3colors.m3onSecondaryContainer
    property color dotColorHighlighted: Appearance.m3colors.m3onPrimary
    property real unsharpenRadius: Appearance.rounding.unsharpen
    property real trackWidth: 16
    property real trackRadius: trackWidth / 2
    property real handleHeight: trackWidth + 24
    property real handleWidth: root.pressed ? handlePressedWidth : handleDefaultWidth
    property real handleMargins: 4
    property real handleTrackGap: 6
    property real dividerMargins: 2
    property real trackDotSize: 3
    property bool usePercentTooltip: true
    property string tooltipContent: usePercentTooltip ? `${Math.round(((value - from) / (to - from)) * 100)}%` : `${Math.round(value)}`

    leftPadding: handleMargins
    rightPadding: handleMargins
    property real effectiveDraggingWidth: width - leftPadding - rightPadding

    Layout.fillWidth: true
    from: 0
    to: 1

    Behavior on value {
        SmoothedAnimation {
            velocity: Appearance.animation.elementMoveFast.velocity
        }
    }

    component TrackDot: Rectangle {
        required property real value
        property real normalizedValue: (value - root.from) / (root.to - root.from)
        anchors.verticalCenter: parent.verticalCenter
        x: root.handleMargins + (normalizedValue * root.effectiveDraggingWidth) - (root.trackDotSize / 2)
        width: root.trackDotSize
        height: root.trackDotSize
        radius: Appearance.rounding.full
        color: normalizedValue > root.visualPosition ? root.dotColor : root.dotColorHighlighted

        Behavior on color {
            animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
        }
    }

    MouseArea {
        anchors.fill: parent
        onPressed: (mouse) => mouse.accepted = false
        cursorShape: root.pressed ? Qt.ClosedHandCursor : Qt.PointingHandCursor
    }

    background: Item {
        id: background
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        width: root.width
        implicitHeight: trackWidth
        property var normalized: root.dividerValues.map(v => (v - root.from) / (root.to - root.from))
        property var filtered: normalized.filter(v => Math.abs(v - root.visualPosition) * effectiveDraggingWidth > handleMargins + handleWidth / 2 - dividerMargins)
        property var leftValues: [0, ...filtered.filter(v => v < root.visualPosition), root.visualPosition]
        property var rightValues: [root.visualPosition, ...filtered.filter(v => v > root.visualPosition), 1]
        property var leftWidths: leftValues.map((v, i, a) => a[i + 1] - v).slice(0, -1)
        property var rightWidths: rightValues.map((v, i, a) => a[i + 1] - v).slice(0, -1)

        Repeater {
            model: background.leftWidths.length

            Rectangle {
                required property int index
                anchors.verticalCenter: background.verticalCenter
                property real leftMargin: index > 0 ? root.dividerMargins : 0
                property real rightMargin: index < background.leftWidths.length - 1 ? root.dividerMargins : 0
                x: background.leftValues[index] * root.effectiveDraggingWidth + leftMargin + (index > 0 ? leftPadding : 0)
                width: background.leftWidths[index] * root.effectiveDraggingWidth - leftMargin - rightMargin + (index === 0 ? leftPadding : 0) - (index === background.leftWidths.length - 1 ? root.handleWidth / 2 + root.handleTrackGap : 0)
                height: root.trackWidth
                color: root.highlightColor
                topLeftRadius: index === 0 ? root.trackRadius : root.unsharpenRadius
                bottomLeftRadius: index === 0 ? root.trackRadius : root.unsharpenRadius
                topRightRadius: index === background.leftWidths.length - 1 ? 0 : root.unsharpenRadius
                bottomRightRadius: index === background.leftWidths.length - 1 ? 0 : root.unsharpenRadius
            }
        }

        Repeater {
            model: background.rightWidths.length

            Rectangle {
                required property int index
                anchors.verticalCenter: background.verticalCenter
                property real leftMargin: index > 0 ? root.dividerMargins : 0
                property real rightMargin: index < background.rightWidths.length - 1 ? root.dividerMargins : 0
                x: background.rightValues[index] * root.effectiveDraggingWidth + leftMargin + leftPadding + (index === 0 ? root.handleWidth / 2 + root.handleTrackGap : 0)
                width: background.rightWidths[index] * root.effectiveDraggingWidth - leftMargin - rightMargin + (index === background.rightWidths.length - 1 ? rightPadding : 0) - (index === 0 ? root.handleWidth / 2 + root.handleTrackGap : 0)
                height: trackWidth
                color: root.trackColor
                topRightRadius: index === background.rightWidths.length - 1 ? root.trackRadius : root.unsharpenRadius
                bottomRightRadius: index === background.rightWidths.length - 1 ? root.trackRadius : root.unsharpenRadius
                topLeftRadius: index === 0 ? 0 : root.unsharpenRadius
                bottomLeftRadius: index === 0 ? 0 : root.unsharpenRadius
            }
        }

        Repeater {
            model: root.stopIndicatorValues
            TrackDot {
                required property real modelData
                value: modelData
                anchors.verticalCenter: parent?.verticalCenter
            }
        }
    }

    handle: Rectangle {
        id: handle
        implicitWidth: root.handleWidth
        implicitHeight: root.handleHeight
        x: root.leftPadding + (root.visualPosition * root.effectiveDraggingWidth) - (root.handleWidth / 2)
        anchors.verticalCenter: parent.verticalCenter
        radius: Appearance.rounding.full
        color: root.handleColor

        Behavior on implicitWidth {
            animation: Appearance?.animation.elementMoveFast.numberAnimation.createObject(this)
        }
    }
}
