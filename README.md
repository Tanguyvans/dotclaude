# dotclaude

My Claude Code configuration: hooks, skills, and settings.

## What's included

### Hooks

- **obsidian-session-log** - Logs a summary of each Claude Code session to your Obsidian daily note via the Obsidian CLI. Runs on `SessionEnd`.

### Skills (from [obsidian-skills](https://github.com/kepano/obsidian-skills))

| Skill | Description |
|-------|-------------|
| obsidian-markdown | Obsidian Flavored Markdown (wikilinks, embeds, callouts, properties) |
| obsidian-bases | Obsidian Bases (.base files) with views, filters, formulas |
| obsidian-cli | Interact with Obsidian vaults via the CLI |
| json-canvas | JSON Canvas files (.canvas) with nodes, edges, groups |
| defuddle | Extract clean markdown from web pages |

## Installation

```bash
git clone https://github.com/tanguyvans/dotclaude.git
cd dotclaude
./install.sh
```

This will:
1. Copy the obsidian session log hook to `~/.claude/hooks/`
2. Add the `SessionEnd` hook entry to `~/.claude/settings.json`

### Install the Obsidian skills plugin

In Claude Code:
```
/plugin marketplace add kepano/obsidian-skills
/plugin install obsidian@obsidian-skills
```

## Prerequisites

- [Obsidian](https://obsidian.md) with the CLI enabled
- [jq](https://jqlang.github.io/jq/) (`brew install jq`)
- [claude](https://docs.anthropic.com/en/docs/claude-code) CLI in PATH
