#!/bin/bash

DATE=$(date +%Y-%m-%d)
DAY_NUMBER=$(date +%j)

JOURNAL_FILE="Daily-Journal/$DATE.md"
if [ ! -f "$JOURNAL_FILE" ]; then
  cp Daily-Journal/template.md "$JOURNAL_FILE"
  sed -i "s/YYYY-MM-DD/$DATE/" "$JOURNAL_FILE"
fi

git add .
git commit -m "Day$DAY_NUMBER update: $DATE"
GIT_SSH_COMMAND="ssh -i $HOME/.ssh/ustc_auto" git push origin main

echo "Daily commit completed at $(date)" >> "$JOURNAL_FILE"
