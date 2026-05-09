# ──────────────────────────────────────────────────────────────────────────────
# ~/.zshrc
# Portable ZSH config for Linux workstations
# ──────────────────────────────────────────────────────────────────────────────

# ── PATH ─────────────────────────────────────────────────────────────────────

typeset -U path PATH

add_path() {
    [[ -d "$1" ]] && path=("$1" $path)
}

add_path "$HOME/bin"
add_path "$HOME/.local/bin"
add_path "$HOME/.local/pipx/bin"

add_path "/usr/local/bin"
add_path "/usr/local/go/bin"
add_path "$HOME/go/bin"

add_path "$HOME/.npm-global/bin"
add_path "$HOME/.local/share/pnpm"
add_path "$HOME/.cargo/bin"
add_path "$HOME/.bun/bin"

add_path "$HOME/.local/share/flatpak/exports/bin"
add_path "/var/lib/flatpak/exports/bin"

add_path "/usr/local/cuda/bin"

export PATH

# ── Oh My Zsh ────────────────────────────────────────────────────────────────

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
    git
    docker
    docker-compose
    zsh-autosuggestions
    zsh-syntax-highlighting
)

[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# ── Conda ────────────────────────────────────────────────────────────────────

CONDA_PATH="$HOME/miniconda3"

if [[ -f "$CONDA_PATH/bin/conda" ]]; then
    export CONDA_CHANGEPS1=false

    __conda_setup="$("$CONDA_PATH/bin/conda" shell.zsh hook 2>/dev/null)"

    if [[ $? -eq 0 ]]; then
        eval "$__conda_setup"
    elif [[ -f "$CONDA_PATH/etc/profile.d/conda.sh" ]]; then
        source "$CONDA_PATH/etc/profile.d/conda.sh"
    fi

    unset __conda_setup
fi

# ── Prompt ───────────────────────────────────────────────────────────────────

NEWLINE_BEFORE_PROMPT=yes

precmd() {
    if [[ "$NEWLINE_BEFORE_PROMPT" == yes ]]; then
        if [[ -z "$_NEW_LINE_BEFORE_PROMPT" ]]; then
            _NEW_LINE_BEFORE_PROMPT=1
        else
            print ""
        fi
    fi
}

update_prompt() {
    local env_segment=""
    local conda_segment=""

    if [[ -n "$VIRTUAL_ENV" ]]; then
        local venv_name
        venv_name=$(basename "$VIRTUAL_ENV")
        env_segment="%F{yellow}(venv:${venv_name})%F{blue}─"
    fi

    if [[ -n "$CONDA_DEFAULT_ENV" && "$CONDA_DEFAULT_ENV" != "base" ]]; then
        conda_segment="%F{magenta}(conda:${CONDA_DEFAULT_ENV})%F{blue}─"
    fi

    PROMPT='%F{blue}┌──'"${debian_chroot:+($debian_chroot)─}"'${env_segment}${conda_segment}'\
'(%B%F{%(#.red.green)}%n%F{white}@%F{blue}%m%b%F{blue})-[%B%F{reset}%~%b%F{blue}]
%F{blue}└─%B%(#.%F{red}#.%F{cyan}$)%b%F{reset} '
}

update_prompt
precmd_functions+=(update_prompt)

# ── Aliases ──────────────────────────────────────────────────────────────────

alias c='clear'
alias h='history'
alias reload='source ~/.zshrc'

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
    if [[ ! -f "$1" ]]; then
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
SAVEHIST=10000
HISTFILE="$HOME/.zsh_history"

setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
