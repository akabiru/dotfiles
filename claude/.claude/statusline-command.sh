#!/usr/bin/env bash
# Claude Code status line - mirrors Starship default style
# Receives Claude Code session JSON on stdin

input=$(cat)

# --- Directory (replace $HOME with ~) ---
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // ""')
cwd_display="${cwd/#$HOME/~}"

# --- Git branch (skip optional locks) ---
branch=""
if git -C "$cwd" -c gc.auto=0 rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$cwd" -c gc.auto=0 symbolic-ref --short HEAD 2>/dev/null \
           || git -C "$cwd" -c gc.auto=0 rev-parse --short HEAD 2>/dev/null)
fi

# --- Model (short name) ---
model=$(echo "$input" | jq -r '.model.display_name // ""')

# --- Context window ---
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# --- Assemble ---
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
DIM='\033[2m'
RESET='\033[0m'

parts=""

# Directory
parts="${parts}${CYAN}${cwd_display}${RESET}"

# Git branch
if [ -n "$branch" ]; then
  parts="${parts} ${GREEN}${branch}${RESET}"
fi

# Model
if [ -n "$model" ]; then
  parts="${parts} ${DIM}${model}${RESET}"
fi

# Context usage
if [ -n "$used_pct" ]; then
  used_int=$(printf '%.0f' "$used_pct")
  parts="${parts} ${YELLOW}ctx:${used_int}%${RESET}"
fi

printf "%b" "$parts"
