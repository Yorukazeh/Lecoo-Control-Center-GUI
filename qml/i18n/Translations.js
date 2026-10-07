.pragma library

.import "translations/zh_CN.js" as ZhCN
.import "translations/en_US.js" as EnUS

var languages = [
    { code: "zh_CN", label: "简体中文" },
    { code: "en_US", label: "English" }
];

var strings = {
    "zh_CN": ZhCN.strings,
    "en_US": EnUS.strings
};

function lookup(code, key) {
    var current = strings[code];
    if (current && current[key] !== undefined)
        return current[key];
    var fallback = strings["en_US"];
    if (fallback && fallback[key] !== undefined)
        return fallback[key];
    return key;
}
