#!/usr/bin/env bash
set -euo pipefail

PREFIX="${PREFIX:-$HOME/.local}"

BIN="$PREFIX/bin/pipip"
APP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/pipip"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/pipip"

rm -f "$BIN"
rm -rf "$APP_DIR"
rm -rf "$CONFIG_DIR"

echo "Removed pipip"