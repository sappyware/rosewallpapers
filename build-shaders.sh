#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
shopt -s nullglob
for f in shaders/*.frag; do
    qsb --qt6 "$f" -o "$f.qsb"
done
echo "built $(ls shaders/*.qsb | wc -l) shader(s)"
