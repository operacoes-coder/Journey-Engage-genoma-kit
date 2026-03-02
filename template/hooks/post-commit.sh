#!/bin/bash
# PGP (Protocolo GENOMA Perpetuo) - Post-commit hook
# Auto-appends commit info to SNAPSHOT.md "Recent Activity" section

COMMIT_MSG=$(git log -1 --pretty=format:"%s")
COMMIT_HASH=$(git log -1 --pretty=format:"%h")
DATE=$(date +%Y-%m-%d_%H:%M)

SNAPSHOT=".context/SNAPSHOT.md"

# Only update if SNAPSHOT exists and this isn't a snapshot/session commit (avoid recursion)
if [ -f "$SNAPSHOT" ] && ! echo "$COMMIT_MSG" | grep -qE "^(snapshot|session)\("; then
  # Append to Recent Activity section
  if grep -q "## Recent Activity" "$SNAPSHOT"; then
    # Insert after "## Recent Activity" line
    sed -i "/## Recent Activity/a - [$DATE] $COMMIT_HASH: $COMMIT_MSG" "$SNAPSHOT"
  fi
fi
