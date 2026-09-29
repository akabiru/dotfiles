---
name: nvim-draft
description: Open a drafted text (Slack message, PR comment, email, review note) as an unsaved markdown buffer in the user's running nvim so they can copy it with formatting. Use when the user asks to "open it in nvim", "put it in a buffer", "so I can copy it", or invokes /nvim-draft.
---

# nvim-draft

Put a draft into the user's running nvim as a new tab holding an unnamed, unsaved markdown buffer.

## Steps

1. Take the draft from the conversation (the most recent one unless the user names another). If there isn't one yet, write it first. Use plain markdown with no em dashes and no surrounding `---` separators or code fences, since the buffer should hold exactly what gets pasted.
2. Write it to a file in the session scratchpad directory (e.g. `<scratchpad>/<slug>.md`).
3. Run the script from this skill's base directory:

   ```bash
   <skill-base-dir>/open-draft.sh <file> "$PWD"
   ```

   The script picks the nvim server whose cwd matches the project dir (or the first live server otherwise, with a warning on stderr), opens a new tab, reads the file in, and prints `['', 1, <lines>]` (unnamed buffer, modified, line count).
4. Confirm in one line: tab opened, unsaved, `:q!` to discard, plus the scratchpad path.

If no nvim server is running, say so and give the scratchpad path instead.
