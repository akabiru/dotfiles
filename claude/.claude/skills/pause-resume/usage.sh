#!/usr/bin/env bash
# Reads the plan-usage snapshot the status line writes (rate-limits.json in the current Claude profile directory)
# and prints, as JSON, the windows plus the earliest moment work can resume:
# the latest resets_at among windows at or above the threshold, plus a small
# offset, or "now" when no window is over it. Exit 2 when there is no usable
# snapshot, so the caller falls back to asking for a time.
#
# Usage: usage.sh [threshold_pct]   (default 85)

set -euo pipefail

snapshot="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/rate-limits.json"
threshold="${1:-85}"
max_age=900   # seconds; older than this and the status line has not refreshed

if [ ! -s "$snapshot" ]; then
  echo '{"error":"no snapshot - has the status line rendered since the session started?"}' >&2
  exit 2
fi

now=$(date +%s)
captured=$(jq -r '.captured_at // 0' "$snapshot")
if [ $((now - captured)) -gt "$max_age" ]; then
  echo "{\"error\":\"snapshot is $((now - captured))s old; newer than ${max_age}s needed\"}" >&2
  exit 2
fi

jq --argjson now "$now" --argjson threshold "$threshold" '
  def local($t): ($t | strflocaltime("%Y-%m-%d %H:%M"));
  def cron($t): ($t | strflocaltime("%M %H %d %m *"));
  [ ("five_hour", "seven_day", "spend_limit") as $k
    | select(.[$k] != null)
    | { window: $k,
        used_percentage: .[$k].used_percentage,
        resets_at: local(.[$k].resets_at),
        over: (.[$k].used_percentage >= $threshold),
        resets_epoch: .[$k].resets_at } ] as $w
  | ([ $w[] | select(.over) | .resets_epoch ] | max) as $blocking
  | (if $blocking == null then $now else $blocking + 120 end) as $resume
  | { captured_at: local(.captured_at),
      threshold: $threshold,
      windows: ($w | map(del(.resets_epoch))),
      can_resume_now: ($blocking == null),
      resume_at: local($resume),
      resume_cron: cron($resume) }
' "$snapshot"
