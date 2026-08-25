#!/bin/sh
# Records the workspace focus history that focus-previous.sh reads back.
set -eu

focused=$(printf '%s' "${HERDR_PLUGIN_EVENT_JSON:-}" \
  | sed -n 's/.*"workspace_id":"\([^"]*\)".*/\1/p')
if [ -z "$focused" ]; then
  exit 0
fi

state="${HERDR_PLUGIN_STATE_DIR:?}"
mkdir -p "$state"

current=$(cat "$state/current" 2>/dev/null || true)
if [ "$focused" = "$current" ]; then
  exit 0
fi

# Written via a temp file so the action never reads a half-written id.
if [ -n "$current" ]; then
  printf '%s\n' "$current" > "$state/previous.tmp"
  mv "$state/previous.tmp" "$state/previous"
fi
printf '%s\n' "$focused" > "$state/current.tmp"
mv "$state/current.tmp" "$state/current"
