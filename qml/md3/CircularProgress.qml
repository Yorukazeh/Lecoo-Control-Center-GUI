import QtQuick
import QtQuick.Shapes
import io.lecooctrl.gui

// Material 3 circular progress indicator.
Item {
    id: root

    property int implicitSize: 30
    property int lineWidth: 3
    property real value: 0
    property bool indeterminate: false
    property color colPrimary: Appearance.colors.colPrimary
    property color colSecondary: Appearance.colors.colSecondaryContainer
    property real gapAngle: 360 / 18
    property bool enableAnimation: true
    property int animationDuration: 800
    property var easingType: Easing.OutCubic

    implicitWidth: implicitSize
    implicitHeight: implicitSize

    property real degree: value * 360
    property real centerX: root.width / 2
    property real centerY: root.height / 2
    property real arcRadius: root.implicitSize / 2 - root.lineWidth
    property real startAngle: -90

    Behavior on degree {
        enabled: root.enableAnimation
        NumberAnimation {
            duration: root.animationDuration
            easing.type: root.easingType
        }
    }

    // Indeterminate sweep state
    property real sweep: 30
    property real rotation: 0
    RotationAnimation on rotation {
        running: root.indeterminate
        loops: Animation.Infinite
        from: 0
        to: 360
        duration: 1400
    }
    SequentialAnimation on sweep {
        running: root.indeterminate
        loops: Animation.Infinite
        NumberAnimation { to: 280; duration: 900; easing.type: Easing.InOutCubic }
        NumberAnimation { to: 40; duration: 500; easing.type: Easing.InOutCubic }
        NumberAnimation { to: 30; duration: 300 }
    }

    Shape {
        anchors.fill: parent
        rotation: root.indeterminate ? root.rotation : 0
        layer.enabled: true
        layer.smooth: true
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeColor: root.colSecondary
            strokeWidth: root.lineWidth
            capStyle: ShapePath.RoundCap
            fillColor: "transparent"
            PathAngleArc {
                centerX: root.centerX
                centerY: root.centerY
                radiusX: root.arcRadius
                radiusY: root.arcRadius
                startAngle: root.startAngle - root.gapAngle
                sweepAngle: -(360 - root.degree - 2 * root.gapAngle)
            }
        }
        ShapePath {
            strokeColor: root.colPrimary
            strokeWidth: root.lineWidth
            capStyle: ShapePath.RoundCap
            fillColor: "transparent"
            PathAngleArc {
                centerX: root.centerX
                centerY: root.centerY
                radiusX: root.arcRadius
                radiusY: root.arcRadius
                startAngle: root.startAngle
                sweepAngle: root.indeterminate ? root.sweep : root.degree
            }
        }
    }
}
