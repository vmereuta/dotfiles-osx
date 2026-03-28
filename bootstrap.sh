#!/usr/bin/env bash

# Bootstrap dotfiles - syncs configs to home directory
# Supports both bash and zsh environments

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || true

function doIt() {
    # Sync dotfiles
    rsync --exclude ".git/" \
          --exclude ".DS_Store" \
          --exclude "bootstrap.sh" \
          --exclude "brew.sh" \
          --exclude "README.md" \
          --exclude "LICENSE-MIT.txt" \
          --exclude "*.txt" \
          --exclude "*.jar" \
          --exclude "init/" \
          --exclude "nice.itermcolors" \
          -avh --no-perms . ~

    # Create necessary directories
    mkdir -p ~/.vim/undo
    mkdir -p ~/.config/nvim

    # Symlink Neovim config to use our init.lua
    if [ -f ~/.config/nvim/init.lua ] && [ ! -L ~/.config/nvim/init.lua ]; then
        echo "Backing up existing nvim config..."
        mv ~/.config/nvim/init.lua ~/.config/nvim/init.lua.bak
    fi

    # Create VSCode settings directory
    mkdir -p ~/Library/Application\ Support/Code/User 2>/dev/null || true
    mkdir -p ~/.config/Code/User 2>/dev/null || true

    # Source the appropriate shell config
    if [ -n "${ZSH_VERSION:-}" ] || [ "$(basename "$SHELL")" = "zsh" ]; then
        echo "Sourcing zsh config..."
        source ~/.zshrc 2>/dev/null || true
    else
        echo "Sourcing bash config..."
        source ~/.bash_profile 2>/dev/null || true
    fi

    echo ""
    echo "Dotfiles synced successfully!"
    echo ""
    echo "Post-install steps:"
    echo "  1. Run 'brew.sh' to install packages"
    echo "  2. Restart your terminal"
    echo "  3. Run 'p10k configure' to set up your prompt"
    echo "  4. In tmux, press Ctrl-a + I to install plugins"
}

if [ "${1:-}" == "--force" ] || [ "${1:-}" == "-f" ]; then
    doIt
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt
    fi
fi

unset doIt
