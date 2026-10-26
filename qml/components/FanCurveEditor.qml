import QtQuick
import QtQuick.Layouts
import io.lecooctrl.gui

/** Per-fan temperature curve editor. */
Card {
    id: root

    property string target: "cpu"
    property string fanMode: "auto"
    property color accent: Appearance.colors.colPrimary
    property bool curveEnabled: false
    property var points: [60, 80, 100, 130, 170, 220]

    readonly property bool active: root.curveEnabled && root.fanMode === "custom"

    Layout.fillWidth: true
    title: root.target === "cpu" ? I18n.t("fan.curve.titleCpu") : I18n.t("fan.curve.titleGpu")
    leadingIcon: root.target === "cpu" ? "cyclone" : "air"
    subtitle: root.target === "cpu" ? I18n.t("fan.curve.subtitleCpu") : I18n.t("fan.curve.subtitleGpu")
    colBackground: Appearance.colors.colSurfaceContainerLow

    function setPoint(index, value) {
        var next = root.points.slice()
        next[index] = Math.max(0, Math.min(220, Math.round(value)))
        // Keep higher temperatures at or above lower temperatures.
        for (var lower = index - 1; lower >= 0; --lower) {
            if (next[lower] > next[lower + 1])
                next[lower] = next[lower + 1]
        }
        for (var higher = index + 1; higher < next.length; ++higher) {
            if (next[higher] < next[higher - 1])
                next[higher] = next[higher - 1]
        }
        if (next[index] === root.points[index])
            return
        root.points = next
    }

    function copyTo(other) {
        other.points = root.points.slice()
    }

    function syncCurve() {
        // Property-change handlers can run before the active binding updates.
        var active = root.curveEnabled && root.fanMode === "custom"
        backend.setFanCurve(root.target, active, root.points.join(","))
    }

    onPointsChanged: root.syncCurve()
    onCurveEnabledChanged: root.syncCurve()
    onFanModeChanged: {
        if (root.fanMode !== "custom" && root.curveEnabled)
            root.curveEnabled = false
        else
            root.syncCurve()
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 8

        StyledSwitch {
            text: I18n.t("fan.curve.enable")
            checked: root.curveEnabled
            enabled: root.fanMode === "custom"
            onToggled: root.curveEnabled = checked
        }

        Item { Layout.fillWidth: true }

        StyledText {
            visible: root.fanMode !== "custom"
            text: I18n.t("fan.curve.customRequired")
            color: Appearance.colors.colOnSurfaceVariant
            font.pixelSize: 11
            horizontalAlignment: Text.AlignRight
        }
    }

    StyledText {
        Layout.fillWidth: true
        visible: root.active && !backend.monitoring
        text: I18n.t("fan.curve.monitoringRequired")
        color: Appearance.colors.colError
        font.pixelSize: 11
        wrapMode: Text.WordWrap
    }

    Item {
        id: chart
        Layout.fillWidth: true
        Layout.preferredHeight: 220
        opacity: root.active ? 1 : 0.45
        enabled: root.active

        readonly property real plotLeft: 34
        readonly property real plotRight: 8
        readonly property real plotTop: 10
        readonly property real plotBottom: 24
        readonly property real minTemp: 30
        readonly property real maxTemp: 100
        readonly property real maxPwm: 220

        function xForTemp(temperature) {
            var clamped = Math.max(minTemp, Math.min(maxTemp, temperature))
            return plotLeft + (clamped - minTemp) / (maxTemp - minTemp)
                * (width - plotLeft - plotRight)
        }

        function xForIndex(index) {
            return xForTemp(40 + index * 10)
        }

        function yForPwm(pwm) {
            var clamped = Math.max(0, Math.min(maxPwm, pwm))
            return plotTop + (1 - clamped / maxPwm) * (height - plotTop - plotBottom)
        }

        function pwmForY(y) {
            var ratio = (height - plotBottom - y) / (height - plotTop - plotBottom)
            return Math.round(Math.max(0, Math.min(1, ratio)) * maxPwm)
        }

        Canvas {
            id: canvas
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                ctx.lineWidth = 1
                ctx.strokeStyle = String(Appearance.colors.colOutlineVariant)

                for (var i = 0; i <= 7; ++i) {
                    var gridX = chart.xForTemp(30 + i * 10)
                    ctx.beginPath()
                    ctx.moveTo(gridX, chart.plotTop)
                    ctx.lineTo(gridX, height - chart.plotBottom)
                    ctx.stroke()
                }
                for (var j = 0; j <= 4; ++j) {
                    var gridY = chart.yForPwm(j * 55)
                    ctx.beginPath()
                    ctx.moveTo(chart.plotLeft, gridY)
                    ctx.lineTo(width - chart.plotRight, gridY)
                    ctx.stroke()
                }

                ctx.beginPath()
                ctx.moveTo(chart.xForTemp(30), chart.yForPwm(root.points[0]))
                for (var k = 0; k < 6; ++k)
                    ctx.lineTo(chart.xForIndex(k), chart.yForPwm(root.points[k]))
                ctx.lineTo(chart.xForTemp(100), chart.yForPwm(root.points[5]))
                ctx.lineTo(chart.xForTemp(100), height - chart.plotBottom)
                ctx.lineTo(chart.xForTemp(30), height - chart.plotBottom)
                ctx.closePath()
                ctx.globalAlpha = 0.12
                ctx.fillStyle = String(root.accent)
                ctx.fill()
                ctx.globalAlpha = 1

                ctx.beginPath()
                ctx.moveTo(chart.xForTemp(30), chart.yForPwm(root.points[0]))
                for (var m = 0; m < 6; ++m)
                    ctx.lineTo(chart.xForIndex(m), chart.yForPwm(root.points[m]))
                ctx.lineTo(chart.xForTemp(100), chart.yForPwm(root.points[5]))
                ctx.strokeStyle = String(root.accent)
                ctx.lineWidth = 2.5
                ctx.lineCap = "round"
                ctx.lineJoin = "round"
                ctx.stroke()
            }

            Connections {
                target: root
                function onPointsChanged() { canvas.requestPaint() }
                function onAccentChanged() { canvas.requestPaint() }
            }
            Connections {
                target: Appearance
                function onDarkModeChanged() { canvas.requestPaint() }
            }
        }

        Repeater {
            model: [30, 40, 50, 60, 70, 80, 90, 100]

            StyledText {
                required property int modelData
                x: chart.xForTemp(modelData) - width / 2
                y: chart.yForPwm(0) + 6
                width: 28
                horizontalAlignment: Text.AlignHCenter
                text: modelData + "°"
                color: Appearance.colors.colOnSurfaceVariant
                font.pixelSize: 10
            }
        }

        Repeater {
            model: [0, 110, 220]

            StyledText {
                required property int modelData
                x: 0
                y: chart.yForPwm(modelData) - height / 2
                width: chart.plotLeft - 6
                horizontalAlignment: Text.AlignRight
                text: modelData
                color: Appearance.colors.colOnSurfaceVariant
                font.pixelSize: 10
            }
        }

        Repeater {
            model: 6

            Rectangle {
                required property int index
                width: 14
                height: 14
                radius: width / 2
                x: chart.xForIndex(index) - width / 2
                y: chart.yForPwm(root.points[index]) - height / 2
                color: root.accent
                border.width: 2
                border.color: Appearance.colors.colSurfaceContainerLow

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.SizeVerCursor
                    preventStealing: true
                    onPositionChanged: {
                        if (!pressed)
                            return
                        var position = mapToItem(chart, mouse.x, mouse.y)
                        root.setPoint(index, chart.pwmForY(position.y))
                    }
                }
            }
        }
    }

}
