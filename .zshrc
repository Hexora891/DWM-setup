# =========================================================
# Powerlevel10k Instant Prompt (KEEP AT VERY TOP)
# =========================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =========================================================
# Safety Guard
# =========================================================
[[ -n "$ZSH_VERSION" ]] || return

# =========================================================
# Environment
# =========================================================
export ZSH="$HOME/.oh-my-zsh"
export COLORTERM="truecolor"

# Let tmux control TERM
[[ -z "$TMUX" ]] && export TERM="xterm-256color"

# =========================================================
# PATH (clean order)
# =========================================================
path=(
  $HOME/.config/scripts
  $HOME/.local/bin
  $HOME/go/bin
  $HOME/.spicetify
  $HOME/.config/suckless/dwmblocks-async/scripts
  $path
)

# =========================================================
# Editors
# =========================================================
export EDITOR="nvim"
export VISUAL="nvim"

# =========================================================
# Disable command correction
# =========================================================
DISABLE_CORRECTION="true"

# =========================================================
# Theme
# =========================================================
ZSH_THEME="powerlevel10k/powerlevel10k"

# =========================================================
# Plugins
# =========================================================
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# =========================================================
# Load Oh My Zsh
# =========================================================
source "$ZSH/oh-my-zsh.sh"

# =========================================================
# History
# =========================================================
HISTSIZE=100000
SAVEHIST=100000

setopt appendhistory
setopt sharehistory
setopt inc_append_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt extended_history

# =========================================================
# FZF
# =========================================================
if command -v fzf >/dev/null; then
  source /usr/share/fzf/key-bindings.zsh 2>/dev/null
  source /usr/share/fzf/completion.zsh 2>/dev/null
fi

export FZF_DEFAULT_OPTS="\
--layout=reverse \
--border=rounded \
--color=bg:#1a1b26,fg:#c0caf5,hl:#7aa2f7 \
--color=bg+:#24283b,fg+:#ffffff,hl+:#7aa2f7 \
--preview-window=right:60%:wrap"

# =========================================================
# Aliases
# =========================================================
alias ls='eza --icons --group-directories-first --color=always'
alias ll='eza -lah --icons --group-directories-first'
alias tree='eza --tree --icons'

alias cat='bat --style=plain --paging=never'
alias diff='delta'

export MANPAGER="sh -c 'col -bx | bat --language=man --style=full'"

alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'

command -v dircolors >/dev/null && eval "$(dircolors -b)"

# =========================================================
# Completion Improvements
# =========================================================
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# =========================================================
# Load External Files
# =========================================================
[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.functions ]] && source ~/.functions

# =========================================================
# Powerlevel10k Config (KEEP AT BOTTOM)
# =========================================================
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

export PATH=$PATH:/home/ayush/.spicetify
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"

# Force blinking beam cursor in Kitty + tmux
function zle-line-init() {
    echoti smkx
    printf '\e[5 q'
}

zle -N zle-line-init
# opencode
export PATH=/home/ayush/.opencode/bin:$PATH
