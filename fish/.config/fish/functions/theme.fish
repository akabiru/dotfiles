function theme -d "Get or set theme mode (auto/dark/light)"
    set -l mode_file "$HOME/.theme-mode"

    # No argument: show current state
    if test (count $argv) -eq 0
        set -l mode auto
        if test -f $mode_file
            set mode (string trim (cat $mode_file))
        end
        set -l effective (_theme_resolve $mode)
        echo "mode: $mode (effective: $effective)"
        return
    end

    set -l mode $argv[1]

    # Handle toggle
    if test "$mode" = toggle
        set -l current auto
        if test -f $mode_file
            set current (string trim (cat $mode_file))
        end
        switch $current
            case auto
                set mode dark
            case dark
                set mode light
            case light
                set mode auto
            case '*'
                set mode auto
        end
    end

    # Validate
    switch $mode
        case auto dark light
            # valid
        case '*'
            echo "Usage: theme [auto|dark|light|toggle]"
            return 1
    end

    # Write state
    echo $mode >$mode_file

    # Resolve effective theme
    set -l effective (_theme_resolve $mode)
    echo "mode: $mode (effective: $effective)"

    # Apply to tmux
    if type -q tmux; and tmux list-sessions &>/dev/null
        set -l flavor mocha
        if test "$effective" = light
            set flavor latte
        end
        tmux set -g @catppuccin_flavor "$flavor"
        tmux source-file ~/.tmux.conf
    end

    # Apply to Ghostty (auto-reloads on config file change)
    set -l ghostty_theme_file "$HOME/.config/ghostty/theme.ghostty"
    if test "$mode" = auto
        echo -n >$ghostty_theme_file
    else if test "$effective" = light
        echo "theme = Catppuccin Latte" >$ghostty_theme_file
    else
        echo "theme = Catppuccin Mocha" >$ghostty_theme_file
    end
end

function _theme_resolve -d "Resolve theme mode to dark or light"
    set -l mode $argv[1]
    switch $mode
        case dark
            echo dark
        case light
            echo light
        case '*'
            # auto: query macOS
            if defaults read -g AppleInterfaceStyle &>/dev/null
                echo dark
            else
                echo light
            end
    end
end
