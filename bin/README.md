# bin

Personal scripts on `PATH`, stowed into `~/.local/bin`.

```sh
stow --target="$HOME" bin
```

## work

Opens a tmux workspace for a project: editor and shell stacked on the left, two
AI agents stacked on the right. Creates the session on first call and attaches
to it on every call after, so it doubles as the way back in. Run it with no args
(or `-h`/`--help`) for usage.

```sh
work .                        # session named after the directory
work ~/src/app -n review      # explicit session name
work . -d                     # build it, stay where you are
work . -k                     # kill the session
```

Pane commands and sizes come from the environment: `WORK_EDITOR` (default nvim
with the Snacks explorer open), `WORK_TOP` (`pi`), `WORK_BOTTOM` (`claude`),
`WORK_RIGHT_WIDTH` (31), `WORK_SHELL_HEIGHT` (12).

## op-test

Runs RSpec inside the OpenProject `backend-test` container against whatever git
worktree you're currently in. Derives the container path from your cwd, and
temporarily matches the worktree's `.ruby-version` to the main checkout so a
linked worktree on another branch still boots. Run it with no args (or
`-h`/`--help`) for usage.

```sh
op-test spec/models/user_spec.rb
op-test spec/requests/foo_spec.rb:42 spec/models/bar_spec.rb
op-test spec/foo_spec.rb -- --seed 1234    # args after -- go to rspec
```

Env overrides: `OP_CONTAINER_ROOT`, `OP_TEST_SERVICE`, `OP_RSPEC`.
