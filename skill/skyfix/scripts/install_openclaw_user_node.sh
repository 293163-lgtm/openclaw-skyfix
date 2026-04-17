#!/usr/bin/env bash
set -euo pipefail

NODE_VERSION="22.22.0"
OPENCLAW_VERSION="latest"
ARCH="auto"
INSTALL_OPENCLAW=1
LOCAL_ROOT="${HOME}/.local"
NODE_LINK="${LOCAL_ROOT}/node"
NPM_CACHE="${LOCAL_ROOT}/npm-cache"
UPDATE_ZPROFILE=1

usage() {
  cat <<'EOF'
Usage: install_openclaw_user_node.sh [options]

Install Node.js into ~/.local/node and optionally install OpenClaw globally
inside that user-local prefix. Designed for macOS hosts where Homebrew is
unavailable, undesirable, or too fragile.

Options:
  --node-version <ver>        Node version (default: 22.22.0)
  --openclaw-version <ver>    OpenClaw npm version/tag (default: latest)
  --arch <x64|arm64|auto>     Node archive architecture (default: auto)
  --skip-openclaw             Install Node only
  --local-root <path>         Root install dir (default: ~/.local)
  --node-link <path>          Symlink path for active node (default: ~/.local/node)
  --npm-cache <path>          npm cache path (default: ~/.local/npm-cache)
  --no-zprofile               Do not append PATH export to ~/.zprofile
  -h, --help                  Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --node-version) NODE_VERSION="$2"; shift 2 ;;
    --openclaw-version) OPENCLAW_VERSION="$2"; shift 2 ;;
    --arch) ARCH="$2"; shift 2 ;;
    --skip-openclaw) INSTALL_OPENCLAW=0; shift ;;
    --local-root) LOCAL_ROOT="$2"; shift 2 ;;
    --node-link) NODE_LINK="$2"; shift 2 ;;
    --npm-cache) NPM_CACHE="$2"; shift 2 ;;
    --no-zprofile) UPDATE_ZPROFILE=0; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 2 ;;
  esac
done

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script currently supports macOS/Darwin only." >&2
  exit 1
fi

if [[ "$ARCH" == "auto" ]]; then
  case "$(uname -m)" in
    x86_64) ARCH="x64" ;;
    arm64) ARCH="arm64" ;;
    *) echo "Unsupported machine architecture: $(uname -m)" >&2; exit 1 ;;
  esac
fi

INSTALL_DIR="${LOCAL_ROOT}/node-v${NODE_VERSION}-darwin-${ARCH}"
ARCHIVE_BASENAME="node-v${NODE_VERSION}-darwin-${ARCH}"
ARCHIVE_URL="https://nodejs.org/dist/v${NODE_VERSION}/${ARCHIVE_BASENAME}.tar.gz"
TMP_DIR="$(mktemp -d)"
ARCHIVE_PATH="${TMP_DIR}/${ARCHIVE_BASENAME}.tar.gz"
ZPROFILE_PATH="${HOME}/.zprofile"
PATH_EXPORT=""

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

mkdir -p "$LOCAL_ROOT" "$NPM_CACHE"

NODE_BIN="${NODE_LINK}/bin"
PATH_EXPORT="export PATH=\"${NODE_BIN}:\$PATH\""

echo "==> Downloading Node.js ${NODE_VERSION} (${ARCH})"
curl -fL "$ARCHIVE_URL" -o "$ARCHIVE_PATH"

echo "==> Extracting to $LOCAL_ROOT"
rm -rf "$INSTALL_DIR"
tar -xzf "$ARCHIVE_PATH" -C "$LOCAL_ROOT"
ln -sfn "$INSTALL_DIR" "$NODE_LINK"

export PATH="${NODE_LINK}/bin:${PATH}"
export npm_config_cache="$NPM_CACHE"
export npm_config_prefix="$NODE_LINK"

if [[ "$UPDATE_ZPROFILE" -eq 1 ]]; then
  touch "$ZPROFILE_PATH"
  if ! grep -Fq "$PATH_EXPORT" "$ZPROFILE_PATH"; then
    printf '\n# skyfix user-local Node\n%s\n' "$PATH_EXPORT" >> "$ZPROFILE_PATH"
    echo "==> Added PATH export to $ZPROFILE_PATH"
  fi
fi

echo "==> Node installed"
node --version
npm --version

if [[ "$INSTALL_OPENCLAW" -eq 1 ]]; then
  echo "==> Installing OpenClaw@${OPENCLAW_VERSION}"
  npm install -g "openclaw@${OPENCLAW_VERSION}"
  echo "==> OpenClaw installed"
  openclaw --version
fi

cat <<EOF

Install summary
- local root: $LOCAL_ROOT
- active node link: $NODE_LINK
- node version: $(node --version)
- npm version: $(npm --version)
- npm cache: $NPM_CACHE
- zprofile updated: $UPDATE_ZPROFILE
- openclaw installed: $INSTALL_OPENCLAW
EOF
