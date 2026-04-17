#!/usr/bin/env bash
set -euo pipefail

PORT="18789"
FORCE_INSTALL=1
WAIT_SECONDS=3
RUN_STATUS=1
RUN_VALIDATE=1

usage() {
  cat <<'EOF'
Usage: repair_gateway_launchagent.sh [options]

Normalize and repair the local OpenClaw gateway / LaunchAgent state.

Options:
  --port <port>         Gateway port (default: 18789)
  --no-force-install    Use plain install instead of install --force
  --no-validate         Skip `openclaw config validate`
  --no-status           Skip final `openclaw gateway status`
  --wait <seconds>      Seconds to wait after restart (default: 3)
  -h, --help            Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --port) PORT="$2"; shift 2 ;;
    --no-force-install) FORCE_INSTALL=0; shift ;;
    --no-validate) RUN_VALIDATE=0; shift ;;
    --no-status) RUN_STATUS=0; shift ;;
    --wait) WAIT_SECONDS="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 2 ;;
  esac
done

command -v openclaw >/dev/null 2>&1 || { echo "openclaw not found in PATH" >&2; exit 1; }

if [[ "$RUN_VALIDATE" -eq 1 ]]; then
  echo "==> Validating config"
  openclaw config validate
fi

echo "==> Stopping gateway if running"
openclaw gateway stop || true

if [[ "$FORCE_INSTALL" -eq 1 ]]; then
  echo "==> Reinstalling LaunchAgent with --force"
  OPENCLAW_GATEWAY_PORT="$PORT" openclaw gateway install --force
else
  echo "==> Installing LaunchAgent"
  OPENCLAW_GATEWAY_PORT="$PORT" openclaw gateway install
fi

echo "==> Restarting LaunchAgent"
openclaw gateway restart
sleep "$WAIT_SECONDS"

if [[ "$RUN_STATUS" -eq 1 ]]; then
  echo "==> Gateway status"
  openclaw gateway status
fi

echo "==> Listener probe"
lsof -nP -iTCP:"$PORT" -sTCP:LISTEN || true
