if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias o='overmind'
alias d='docker'
alias dcx='docker-compose exec'
alias dcr='docker-compose run --rm'
alias dcu='docker-compose up'
alias dcs='docker-compose stop'
alias dstats='docker stats --format "table {{.Name}}:\t{{.MemUsage}}\t{{.CPUPerc}}"'

alias ggpull='git pull origin (__git.current_branch)'
alias ggpush='git push origin (__git.current_branch)'

# Load Rust
# source $HOME/.cargo/env

# OpenSSL
set -g fish_user_paths "/usr/local/opt/openssl@1.1/bin" $fish_user_paths

# Cloud66
set -g fish_user_paths /opt/cloud66/bin $fish_user_paths

# /usr/local/bin
set -g fish_user_paths /usr/local/bin $fish_user_paths

# HLEDGER
set -x LEDGER_FILE ~/Developer/akabiru/ledger/2026.journal

# EDITOR
set -x EDITOR code

# Node Env
# status --is-interactive; and source (nodenv init -|psub)
status --is-interactive; and nodenv init - fish | source

# Executables
fish_add_path /usr/local/go/bin
fish_add_path ~/go/bin
fish_add_path /opt/homebrew/opt/postgresql@17/bin
fish_add_path ~/.local/bin/claude

# Starship
starship init fish | source
