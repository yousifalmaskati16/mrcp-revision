#!/usr/bin/env bash
# Push an MRCP revision reminder to the phone via ntfy.sh.
# Portable (macOS + Linux/GitHub Actions). Usage: notify.sh [daily|weekly|milestone]
set -euo pipefail

TOPIC="${NTFY_TOPIC:-mrcp-yousif-6d88bd23}"
APP_URL="${APP_URL:-https://yousifalmaskati16.github.io/mrcp-revision/}"
EXAM="2026-09-23"
MODE="${1:-daily}"

days=$(python3 - "$EXAM" <<'PY'
import sys,datetime
exam=datetime.date.fromisoformat(sys.argv[1])
print(max(0,(exam-datetime.date.today()).days))
PY
)

TIPS=(
"Active recall beats re-reading. Rate yourself honestly."
"Do your weak spots first, then clear due reviews."
"Confidence under 3 on a topic? Reopen its notes tonight."
"Little and often wins. 20 focused minutes still counts."
"Teach one concept out loud from memory."
)
tip="${TIPS[$((RANDOM % ${#TIPS[@]}))]}"

title=""; body=""; prio="default"; tags="books"
case "$MODE" in
  weekly)
    title="MRCP weekly check · ${days} days left"
    body="Open Progress and see the week: weak spots fixed, topics revised. ${tip}"
    tags="bar_chart" ;;
  milestone)
    case "$days" in
      30|14|7|3|1) ;;
      *) echo "not a milestone day (${days}) — skipping"; exit 0 ;;
    esac
    title="🎯 ${days} day$([ "$days" -gt 1 ] && echo s) to MRCP"
    body="Milestone check-in. Where are your weak spots at? Open the app."
    prio="high"; tags="dart" ;;
  *)
    title="MRCP revision · ${days} days to go"
    body="Time to clear today's goal — weak spots, due reviews, then something new. ${tip}"
    [ "$days" -le 21 ] && prio="high"
    [ "$days" -le 7  ] && title="⚠️ ${days} DAYS LEFT — MRCP revision" ;;
esac

curl -s \
  -H "Title: ${title}" -H "Priority: ${prio}" -H "Tags: ${tags}" -H "Click: ${APP_URL}" \
  -d "${body}" "https://ntfy.sh/${TOPIC}" > /dev/null && echo "sent [${MODE}]: ${title}"
