#!/bin/bash
# Sync skills to just-every/code (~/.code/skills/)
# just-every/code skips symlinks, so we must copy actual files

SOURCE="/Users/alexander/Node/claude-stuff/skills"
DEST="$HOME/.code/skills"

echo "Syncing skills from claude-stuff to ~/.code/skills/"

# Remove old skill copies (but keep .system)
find "$DEST" -maxdepth 1 -mindepth 1 -type d ! -name '.system' -exec rm -rf {} \;

# Copy all skills
for skill in "$SOURCE"/*/; do
    name=$(basename "$skill")
    [[ "$name" == ".DS_Store" ]] && continue
    cp -r "$skill" "$DEST/$name"
    echo "  ✓ $name"
done

echo "Done. Restart 'code' CLI to pick up changes."
