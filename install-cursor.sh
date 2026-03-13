#!/bin/bash
# System Design Advisor — Install/Update for Cursor
# Usage: bash install-cursor.sh [project-dir]
# Installs cursor rules to .cursor/rules/ in the target project

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="${1:-.}"
RULES_DIR="$TARGET/.cursor/rules"

echo "Installing System Design Advisor cursor rules to $RULES_DIR..."

mkdir -p "$RULES_DIR"

if [ -d "$SCRIPT_DIR/cursor/rules" ]; then
  cp "$SCRIPT_DIR/cursor/rules/"*.mdc "$RULES_DIR/" 2>/dev/null || true
  count=$(ls "$RULES_DIR/"*.mdc 2>/dev/null | wc -l | tr -d ' ')
  echo "  [OK] Installed $count cursor rules"
else
  echo "  [ERROR] cursor/rules/ directory not found"
  exit 1
fi

echo ""
echo "Rules auto-activate based on your prompts — no manual invocation needed."
