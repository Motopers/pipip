# pipip — Tiny STUN-based public IP checker

```text
  •  •
┏┓┓┏┓┓┏┓
┣┛┗┣┛┗┣┛
┛  ┛  ┛
```

`pipip` gets your external IP through STUN and resolves country, region, city, and approximate coordinates from a local GeoLite2 City database.

## Dependencies

`install.sh` checks dependencies but does not install system packages.

```bash
# Ubuntu / Debian
sudo apt install util-linux stun-client mmdb-bin coreutils curl

# Arch / Manjaro
sudo pacman -S util-linux stun libmaxminddb coreutils curl

# Fedora
sudo dnf install util-linux stun libmaxminddb coreutils curl
```

## Install

```bash
git clone https://github.com/motopers/pipip.git
cd pipip
./install.sh
```

Running `./install.sh` again updates the executable and database. An existing config is left unchanged.

## Usage

```bash
pipip                            # Helsinki, Finland | 203.0.113.42
pipip -i                         # 203.0.113.42
pipip -c                         # Finland
pipip -g                         # Helsinki
pipip -r                         # Uusimaa
pipip -p                         # (60.1695, 24.9354)
pipip -grc                       # Helsinki, Uusimaa, Finland
pipip -ci                        # Finland | 203.0.113.42
pipip -f                         # 🇫🇮
pipip -t                         # FI
pipip -ft                        # 🇫🇮 FI
pipip -fgci                      # 🇫🇮 Helsinki, Finland | 203.0.113.42
pipip -gci --separator '·'       # Helsinki, Finland · 203.0.113.42
pipip -grc --lang ru             # Хельсинки, Уусимаа, Финляндия
```

## Options

| Option              | Description                              |
| ------------------- | ---------------------------------------- |
| `-i, --ip`          | Print IP                                 |
| `-c, --country`     | Print country                            |
| `-r, --region`      | Print region, state, or province         |
| `-g, --city`        | Print city                               |
| `-p, --coordinates` | Print approximate latitude and longitude |
| `-f, --flag`        | Print emoji flag                         |
| `-t, --text-flag`   | Print text flag                          |
| `--separator VALUE` | Use a custom separator before IP         |
| `--lang VALUE`      | Print GeoIP names in another language    |
| `-h, --help`        | Print help                               |
| `-v, --version`     | Print version                            |

The default separator is `|`. Pass an empty value to remove it:

```bash
pipip -ci --separator ''
```

The default language is `en`. When a requested translation is unavailable, `pipip` falls back to English:

```bash
pipip -grc --lang ru
pipip -grc --lang de
pipip -grc --lang pt-BR
```

Coordinates are approximate IP-geolocation coordinates, not the physical position of the device.

If no STUN server returns an external IP, `pipip` prints:

```text
❌ pipip
```

## Config

```text
~/.config/pipip/pipip.conf
```

```bash
TIMEOUT_SEC="0.8"
GEOIP_DB="${XDG_DATA_HOME:-$HOME/.local/share}/pipip/GeoLite2-City.mmdb"

STUN_SERVERS=(
  "stun.cloudflare.com:3478"
  "stun.l.google.com:19302"
  "stun1.l.google.com:19302"
  "stun.stunprotocol.org:3478"
  "stun.nextcloud.com:3478"
  "stun.sipnet.com:3478"
)
```

## Files

| Path                          | Description          |
| ----------------------------- | -------------------- |
| `~/.local/bin/pipip`          | Main executable      |
| `~/.config/pipip/pipip.conf`  | User config          |
| `~/.local/share/pipip/*.mmdb` | Local GeoIP database |

## Uninstall

```bash
./uninstall.sh
```

## GeoIP data

This product includes GeoLite Data created by MaxMind, available from [maxmind.com](https://www.maxmind.com).

The installer downloads the database through the public [P3TERX/GeoLite.mmdb](https://github.com/P3TERX/GeoLite.mmdb) mirror. GeoLite data is subject to the MaxMind GeoLite End User License Agreement and the Creative Commons Attribution-ShareAlike 4.0 International License.
