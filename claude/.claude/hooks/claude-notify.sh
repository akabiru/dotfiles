#!/usr/bin/env bash
#
# Claude Code "Notification" hook -> contextual macOS notification.
#
# The generic "Claude needs your input" alert is useless when several
# Claude instances run across multiple tmux sessions: you can't tell which
# one is asking, and identical alerts stack into a pile.
#
# The hook process inherits $TMUX_PANE from the Claude process's pane, so we
# resolve the session / window / project it came from and surface that in the
# notification. Alerts are grouped per pane (a new one replaces the old rather
# than stacking), and clicking jumps tmux straight to the originating pane.
#
# Falls back to a plain notification when not running inside tmux. The script
# never hard-fails: a missing detail degrades the message, it never suppresses
# the alert.
#
# Wired from ~/.claude/settings.json:
#   "hooks": { "Notification": [ { "hooks": [
#     { "type": "command", "command": "~/.claude/hooks/claude-notify.sh" } ] } ] }

# Hook payload arrives as JSON on stdin.
payload="$(cat)"

message="$(printf '%s' "$payload" | jq -r '.message // empty' 2>/dev/null)"
cwd="$(printf '%s' "$payload" | jq -r '.cwd // empty' 2>/dev/null)"
[ -z "$message" ] && message="Needs your input"

project=""
[ -n "$cwd" ] && project="$(basename "$cwd")"

title="Claude Code"
subtitle="$project"
group="claude-notify"
execute=""

# When launched from within tmux, enrich with the pane's context.
if [ -n "${TMUX_PANE:-}" ] && command -v tmux >/dev/null 2>&1; then
  tmux_bin="$(command -v tmux)"
  ctx="$("$tmux_bin" display-message -p -t "$TMUX_PANE" '#S|#I' 2>/dev/null)"
  if [ -n "$ctx" ]; then
    session="${ctx%%|*}"
    win_index="${ctx##*|}"

    title="Claude · $session"
    # Lead with the project (the "app"); tmux auto-names windows after the
    # running command, which is noise, so use only the window index to
    # disambiguate when a session has more than one window.
    subtitle="$project"
    [ -n "$win_index" ] && subtitle="${subtitle:+$subtitle  ·  }win $win_index"

    # One group per pane: repeat alerts from the same instance replace each
    # other, and distinct instances keep separate slots instead of piling up.
    group="claude-notify-$TMUX_PANE"

    # Click: bring Ghostty forward, then focus the exact window + pane.
    # Absolute tmux path because the click runs in a minimal shell env.
    execute="open -b com.mitchellh.ghostty; \"$tmux_bin\" select-window -t '$TMUX_PANE'; \"$tmux_bin\" select-pane -t '$TMUX_PANE'; \"$tmux_bin\" switch-client -t '$session'"
  fi
fi

args=(
  -title "$title"
  -message "$message"
  -sound Glass
  -group "$group"
)
[ -n "$subtitle" ] && args+=(-subtitle "$subtitle")
if [ -n "$execute" ]; then
  args+=(-execute "$execute")
else
  # No pane to jump to; just bring the terminal forward on click.
  args+=(-activate com.mitchellh.ghostty)
fi

terminal-notifier "${args[@]}"
