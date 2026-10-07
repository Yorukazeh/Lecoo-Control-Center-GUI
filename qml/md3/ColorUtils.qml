pragma Singleton
import QtQml
import io.lecooctrl.gui

// Shared color helpers.
QtObject {
    id: root

    // Mix two colors by percentage.
    function mix(color1, color2, percentage = 0.5) {
        const c1 = Qt.color(color1);
        const c2 = Qt.color(color2);
        return Qt.rgba(percentage * c1.r + (1 - percentage) * c2.r, percentage * c1.g + (1 - percentage) * c2.g, percentage * c1.b + (1 - percentage) * c2.b, percentage * c1.a + (1 - percentage) * c2.a);
    }

    // Reduce a color's alpha by percentage.
    function transparentize(color, percentage = 1) {
        const c = Qt.color(color);
        return Qt.rgba(c.r, c.g, c.b, c.a * (1 - percentage));
    }

    function applyAlpha(color, alpha) {
        const c = Qt.color(color);
        return Qt.rgba(c.r, c.g, c.b, Math.max(0, Math.min(1, alpha)));
    }

    function isDark(color) {
        return Qt.color(color).hslLightness < 0.5;
    }

    /** A readable foreground (black/white) for the given background. */
    function contrastingText(color) {
        return isDark(color) ? "#ffffff" : "#000000";
    }

    /** Rotate the hue of a color by `degrees`. */
    function rotateHue(color, degrees) {
        const c = Qt.color(color);
        const h = (c.hslHue + degrees / 360) % 1.0;
        return Qt.hsla(h < 0 ? h + 1 : h, c.hslSaturation, c.hslLightness, c.a);
    }

    /** Set absolute HSL lightness, keeping hue/saturation/alpha. */
    function withLightness(color, lightness) {
        const c = Qt.color(color);
        return Qt.hsla(c.hslHue, c.hslSaturation, lightness, c.a);
    }
}
