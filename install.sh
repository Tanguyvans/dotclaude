#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
HOOKS_DIR="$CLAUDE_DIR/hooks"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"

echo "=== dotclaude installer ==="
echo ""

# Create directories
mkdir -p "$HOOKS_DIR"

# --- Install hook ---
echo "[1/2] Installing obsidian-session-log hook..."
cp "$SCRIPT_DIR/hooks/obsidian-session-log.sh" "$HOOKS_DIR/obsidian-session-log.sh"
chmod +x "$HOOKS_DIR/obsidian-session-log.sh"
echo "  -> Copied to $HOOKS_DIR/obsidian-session-log.sh"

# --- Configure hook in settings.json ---
echo "[2/2] Configuring SessionEnd hook in settings.json..."

if [ ! -f "$SETTINGS_FILE" ]; then
  echo '{}' > "$SETTINGS_FILE"
fi

# Use node to safely merge the hook into settings.json
node -e "
const fs = require('fs');
const settings = JSON.parse(fs.readFileSync('$SETTINGS_FILE', 'utf8'));

// Ensure hooks object exists
if (!settings.hooks) settings.hooks = {};
if (!settings.hooks.SessionEnd) settings.hooks.SessionEnd = [];

// Check if obsidian hook already exists
const hookCommand = '$HOOKS_DIR/obsidian-session-log.sh';
const exists = settings.hooks.SessionEnd.some(entry =>
  entry.hooks && entry.hooks.some(h => h.command && h.command.includes('obsidian-session-log'))
);

if (!exists) {
  settings.hooks.SessionEnd.push({
    hooks: [{
      type: 'command',
      command: hookCommand,
      timeout: 30
    }]
  });
  fs.writeFileSync('$SETTINGS_FILE', JSON.stringify(settings, null, 2) + '\n');
  console.log('  -> Hook added to settings.json');
} else {
  console.log('  -> Hook already configured, skipping');
}
"

echo ""
echo "Done! Obsidian session logging is now active."
echo ""
echo "Prerequisites:"
echo "  - Obsidian CLI: must be installed and Obsidian must be running"
echo "  - jq: brew install jq"
echo "  - claude CLI: must be in PATH (used for session summaries)"
echo ""
echo "To also install the Obsidian skills plugin:"
echo "  /plugin marketplace add kepano/obsidian-skills"
echo "  /plugin install obsidian@obsidian-skills"
