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
