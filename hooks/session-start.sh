#!/usr/bin/env bash
# SessionStart hook for claude-stuff
# Injects the using-superpowers skill content at session start

set -euo pipefail

# Get the claude-stuff root (parent of hooks directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
CLAUDE_STUFF_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Read using-superpowers content
using_superpowers_content=$(cat "${CLAUDE_STUFF_ROOT}/skills/using-superpowers/SKILL.md" 2>&1 || echo "Error reading using-superpowers skill")

# Escape outputs for JSON using pure bash
escape_for_json() {
    local input="$1"
    local output=""
    local i char
    for (( i=0; i<${#input}; i++ )); do
        char="${input:$i:1}"
        case "$char" in
            $'\\') output+='\\' ;;
            '"') output+='\"' ;;
            $'\n') output+='\n' ;;
            $'\r') output+='\r' ;;
            $'\t') output+='\t' ;;
            *) output+="$char" ;;
        esac
    done
    printf '%s' "$output"
}

using_superpowers_escaped=$(escape_for_json "$using_superpowers_content")

# Output context injection as JSON
cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "<EXTREMELY_IMPORTANT>\nYou have superpowers.\n\n**Below is the full content of your 'superpowers:using-superpowers' skill - your introduction to using skills. For all other skills, use the 'Skill' tool:**\n\n---\n${using_superpowers_escaped}\n\n</EXTREMELY_IMPORTANT>"
  }
}
EOF

exit 0
