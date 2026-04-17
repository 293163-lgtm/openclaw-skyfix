#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REQUIRED_RUNTIME_FILES=(
  "$BASE_DIR/SKILL.md"
  "$BASE_DIR/references/cn.md"
  "$BASE_DIR/references/beginner-guide-cn.html"
  "$BASE_DIR/references/architecture-prd.md"
  "$BASE_DIR/references/module-map.md"
  "$BASE_DIR/references/vendor-strategy.md"
  "$BASE_DIR/references/install-lane.md"
  "$BASE_DIR/references/upgrade-repair-lane.md"
  "$BASE_DIR/references/permissions-normalization.md"
  "$BASE_DIR/references/desktop-shortcuts.md"
  "$BASE_DIR/references/platform-integrations.md"
  "$BASE_DIR/references/issue-intelligence.md"
  "$BASE_DIR/references/process-discipline.md"
  "$BASE_DIR/references/self-evolution.md"
  "$BASE_DIR/references/real-machine-trial.md"
  "$BASE_DIR/references/acceptance-matrix.md"
  "$BASE_DIR/scripts/install_openclaw_user_node.sh"
  "$BASE_DIR/scripts/check_openclaw_runtime.sh"
  "$BASE_DIR/scripts/patch_openclaw_config.py"
  "$BASE_DIR/scripts/check_platform_integrations.sh"
  "$BASE_DIR/scripts/repair_gateway_launchagent.sh"
  "$BASE_DIR/scripts/create_desktop_shortcuts.sh"
  "$BASE_DIR/scripts/check_telegram_delivery_modes.py"
  "$BASE_DIR/scripts/collect_issue_intelligence.sh"
)

echo "==> skyfix smoke check"
echo "base: $BASE_DIR"

for file in "${REQUIRED_RUNTIME_FILES[@]}"; do
  [[ -e "$file" ]] || { echo "Missing required runtime file: $file" >&2; exit 1; }
done

echo "==> Required runtime files present: ${#REQUIRED_RUNTIME_FILES[@]}"

bash "$BASE_DIR/scripts/install_openclaw_user_node.sh" --help >/dev/null
bash "$BASE_DIR/scripts/check_openclaw_runtime.sh" --help >/dev/null
python3 "$BASE_DIR/scripts/patch_openclaw_config.py" --help >/dev/null
bash "$BASE_DIR/scripts/check_platform_integrations.sh" --help >/dev/null
bash "$BASE_DIR/scripts/repair_gateway_launchagent.sh" --help >/dev/null
bash "$BASE_DIR/scripts/create_desktop_shortcuts.sh" --help >/dev/null
python3 "$BASE_DIR/scripts/check_telegram_delivery_modes.py" --help >/dev/null
bash "$BASE_DIR/scripts/collect_issue_intelligence.sh" 'openclaw gateway issue' >/dev/null

echo "==> Script help/smoke checks passed"

if command -v python3 >/dev/null 2>&1; then
  bash "$BASE_DIR/scripts/check_openclaw_runtime.sh" >/dev/null
  bash "$BASE_DIR/scripts/check_platform_integrations.sh" >/dev/null
fi

echo "==> skyfix smoke check passed"
