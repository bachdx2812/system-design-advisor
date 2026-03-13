#!/bin/bash
# System Design Advisor — Install/Update for Claude Code (global)
# Usage: bash install.sh

set -e

SKILLS_DIR="$HOME/.claude/skills"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# All 6 skills
SKILLS=(
  "system-design-advisor"
  "design-plan-generator"
  "architecture-reviewer"
  "design-patterns-advisor"
  "pattern-implementation-guide"
  "code-pattern-reviewer"
)

echo "Installing System Design Advisor skills to $SKILLS_DIR..."

for skill in "${SKILLS[@]}"; do
  skill_src="$SCRIPT_DIR/skills/$skill"
  skill_dest="$SKILLS_DIR/$skill"

  if [ ! -d "$skill_src" ]; then
    echo "  [SKIP] $skill — source not found"
    continue
  fi

  mkdir -p "$skill_dest/references"

  # Copy SKILL.md
  cp "$skill_src/SKILL.md" "$skill_dest/SKILL.md"

  # Copy all reference files
  if [ -d "$SCRIPT_DIR/references" ]; then
    cp "$SCRIPT_DIR/references/"*.md "$skill_dest/references/" 2>/dev/null || true
  fi

  echo "  [OK] $skill"
done

echo ""
echo "Installed ${#SKILLS[@]} skills with $(ls "$SCRIPT_DIR/references/"*.md 2>/dev/null | wc -l | tr -d ' ') reference files each."
echo ""
echo "Available commands:"
echo "  /system-design-advisor        — Answer system design questions"
echo "  /design-plan-generator        — Generate system design plans"
echo "  /architecture-reviewer        — Review project architecture"
echo "  /design-patterns-advisor      — Answer design pattern questions"
echo "  /pattern-implementation-guide — Pattern implementation guidance"
echo "  /code-pattern-reviewer        — Review code for pattern opportunities"
