#!/usr/bin/env bash
# Install the shared AI skill pack into a project for Claude Code and Antigravity.
#
#   Pack-owned:    skills/* -> <target>/.claude/skills and <target>/.agents/skills
#                  (same-name skills are replaced; re-run to upgrade)
#   Project-owned: AGENTS.md, CLAUDE.md, docs/glossary.md, .claude/settings.json
#                  (copied from templates/ only when missing; never overwritten)
#
# Usage: bash path/to/skill-pack/install.sh [target-dir]   (default: current directory)
set -euo pipefail

pack="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target="$(cd "${1:-.}" && pwd)"

if [ "$target" = "$pack" ]; then
  echo "Target is the skill pack itself. Run from the project root or pass the project root." >&2
  exit 1
fi

# Pack-owned skills: replace on every install
for root in "$target/.claude/skills" "$target/.agents/skills"; do
  mkdir -p "$root"
  count=0
  for skill in "$pack"/skills/*/; do
    name="$(basename "$skill")"
    rm -rf "${root:?}/$name"
    cp -R "$skill" "$root/$name"
    count=$((count + 1))
  done
  echo "skills  -> $root ($count skills)"
done

# Project-owned files: copy only when missing
copy_if_missing() {
  local from="$pack/templates/$1" to="$target/$2"
  if [ -e "$to" ]; then
    echo "skip    $2 (already exists)"
    return
  fi
  mkdir -p "$(dirname "$to")"
  cp "$from" "$to"
  echo "added   $2"
}

copy_if_missing AGENTS.md AGENTS.md
copy_if_missing CLAUDE.md CLAUDE.md
copy_if_missing glossary.md docs/glossary.md
copy_if_missing claude-settings.json .claude/settings.json

# Claude Code reads CLAUDE.md instead of AGENTS.md when a CLAUDE.md exists
if ! grep -q '^@AGENTS\.md' "$target/CLAUDE.md"; then
  echo "WARNING: CLAUDE.md does not import AGENTS.md. Add a line '@AGENTS.md' or Claude Code will not load the shared rules." >&2
fi

echo
echo "Next: fill in the [placeholders] in AGENTS.md and docs/glossary.md."
