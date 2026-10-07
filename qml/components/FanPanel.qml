import QtQuick
import QtQuick.Layouts
import io.lecooctrl.gui

/** Fan controls with automatic, full-speed, and custom PWM modes. */
Card {
    id: panel

    property string target: "cpu"
    property color accent: Appearance.colors.colPrimary
    property string selectedMode: "auto"
    property int pwmValue: 160
    signal modeSelected(string mode, int pwm)

    readonly property var modes: [
        { key: "auto", label: I18n.t("fan.auto"), icon: "auto_mode" },
        { key: "full", label: I18n.t("fan.full"), icon: "rocket_launch" },
        { key: "custom", label: I18n.t("fan.custom"), icon: "tune" }
    ]

    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.minimumWidth: 320
    implicitHeight: 250
    title: panel.target === "cpu" ? I18n.t("fan.cpu") : I18n.t("fan.gpu")
    leadingIcon: panel.target === "cpu" ? "cyclone" : "air"
    subtitle: I18n.t("fan.subtitle")
    colBackground: Appearance.colors.colSurfaceContainerLow

    Row {
        Layout.fillWidth: true
        spacing: 8

        Repeater {
            model: panel.modes
            delegate: SegmentedButton {
                required property var modelData
                required property int index
                // Keep segment widths equal for consistent alignment.
                width: (parent.width - 2 * parent.spacing) / panel.modes.length
                height: 44
                leftmost: index === 0
                rightmost: index === panel.modes.length - 1
                showCheckWhenSelected: false
                buttonIcon: modelData.icon
                buttonText: modelData.label
                toggled: panel.selectedMode === modelData.key
                onClicked: {
                    panel.selectedMode = modelData.key;
                    if (modelData.key !== "custom")
                        panel.modeSelected(modelData.key, panel.pwmValue);
                }
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.topMargin: 2
        spacing: 12
        enabled: panel.selectedMode === "custom"
        opacity: panel.selectedMode === "custom" ? 1 : 0.5

        StyledText {
            text: "PWM"
            color: Appearance.colors.colOnSurfaceVariant
            font.pixelSize: 13
        }

        StyledSlider {
            Layout.fillWidth: true
            enabled: panel.selectedMode === "custom"
            from: 0
            to: 255
            value: panel.pwmValue
            onMoved: panel.pwmValue = Math.round(value)
        }

        StyledText {
            Layout.preferredWidth: 34
            horizontalAlignment: Text.AlignRight
            text: panel.pwmValue
            color: panel.accent
            font.pixelSize: 14
        }
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 10

        MaterialButton {
            id: applyCustom
            variant: MaterialButton.Variant.Filled
            buttonText: I18n.t("action.apply")
            buttonIcon: "check"
            enabled: panel.selectedMode === "custom"
            // Preserve the accent when disabled; opacity provides the fade.
            buttonColor: down ? Appearance.colors.colPrimaryActive : hovered ? Appearance.colors.colPrimaryHover : Appearance.colors.colPrimary
            onClicked: panel.modeSelected("custom", panel.pwmValue)
        }

        Item { Layout.fillWidth: true }
    }
}
