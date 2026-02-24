#!/bin/bash
LOCKFILE="/tmp/obsidian-hook.lock"
LOCK_TIMEOUT=60

if [ -f "$LOCKFILE" ]; then
  LOCK_AGE=$(( $(date +%s) - $(stat -f %m "$LOCKFILE") ))
  if [ "$LOCK_AGE" -lt "$LOCK_TIMEOUT" ]; then
    exit 0
  fi
  rm -f "$LOCKFILE"
fi
touch "$LOCKFILE"

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // "unknown"')
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // ""')
TIMESTAMP=$(date "+%H:%M")
PROJECT=$(basename "$CWD")

if [ -z "$TRANSCRIPT" ] || [ ! -f "$TRANSCRIPT" ]; then
  ENTRY="- ${TIMESTAMP} -- **${PROJECT}**"
  obsidian daily:append content="$ENTRY" 2>/dev/null
  rm -f "$LOCKFILE"
  exit 0
fi

SUMMARY=$(claude -p "Voici un transcript de session Claude Code. Resume en UNE seule ligne courte en francais ce qui a ete fait. Pas de bullet points, juste une phrase. Transcript: $(cat "$TRANSCRIPT" | tail -100 | head -50)" --output-format text 2>/dev/null)

if [ -z "$SUMMARY" ]; then
  ENTRY="- ${TIMESTAMP} -- **${PROJECT}**"
else
  ENTRY="- ${TIMESTAMP} -- **${PROJECT}** -- ${SUMMARY}"
fi

obsidian daily:append content="$ENTRY" 2>/dev/null
rm -f "$LOCKFILE"
exit 0
