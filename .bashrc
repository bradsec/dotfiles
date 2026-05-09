# ──────────────────────────────────────────────────────────────────────────────
# ~/.bashrc
# Portable Bash config for Linux workstations
# ──────────────────────────────────────────────────────────────────────────────

# Exit if not interactive
case $- in
    *i*) ;;
    *) return ;;
esac

# ── PATH ─────────────────────────────────────────────────────────────────────

path_add() {
    [ -d "$1" ] || return

    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="$1:$PATH" ;;
    esac
}

path_add "$HOME/bin"
path_add "$HOME/.local/bin"
path_add "$HOME/.local/pipx/bin"

path_add "/usr/local/bin"
path_add "/usr/local/go/bin"
path_add "$HOME/go/bin"

path_add "$HOME/.npm-global/bin"
path_add "$HOME/.local/share/pnpm"
path_add "$HOME/.cargo/bin"
path_add "$HOME/.bun/bin"

path_add "$HOME/.local/share/flatpak/exports/bin"
path_add "/var/lib/flatpak/exports/bin"

path_add "/usr/local/cuda/bin"

export PATH

# ── Conda ────────────────────────────────────────────────────────────────────

CONDA_PATH="$HOME/miniconda3"

if [ -f "$CONDA_PATH/bin/conda" ]; then
    export CONDA_CHANGEPS1=false

    __conda_setup="$("$CONDA_PATH/bin/conda" shell.bash hook 2>/dev/null)"

    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    elif [ -f "$CONDA_PATH/etc/profile.d/conda.sh" ]; then
        . "$CONDA_PATH/etc/profile.d/conda.sh"
    fi

    unset __conda_setup
fi

# ── Prompt ───────────────────────────────────────────────────────────────────

set_prompt() {
    local env_segment=""
    local conda_segment=""

    local blue="\[\033[34m\]"
    local green="\[\033[32m\]"
    local red="\[\033[31m\]"
    local white="\[\033[37m\]"
    local yellow="\[\033[33m\]"
    local magenta="\[\033[35m\]"
    local cyan="\[\033[36m\]"
    local reset="\[\033[0m\]"
    local bold="\[\033[1m\]"

    if [ -n "$VIRTUAL_ENV" ]; then
        env_segment="${yellow}(venv:$(basename "$VIRTUAL_ENV"))${blue}─"
    fi

    if [ -n "$CONDA_DEFAULT_ENV" ] && [ "$CONDA_DEFAULT_ENV" != "base" ]; then
        conda_segment="${magenta}(conda:${CONDA_DEFAULT_ENV})${blue}─"
    fi

    if [ "$EUID" -eq 0 ]; then
        local user_color="$red"
        local symbol="${red}#"
    else
        local user_color="$green"
        local symbol="${cyan}$"
    fi

    PS1="\n${blue}┌──${env_segment}${conda_segment}(${bold}${user_color}\u${white}@${blue}\h${reset}${blue})-[${bold}${reset}\w${blue}]\n${blue}└─${bold}${symbol}${reset} "
}

PROMPT_COMMAND=set_prompt

# ── Aliases ──────────────────────────────────────────────────────────────────

alias c='clear'
alias h='history'
alias reload='source ~/.bashrc'

alias ls='ls --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -lah'
alias lt='ls -lahtr'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias mkdir='mkdir -pv'

alias df='df -h'
alias du='du -sh'
alias free='free -h'
alias ports='ss -tulnp'

alias update='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias search='apt search'

alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'

alias d='docker'
alias dc='docker compose'
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs -f'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcr='docker compose restart'

alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv .venv'
alias activate='source .venv/bin/activate'

alias gor='go run .'
alias gob='go build'
alias got='go test ./...'
alias gom='go mod tidy'

alias ytmp3='yt-dlp -x --audio-format mp3'
alias ytbest='yt-dlp -f "bv*+ba/b"'

# ── Functions ────────────────────────────────────────────────────────────────

mkcd() {
    mkdir -p "$1" && cd "$1" || return
}

extract() {
    if [ ! -f "$1" ]; then
        echo "'$1' is not a valid file"
        return 1
    fi

    case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz)  tar xzf "$1" ;;
        *.bz2)     bunzip2 "$1" ;;
        *.rar)     unrar x "$1" ;;
        *.gz)      gunzip "$1" ;;
        *.tar)     tar xf "$1" ;;
        *.tbz2)    tar xjf "$1" ;;
        *.tgz)     tar xzf "$1" ;;
        *.zip)     unzip "$1" ;;
        *.7z)      7z x "$1" ;;
        *) echo "Cannot extract '$1'" ;;
    esac
}

# ── History ──────────────────────────────────────────────────────────────────

HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=ignoredups:erasedups

shopt -s histappend
