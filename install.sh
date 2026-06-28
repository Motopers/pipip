#!/usr/bin/env bash
set -euo pipefail

PREFIX="${PREFIX:-$HOME/.local}"
BIN_DIR="$PREFIX/bin"

APP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/pipip"
DB="$APP_DIR/GeoLite2-City.mmdb"
DB_URL="https://github.com/P3TERX/GeoLite.mmdb/raw/download/GeoLite2-City.mmdb"

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/pipip"
CONFIG="$CONFIG_DIR/pipip.conf"

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

have() {
  command -v "$1" >/dev/null 2>&1
}

check_deps() {
  local missing=()

  for cmd in curl stun mmdblookup timeout getopt; do
    have "$cmd" || missing+=("$cmd")
  done

  if have getopt; then
    local getopt_status
    if getopt --test >/dev/null 2>&1; then
      missing+=("GNU getopt")
    else
      getopt_status="$?"
      [ "$getopt_status" -eq 4 ] || missing+=("GNU getopt")
    fi
  fi

  if ((${#missing[@]})); then
    printf 'Missing dependencies: %s\n' "${missing[*]}" >&2
    printf 'Install them manually. See README.md.\n' >&2
    exit 1
  fi
}

install_config() {
  mkdir -p "$CONFIG_DIR"
  [ -f "$CONFIG" ] || install -m 644 "$REPO_DIR/pipip.conf" "$CONFIG"
}

install_db() {
  mkdir -p "$APP_DIR"

  local tmp="$DB.tmp"
  rm -f "$tmp"

  if ! curl -fL \
    --retry 3 \
    --retry-delay 1 \
    --connect-timeout 15 \
    "$DB_URL" \
    -o "$tmp"; then
    rm -f "$tmp"
    echo "Error: failed to download GeoLite2 City database" >&2
    exit 1
  fi

  if ! mmdblookup --file "$tmp" --ip 8.8.8.8 country iso_code >/dev/null 2>&1; then
    rm -f "$tmp"
    echo "Error: downloaded GeoLite2 City database is invalid" >&2
    exit 1
  fi

  chmod 644 "$tmp"
  mv "$tmp" "$DB"
}

check_deps

printf 'Installing pipip...\n'
mkdir -p "$BIN_DIR"
install -m 755 "$REPO_DIR/pipip" "$BIN_DIR/pipip"

printf 'Installing config...\n'
install_config

printf 'Downloading GeoLite2 City database...\n'
install_db

cat <<EOF_DONE

Done.

Installed:
  $BIN_DIR/pipip

Config:
  $CONFIG

Try:
  pipip
  pipip --city
  pipip --region
  pipip --lang ru
  pipip --separator '·'

EOF_DONE
