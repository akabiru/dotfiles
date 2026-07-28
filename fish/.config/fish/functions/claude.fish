function claude -d "Claude Code with per-directory account selection"
    # An explicit CLAUDE_CONFIG_DIR always wins: it doubles as a manual
    # override, and it keeps nested invocations on whichever account the
    # parent process already chose.
    if set -q CLAUDE_CONFIG_DIR
        command claude $argv
        return
    end

    set -l config_dir (_claude_config_dir)
    if test -n "$config_dir"
        CLAUDE_CONFIG_DIR=$config_dir command claude $argv
    else
        command claude $argv
    end
end

function _claude_config_dir -d "Resolve the Claude config dir for the current directory"
    # $claude_account_map holds "root=config_dir" entries and is set in
    # conf.d/secrets.fish, which is gitignored: the mechanism is shareable,
    # the directory layout it maps is not. No match means the default
    # ~/.claude, so the fallback account needs no entry.
    set -q claude_account_map; or return

    # -P resolves symlinks, so a symlinked route into a project still matches.
    set -l here (pwd -P)

    for entry in $claude_account_map
        set -l parts (string split -m1 '=' -- $entry)
        if test "$here" = "$parts[1]"; or string match -q "$parts[1]/*" -- "$here"
            echo $parts[2]
            return
        end
    end
end
