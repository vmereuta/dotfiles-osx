#!/usr/bin/env bash

# Modern Homebrew setup for macOS development environment
# Run: bash brew.sh

set -euo pipefail

echo "==> Starting Homebrew setup..."

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing sudo time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# ──────────────────────────────────────────────────────────────
# Update Homebrew
# ──────────────────────────────────────────────────────────────

brew update
brew upgrade

# ──────────────────────────────────────────────────────────────
# Core: GNU utilities (replace macOS builtins)
# ──────────────────────────────────────────────────────────────

brew install coreutils
brew install moreutils
brew install findutils
brew install gnu-sed

# ──────────────────────────────────────────────────────────────
# Shell: zsh + completions
# ──────────────────────────────────────────────────────────────

brew install zsh
brew install zsh-completions

# ──────────────────────────────────────────────────────────────
# Modern CLI replacements
# ──────────────────────────────────────────────────────────────

brew install eza          # ls replacement (icons, git integration)
brew install bat          # cat replacement (syntax highlighting)
brew install fd           # find replacement (faster, friendlier)
brew install ripgrep      # grep replacement (fastest)
brew install fzf          # fuzzy finder (essential)
brew install zoxide       # cd replacement (learns your habits)
brew install sd           # sed replacement (simpler regex)
brew install dust         # du replacement (visual disk usage)
brew install duf          # df replacement (better disk free)
brew install procs        # ps replacement
brew install bottom       # top replacement (btm)
brew install hyperfine    # benchmarking tool
brew install tokei        # code line counter
brew install delta        # git diff viewer (side-by-side)
brew install difftastic   # structural diff tool

# ──────────────────────────────────────────────────────────────
# Git & version control
# ──────────────────────────────────────────────────────────────

brew install git
brew install git-lfs
brew install gh           # GitHub CLI
brew install lazygit      # TUI for git
brew install git-absorb   # auto fixup commits

# ──────────────────────────────────────────────────────────────
# Editors
# ──────────────────────────────────────────────────────────────

brew install neovim
brew install --cask visual-studio-code

# ──────────────────────────────────────────────────────────────
# Terminal multiplexer
# ──────────────────────────────────────────────────────────────

brew install tmux

# ──────────────────────────────────────────────────────────────
# Python (uv - modern Python package manager)
# ──────────────────────────────────────────────────────────────

brew install uv

# ──────────────────────────────────────────────────────────────
# Node.js
# ──────────────────────────────────────────────────────────────

brew install node
brew install fnm          # Fast Node Manager

# ──────────────────────────────────────────────────────────────
# Data & productivity tools
# ──────────────────────────────────────────────────────────────

brew install jq           # JSON processor
brew install yq           # YAML/XML/TOML processor
brew install tldr         # Simplified man pages
brew install tree
brew install wget
brew install curl
brew install httpie       # Better HTTP client
brew install ssh-copy-id
brew install rename
brew install watch
brew install entr         # Run commands when files change

# ──────────────────────────────────────────────────────────────
# Security & networking
# ──────────────────────────────────────────────────────────────

brew install gnupg
brew install openssh
brew install nmap
brew install mtr

# ──────────────────────────────────────────────────────────────
# Container tools
# ──────────────────────────────────────────────────────────────

brew install docker
brew install docker-compose
brew install lazydocker   # TUI for docker
brew install kubectl
brew install k9s          # TUI for kubernetes
brew install helm

# ──────────────────────────────────────────────────────────────
# Fonts (Nerd Fonts - needed for icons in eza, p10k, etc.)
# ──────────────────────────────────────────────────────────────

brew install --cask font-meslo-lg-nerd-font
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-fira-code-nerd-font

# ──────────────────────────────────────────────────────────────
# GUI Applications (Casks)
# ──────────────────────────────────────────────────────────────

brew install --cask iterm2
brew install --cask obsidian
brew install --cask raycast        # Spotlight replacement
brew install --cask rectangle      # Window management
brew install --cask alt-tab        # Better alt-tab
brew install --cask vlc
brew install --cask the-unarchiver
brew install --cask 1password      # (or your preferred password manager)

# ──────────────────────────────────────────────────────────────
# AI / Claude
# ──────────────────────────────────────────────────────────────

# Claude Code CLI (installed via npm)
npm install -g @anthropic-ai/claude-code 2>/dev/null || echo "Install Claude Code manually: npm install -g @anthropic-ai/claude-code"

# ──────────────────────────────────────────────────────────────
# Post-install setup
# ──────────────────────────────────────────────────────────────

# Set up fzf key bindings and completion
$(brew --prefix)/opt/fzf/install --all --no-bash --no-fish 2>/dev/null || true

# Initialize zoxide database
zoxide init zsh >/dev/null 2>&1 || true

# Add zsh to allowed shells and set as default
if ! grep -q "$(brew --prefix)/bin/zsh" /etc/shells; then
    echo "$(brew --prefix)/bin/zsh" | sudo tee -a /etc/shells
fi
chsh -s "$(brew --prefix)/bin/zsh" 2>/dev/null || echo "Run: chsh -s $(brew --prefix)/bin/zsh"

# Git LFS setup
git lfs install

# Cleanup
brew cleanup

echo ""
echo "==> Homebrew setup complete!"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal (or run: exec zsh)"
echo "  2. Run 'p10k configure' to set up your Powerlevel10k prompt"
echo "  3. In iTerm2: Set font to 'MesloLGS Nerd Font' in Preferences > Profiles > Text"
echo "  4. Set OBSIDIAN_VAULT in .exports to your vault path"
echo "  5. Run 'tmux' and press prefix + I to install tmux plugins"
