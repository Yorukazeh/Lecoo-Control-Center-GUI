pragma Singleton
import QtQuick
import io.lecooctrl.gui
import "Translations.js" as Strings

/** Resolve translated strings for the selected language. */
QtObject {
    id: root

    /** Active language code. Empty falls back to English. */
    property string language: ""

    /** Available languages: [{ code, label }, ...]. */
    readonly property var availableLanguages: Strings.languages

    /** Translates `key`, substituting `{0}`, `{1}`, ... with extra arguments. */
    function t(key) {
        var value = Strings.lookup(root.language, key)
        for (var i = 1; i < arguments.length; ++i)
            value = value.replace("{" + (i - 1) + "}", arguments[i])
        return value
    }

    /** Localised display name for one of `Appearance.themes`. */
    function themeName(name) {
        return root.t("theme." + String(name).toLowerCase())
    }
}
