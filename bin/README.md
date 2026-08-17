# bin

Personal scripts on `PATH`, stowed into `~/.local/bin`.

```sh
stow --target="$HOME" bin
```

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
