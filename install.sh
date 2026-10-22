#!/bin/bash
set -e

SOURCE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEST="$HOME/.local/share/rosewallpapers"

if ! command -v qs >/dev/null 2>&1; then
    printf 'error: quickshell is not installed.\n'
    exit 1
fi

if [ -f "$SOURCE/build-shaders.sh" ]; then
    printf 'building shaders...\n'
    bash "$SOURCE/build-shaders.sh"
fi

if [ -d "$DEST" ]; then
    BACKUP="${DEST}.backup.$(date +%Y%m%d%H%M%S)"
    mv "$DEST" "$BACKUP"
    printf 'backup created: %s\n' "$BACKUP"
fi

mkdir -p "$DEST"
cp -a "$SOURCE/." "$DEST/"
rm -f "$DEST/install.sh"

printf '\nrosewallpapers installed successfully.\n'
printf 'launch with:\n'
printf '  qs -p %s/shell.qml\n' "$DEST"