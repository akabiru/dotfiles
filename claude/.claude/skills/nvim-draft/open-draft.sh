#!/usr/bin/env bash
# Opens markdown from a file (or stdin) as an unnamed, unsaved buffer in a new
# tab of the running nvim whose cwd matches the given directory.
# Usage: open-draft.sh <draft.md|-> [project-dir]
set -euo pipefail

src="${1:?usage: open-draft.sh <draft.md|-> [project-dir]}"
want_dir="$(cd "${2:-$PWD}" && pwd -P)"

if [[ "$src" == "-" ]]; then
  src="$(mktemp -t nvim-draft).md"
  cat > "$src"
fi
src="$(cd "$(dirname "$src")" && pwd -P)/$(basename "$src")"

socket_dir="${TMPDIR:-/tmp}/nvim.$USER"
match="" fallback=""
for sock in "$socket_dir"/*/nvim.*.0; do
  [[ -S "$sock" ]] || continue
  pid="${sock##*/nvim.}"; pid="${pid%.0}"
  kill -0 "$pid" 2>/dev/null || continue
  cwd="$(lsof -a -p "$pid" -d cwd -Fn 2>/dev/null | sed -n 's/^n//p')"
  [[ -z "$fallback" ]] && fallback="$sock"
  if [[ "$cwd" == "$want_dir" ]]; then match="$sock"; break; fi
done

sock="${match:-$fallback}"
[[ -n "$sock" ]] || { echo "No running nvim server found in $socket_dir" >&2; exit 1; }
[[ -n "$match" ]] || echo "No nvim with cwd $want_dir; using $sock" >&2

escaped="${src// /\\ }"
nvim --server "$sock" --remote-expr \
  "execute('tabnew | setlocal filetype=markdown | silent 0read $escaped | \$delete _ | normal! gg')" >/dev/null
nvim --server "$sock" --remote-expr "string([bufname('%'), &modified, line('\$')])"
