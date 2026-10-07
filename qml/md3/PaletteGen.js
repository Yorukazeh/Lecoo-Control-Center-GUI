.pragma library

.import "MaterialColorUtilities.js" as Mcu

// Generate the application's Material color roles.

// Select the color specification.
var SPEC_VERSION = "2025"

// Use a mid-range seed tone for scheme construction.
var SEED_TONE = 40

/** Generate the contrasting unfilled slider-track color. */
var TRACK_TONE = { "light": 85, "dark": 30 }

// Define the color roles consumed by the UI.
var ROLES = [
    "primaryPaletteKeyColor", "secondaryPaletteKeyColor", "tertiaryPaletteKeyColor",
    "neutralPaletteKeyColor", "neutralVariantPaletteKeyColor",
    "primary", "onPrimary", "primaryContainer", "onPrimaryContainer", "inversePrimary",
    "primaryFixed", "primaryFixedDim", "onPrimaryFixed", "onPrimaryFixedVariant",
    "secondary", "onSecondary", "secondaryContainer", "onSecondaryContainer",
    "secondaryFixed", "secondaryFixedDim", "onSecondaryFixed", "onSecondaryFixedVariant",
    "tertiary", "onTertiary", "tertiaryContainer", "onTertiaryContainer",
    "tertiaryFixed", "tertiaryFixedDim", "onTertiaryFixed", "onTertiaryFixedVariant",
    "error", "onError", "errorContainer", "onErrorContainer",
    "background", "onBackground",
    "surface", "onSurface", "surfaceDim", "surfaceBright",
    "surfaceContainerLowest", "surfaceContainerLow", "surfaceContainer",
    "surfaceContainerHigh", "surfaceContainerHighest", "surfaceVariant", "onSurfaceVariant",
    "inverseSurface", "inverseOnSurface",
    "outline", "outlineVariant", "surfaceTint", "scrim", "shadow"
]

/** Keep palette variant IDs stable for persisted settings. */
var VARIANTS = [
    { "id": "tonalSpot",  "name": "Tonal spot",  "scheme": "SchemeTonalSpot" },
    { "id": "vibrant",    "name": "Vibrant",     "scheme": "SchemeVibrant" },
    { "id": "content",    "name": "Content",     "scheme": "SchemeContent" },
    { "id": "expressive", "name": "Expressive",  "scheme": "SchemeExpressive" },
    { "id": "rainbow",    "name": "Rainbow",     "scheme": "SchemeRainbow" },
    { "id": "fruitSalad", "name": "Fruit salad", "scheme": "SchemeFruitSalad" },
    { "id": "monochrome", "name": "Monochrome",  "scheme": "SchemeMonochrome" },
    { "id": "neutral",    "name": "Neutral",     "scheme": "SchemeNeutral" },
    { "id": "fidelity",   "name": "Fidelity",    "scheme": "SchemeFidelity" }
]

// --- variant lookup ------------------------------------------------------------

function variantList() {
    return VARIANTS;
}

function variantById(id) {
    for (let i = 0; i < VARIANTS.length; ++i) {
        if (VARIANTS[i].id === id) {
            return VARIANTS[i];
        }
    }
    return VARIANTS[0];
}

/** Cache shared schemes while the hue changes. */
var SCHEMES = {};
var SCHEME_LIMIT = 64;

function schemeFor(hue, chroma, dark, variantId) {
    const key = (((hue % 360) + 360) % 360) + "|" + chroma + "|" + (dark ? 1 : 0) + "|" + variantId;
    let scheme = SCHEMES[key];
    if (scheme === undefined) {
        const v = variantById(variantId);
        const seed = Mcu.Hct.from(((hue % 360) + 360) % 360, Math.max(0, chroma), SEED_TONE);
        scheme = new Mcu[v.scheme](seed, dark, 0, SPEC_VERSION);
        const keys = Object.keys(SCHEMES);
        if (keys.length >= SCHEME_LIMIT) {
            delete SCHEMES[keys[0]];
        }
        SCHEMES[key] = scheme;
    }
    return scheme;
}

/** Cache stateless dynamic-color descriptors between palette updates. */
var DYN = [];

function dynColor(role) {
    let cached = DYN[role];
    if (cached === undefined) {
        cached = Mcu.MaterialDynamicColors[role];
        DYN[role] = cached;
    }
    return cached;
}

/** Cache generated palettes with a bounded number of hue entries. */
var CACHE = {};
var CACHE_LIMIT = 128;


/** Return all generated roles as hexadecimal colors. */
function generate(hue, chroma, dark, variantId) {
    const key = (((hue % 360) + 360) % 360) + "|" + chroma + "|" + (dark ? 1 : 0) + "|" + variantId;
    const cached = CACHE[key];
    if (cached !== undefined) {
        return cached;
    }
    const scheme = schemeFor(hue, chroma, dark, variantId);
    const out = {};
    for (let i = 0; i < ROLES.length; ++i) {
        const role = ROLES[i];
        out[role] = Mcu.hexFromArgb(dynColor(role).getArgb(scheme));
    }
    out.trackContainer = Mcu.hexFromArgb(
        scheme.secondaryPalette.tone(dark ? TRACK_TONE.dark : TRACK_TONE.light));
    const cachedKeys = Object.keys(CACHE);
    if (cachedKeys.length >= CACHE_LIMIT) {
        delete CACHE[cachedKeys[0]];
    }
    CACHE[key] = out;
    return out;
}

/** Return the three accent colors shown by a variant chip. */
function variantDots(hue, chroma, dark, variantId) {
    const scheme = schemeFor(hue, chroma, dark, variantId);
    const roles = ["primary", "secondary", "tertiary"];
    const dots = [];
    for (let i = 0; i < roles.length; ++i) {
        dots.push(Mcu.hexFromArgb(dynColor(roles[i]).getArgb(scheme)));
    }
    return dots;
}

/** Return a neutral-palette color at the requested tone. */
function neutralTone(hue, chroma, dark, variantId, tone) {
    return Mcu.hexFromArgb(schemeFor(hue, chroma, dark, variantId).neutralPalette.tone(tone));
}
/** Return the primary color used by the live seed preview. */
