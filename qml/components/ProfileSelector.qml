import QtQuick
import QtQuick.Layouts
import io.lecooctrl.gui

/** Select one of the three power profiles. */
RowLayout {
    id: root

    property string selected: "default"
    readonly property var profiles: [
        { key: "silent", label: I18n.t("profile.silent"), icon: "energy_savings_leaf" },
        { key: "default", label: I18n.t("profile.default"), icon: "balance" },
        { key: "perf", label: I18n.t("profile.perf"), icon: "rocket_launch" }
    ]

    signal profileChosen(string key)

    Layout.fillWidth: true
    // Allow the selector to shrink inside its host card.
    Layout.minimumWidth: 0
    spacing: 10

    Repeater {
        model: root.profiles
        delegate: SegmentedButton {
            required property var modelData
            required property int index
            Layout.fillWidth: true
            Layout.minimumWidth: 0
            implicitHeight: 44
            leftmost: index === 0
            rightmost: index === root.profiles.length - 1
            showCheckWhenSelected: false
            buttonIcon: modelData.icon
            buttonText: modelData.label
            toggled: root.selected === modelData.key
            onClicked: root.profileChosen(modelData.key)
        }
    }
}
