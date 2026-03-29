# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ~/.zshrc - Main zsh configuration
# Modern zsh setup with zinit plugin manager
# Based on dreamsofautonomy/zensh patterns

# ──────────────────────────────────────────────────────────────
# Zinit Plugin Manager
# ──────────────────────────────────────────────────────────────

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Auto-install zinit if not present
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# ──────────────────────────────────────────────────────────────
# Plugins
# ──────────────────────────────────────────────────────────────

# Prompt: Powerlevel10k
zinit ice depth=1
zinit light romkatv/powerlevel10k

# Essential plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Useful snippets from Oh My Zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found
zinit snippet OMZP::extract
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose
zinit snippet OMZP::kubectl

# ──────────────────────────────────────────────────────────────
# Completion system
# ──────────────────────────────────────────────────────────────

autoload -Uz compinit
# Only regenerate .zcompdump once a day
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

zinit cdreplay -q

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons --color=always $realpath 2>/dev/null || ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --icons --color=always $realpath 2>/dev/null || ls --color $realpath'

# ──────────────────────────────────────────────────────────────
# Zsh Options
# ──────────────────────────────────────────────────────────────

# History
HISTSIZE=50000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Directory navigation
setopt autocd
setopt autopushd
setopt pushdminus
setopt pushdsilent
setopt pushdtohome
setopt cdable_vars

# Globbing
setopt extendedglob
setopt nomatch
setopt no_case_glob

# Misc
setopt correct
setopt interactive_comments
setopt no_beep

# ──────────────────────────────────────────────────────────────
# Vi mode (with emacs-style keybindings for line editing)
# ──────────────────────────────────────────────────────────────

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# ──────────────────────────────────────────────────────────────
# Load dotfiles
# ──────────────────────────────────────────────────────────────

for file in ~/.{path,exports,aliases,functions,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# ──────────────────────────────────────────────────────────────
# Tool Integrations
# ──────────────────────────────────────────────────────────────

# fzf
if command -v fzf &>/dev/null; then
    source <(fzf --zsh 2>/dev/null) || true
fi

# zoxide (smarter cd)
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init --cmd cd zsh)"
fi

# uv (Python package manager)
if command -v uv &>/dev/null; then
    eval "$(uv generate-shell-completion zsh 2>/dev/null)" || true
fi

# GitHub CLI
if command -v gh &>/dev/null; then
    eval "$(gh completion -s zsh 2>/dev/null)" || true
fi

# iTerm2 shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Claude Code shell integration
if command -v claude &>/dev/null; then
    eval "$(claude shell-completion zsh 2>/dev/null)" || true
fi

# ──────────────────────────────────────────────────────────────
# Powerlevel10k config
# ──────────────────────────────────────────────────────────────

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
