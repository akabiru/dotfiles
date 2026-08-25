#!/bin/sh
# Bound to prefix+shift+L, standing in for tmux's `switch-client -l`.
set -eu

previous=$(cat "${HERDR_PLUGIN_STATE_DIR:?}/previous" 2>/dev/null || true)
[ -n "$previous" ] || exit 0

# The workspace may have been closed since it was recorded.
herdr workspace focus "$previous" >/dev/null 2>&1 || exit 0
