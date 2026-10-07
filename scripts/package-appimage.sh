#!/usr/bin/env bash
# Build a portable AppImage.
# Usage: package-appimage.sh [--no-build] [--keep-appdir] [--output PATH].

set -euo pipefail

APP_ID="io.lecooctrl.gui"
APP_NAME="Lecoo Control Center"
BIN_NAME="Lecoo-Control-Center-GUI"

LINUXDEPLOY_URL="https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage"
LINUXDEPLOY_QT_URL="https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage"
APPIMAGETOOL_URL="https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"

usage() {
    sed -n '3,33p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
}

no_build=0
keep_appdir=0
output=""

while [ $# -gt 0 ]; do
    case "$1" in
        --no-build)    no_build=1 ;;
        --keep-appdir) keep_appdir=1 ;;
        --output)      output="${2:-}"; [ -n "$output" ] || { echo "error: --output needs a path" >&2; exit 2; }; shift ;;
        -h|--help)     usage; exit 0 ;;
        *)             echo "error: unknown option '$1'" >&2; echo >&2; usage >&2; exit 2 ;;
    esac
    shift
done

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo"

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/lecoo-appimage-tools"
appdir="$repo/target/appimage/AppDir"
output="${output:-$repo/target/release/Lecoo_Control_Center-x86_64.AppImage}"

log() { printf '==> %s\n' "$*"; }
die() { printf 'error: %s\n' "$*" >&2; exit 1; }

# Build the application.
if [ "$no_build" -eq 0 ]; then
    command -v cargo >/dev/null 2>&1 || die "cargo not found on PATH"
    log "cargo build --release"
    cargo build --release
fi

exe="$repo/target/release/$BIN_NAME"
[ -f "$exe" ] || die "executable not found: $exe (run without --no-build first)"

# Download and configure the AppImage deployment tools.
export APPIMAGE_EXTRACT_AND_RUN=1
export PATH="$cache_dir:$PATH"

fetch_tool() {
    # Download a tool atomically into the cache.
    local target="$1" url="$2" tmp downloader
    [ -x "$cache_dir/$target" ] && return 0
    mkdir -p "$cache_dir"
    tmp="$cache_dir/$target.part"
    log "downloading $target (this can take a while)" >&2
    if downloader="$(command -v aria2-next || command -v aria2c)"; then
        # Resume downloads with multiple connections when available.
        "$downloader" --continue=true --file-allocation=none \
            --auto-file-renaming=false --allow-overwrite=true \
            --summary-interval=0 --console-log-level=warn \
            -x 8 -s 8 -k 1M -d "$cache_dir" -o "$target.part" "$url" \
            || { rm -f "$tmp" "$tmp.aria2"; die "download failed: $url"; }
    elif downloader="$(command -v curl)"; then
        curl -fL -C - --retry 5 --retry-delay 3 -o "$tmp" "$url" \
            || { rm -f "$tmp"; die "download failed: $url"; }
    elif downloader="$(command -v wget)"; then
        wget -c -O "$tmp" "$url" || { rm -f "$tmp"; die "download failed: $url"; }
    else
        die "no downloader found; install aria2-next, curl or wget"
    fi
    chmod +x "$tmp"
    mv -f "$tmp" "$cache_dir/$target"
}

fetch_tool linuxdeploy            "$LINUXDEPLOY_URL"
fetch_tool linuxdeploy-plugin-qt  "$LINUXDEPLOY_QT_URL"
fetch_tool appimagetool           "$APPIMAGETOOL_URL"
hash -r 2>/dev/null || true

# The Qt plugin locates the Qt installation through qmake.
if [ -n "${QMAKE:-}" ]; then
    qmake_bin="$QMAKE"
else
    qmake_bin="$(command -v qmake6 || command -v qmake || true)"
fi
[ -n "$qmake_bin" ] || die "qmake not found; install the Qt 6 base tools or set QMAKE=<path>"
log "using qmake: $qmake_bin"

# Recreate the AppDir from scratch.
log "assembling AppDir at $appdir"
rm -rf "$appdir"
install -Dm755 "$exe" "$appdir/usr/bin/$BIN_NAME"

install -Dm644 "$repo/assets/io.lecooctrl.gui.desktop" \
    "$appdir/usr/share/applications/$APP_ID.desktop"

# Generate the icon sizes required by the hicolor hierarchy.
icon_src="$repo/assets/app-icon.png"
magick_bin="$(command -v magick || command -v convert || true)"
if [ -n "$magick_bin" ]; then
    for size in 512 256 128 64 48; do
        install -d "$appdir/usr/share/icons/hicolor/${size}x${size}/apps"
        "$magick_bin" "$icon_src" -resize "${size}x${size}" \
            "$appdir/usr/share/icons/hicolor/${size}x${size}/apps/$APP_ID.png"
    done
else
    # Validate the source icon when ImageMagick is unavailable.
    icon_size="$(od -An -tu4 -j16 -N8 --endian=big "$icon_src" | awk '{ print $1 }')"
    case "$icon_size" in
        8|16|20|22|24|28|32|36|42|48|64|72|96|128|160|192|256|384|480|512) ;;
        *) die "$icon_src is ${icon_size}px wide, which is not a resolution the icon spec allows; install ImageMagick to rescale it" ;;
    esac
    install -Dm644 "$icon_src" "$appdir/usr/share/icons/hicolor/${icon_size}x${icon_size}/apps/$APP_ID.png"
fi

# Copy the licenses and third-party notices into the image.
install -Dm644 "$repo/LICENSE" "$appdir/usr/share/doc/$BIN_NAME/LICENSE"
for extra in "$repo/THIRD-PARTY-NOTICES.md"; do
    [ -f "$extra" ] && install -Dm644 "$extra" "$appdir/usr/share/doc/$BIN_NAME/$(basename "$extra")"
done
for f in "$repo"/assets/fonts/*.txt; do
    [ -f "$f" ] && install -Dm644 "$f" "$appdir/usr/share/doc/$BIN_NAME/$(basename "$f")"
done

# Bundle the executable, Qt runtime, plugins, QML modules, and resources.
export NO_STRIP=1

qt_plugins="$("$qmake_bin" -query QT_INSTALL_PLUGINS 2>/dev/null || true)"
ld_excludes=()
if [ -n "$qt_plugins" ] && [ -d "$qt_plugins" ]; then
    log "scanning $qt_plugins for plugins with unresolved dependencies"
    while IFS= read -r so; do
        missing="$(ldd "$so" 2>/dev/null | awk '/not found/{print $1}' | tr '\n' ' ')"
        if [ -n "$missing" ]; then
            ld_excludes+=(--exclude-library "$(basename "$so")")
            log "  excluding $(basename "$so")  (missing: ${missing% })"
        fi
    done < <(find "$qt_plugins" -name '*.so' 2>/dev/null)
    if [ "${#ld_excludes[@]}" -eq 0 ]; then
        log "  none found"
    fi
fi

log "running linuxdeploy"
linuxdeploy \
    --appdir "$appdir" \
    --executable "$appdir/usr/bin/$BIN_NAME" \
    --desktop-file "$appdir/usr/share/applications/$APP_ID.desktop" \
    --icon-file "$appdir/usr/share/icons/hicolor/512x512/apps/$APP_ID.png"

log "running linuxdeploy-plugin-qt (${#ld_excludes[@]} plugin(s) excluded)"
QML_SOURCES_PATHS="$repo/qml" \
QMAKE="$qmake_bin" \
linuxdeploy-plugin-qt --appdir "$appdir" ${ld_excludes[@]+"${ld_excludes[@]}"}

log "  deployed: $(find "$appdir/usr" -name '*.so*' | wc -l) libraries and $(find "$appdir/usr/qml" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l) QML modules"

# Add the Wayland and offscreen plugins that the Qt deploy plugin may omit.
extra_plugins=()
install_plugin() {
    src="$1"
    dst="$2"
    if [ ! -f "$src" ]; then
        return 0
    fi
    if ldd "$src" 2>/dev/null | grep -q 'not found'; then
        log "  skipping $(basename "$src") (unresolved dependencies)"
        return 0
    fi
    install -Dm755 "$src" "$dst"
    extra_plugins+=(--deploy-deps-only "$dst")
}
install_plugin_dir() {
    src_dir="$1"
    dst_dir="$2"
    if [ ! -d "$src_dir" ]; then
        return 0
    fi
    for so in "$src_dir"/*.so; do
        [ -e "$so" ] || continue
        install_plugin "$so" "$dst_dir/$(basename "$so")"
    done
}

if [ -n "$qt_plugins" ] && [ ! -d "$qt_plugins/wayland-shell-integration" ]; then
    log "  warn $qt_plugins/wayland-shell-integration is missing; the bundle will have no Wayland support"
fi

for plugin in libqwayland.so libqoffscreen.so; do
    install_plugin "$qt_plugins/platforms/$plugin" "$appdir/usr/plugins/platforms/$plugin"
done
install_plugin_dir "$qt_plugins/wayland-shell-integration" "$appdir/usr/plugins/wayland-shell-integration"
install_plugin_dir "$qt_plugins/wayland-decoration-client" "$appdir/usr/plugins/wayland-decoration-client"
install_plugin_dir "$qt_plugins/wayland-graphics-integration-client" "$appdir/usr/plugins/wayland-graphics-integration-client"

if [ "${#extra_plugins[@]}" -gt 0 ]; then
    linuxdeploy --appdir "$appdir" ${extra_plugins[@]+"${extra_plugins[@]}"}
fi

# Remove plugins with unresolved dependencies.
while IFS= read -r so; do
    if ldd "$so" 2>/dev/null | grep -q 'not found'; then
        log "  dropping $(realpath --relative-to="$appdir" "$so") (unresolved dependencies)"
        rm -f "$so"
    fi
done < <(find "$appdir/usr/plugins" "$appdir/usr/qml" -name '*.so' 2>/dev/null)

# Verify the required bundle files.
check_present() {
    [ -e "$appdir/$1" ] || die "bundling did not produce $1"
    log "  ok  $1"
}
log "verifying bundle contents"
check_present "usr/lib/libQt6Core.so.6"
check_present "usr/lib/libQt6Gui.so.6"
check_present "usr/lib/libQt6Qml.so.6"
check_present "usr/lib/libQt6QuickControls2.so.6"
check_present "usr/plugins/platforms/libqxcb.so"
check_present "usr/qml/QtQuick/Controls/Basic"
check_present "usr/qml/Qt5Compat/GraphicalEffects"
# Verify optional platform plugins when they are installed.
for plugin in libqwayland.so libqoffscreen.so; do
    if [ -f "$qt_plugins/platforms/$plugin" ]; then
        check_present "usr/plugins/platforms/$plugin"
    fi
done
if [ -d "$qt_plugins/wayland-shell-integration" ]; then
    check_present "usr/plugins/wayland-shell-integration/libxdg-shell.so"
fi

# Pack the AppImage.
log "running appimagetool"
mkdir -p "$(dirname "$output")"
ARCH=x86_64 appimagetool "$appdir" "$output"

# Run a headless smoke test for the finished AppImage.
log "smoke testing $output"
smoke_log="$(mktemp)"
set +e
timeout 8 env QT_QPA_PLATFORM=offscreen "$output" >"$smoke_log" 2>&1
smoke_rc=$?
set -e
if [ "$smoke_rc" -ne 124 ]; then
    cat "$smoke_log" >&2
    rm -f "$smoke_log"
    die "the AppImage exited immediately (status $smoke_rc) — see the output above"
fi
if grep -qiE "error while loading shared libraries|cannot open shared object|module .* is not installed|is not a type" "$smoke_log"; then
    cat "$smoke_log" >&2
    rm -f "$smoke_log"
    die "the AppImage started but reported missing libraries or QML modules"
fi
if [ -s "$smoke_log" ]; then
    log "  (startup log, no errors detected)"
    sed 's/^/      /' "$smoke_log"
fi
rm -f "$smoke_log"

if [ "$keep_appdir" -eq 0 ]; then
    rm -rf "$appdir"
fi

log "done: $output ($(du -h "$output" | cut -f1))"
