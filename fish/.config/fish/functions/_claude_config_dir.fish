function _claude_config_dir -d "Resolve the Claude config dir for the current directory"
    # Lives in its own file so non-fish callers can reach it: fish only autoloads
    # a function from the file that shares its name.
    #
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
