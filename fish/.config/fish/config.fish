# ── Aliases ──────────────────────────────────────────────────────────────────

alias o='overmind'
alias d='docker'
alias dcx='docker-compose exec'
alias dcr='docker-compose run --rm'
alias dcu='docker-compose up'
alias dcs='docker-compose stop'
alias dstats='docker stats --format "table {{.Name}}:\t{{.MemUsage}}\t{{.CPUPerc}}"'

alias ggpull='git pull origin (__git.current_branch)'
alias ggpush='git push origin (__git.current_branch)'

# ── Environment ──────────────────────────────────────────────────────────────

set -x EDITOR nvim

# Point XDG-aware tools (lazydocker, lazygit) at ~/.config instead of the macOS
# default ~/Library/Application Support, so their configs live with the dotfiles.
set -gx XDG_CONFIG_HOME $HOME/.config

# ── PATH ─────────────────────────────────────────────────────────────────────

fish_add_path /usr/local/bin
fish_add_path /opt/cloud66/bin
fish_add_path /usr/local/go/bin
fish_add_path ~/go/bin
fish_add_path /opt/homebrew/opt/postgresql@17/bin
fish_add_path ~/.cargo/bin

# ── Tool init (keep last) ───────────────────────────────────────────────────

status --is-interactive; and nodenv init - fish | source
starship init fish | source

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
