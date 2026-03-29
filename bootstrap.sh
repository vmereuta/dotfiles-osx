#!/usr/bin/env bash

# Bootstrap dotfiles - creates symlinks from ~ to this repo
# Supports both bash and zsh environments

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

git -C "$DOTFILES_DIR" pull origin main 2>/dev/null || git -C "$DOTFILES_DIR" pull origin master 2>/dev/null || true

# Files and directories to symlink directly into ~
SYMLINK_FILES=(
    .aliases
    .bash_profile
    .bashrc
    .editorconfig
    .exports
    .functions
    .gitattributes
    .gitconfig
    .gitignore
    .hushlogin
    .inputrc
    .tmux.conf
    .vimrc
    .wgetrc
    .zprofile
    .zshenv
    .zshrc
)

SYMLINK_DIRS=(
    .vim
)

# Nested configs: source path (relative to dotfiles) -> target path (relative to ~)
NESTED_LINKS=(
    ".config/nvim::.config/nvim"
    ".config/Code/User/settings.json::.config/Code/User/settings.json"
    ".claude/settings.local.json::.claude/settings.local.json"
)

function backup_and_link() {
    local src="$1"
    local dest="$2"

    # Already correctly linked
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        return
    fi

    # Back up existing file/dir (not a symlink pointing elsewhere)
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "  Backing up $(basename "$dest") -> ${dest}.bak"
        mv "$dest" "${dest}.bak"
    fi

    ln -s "$src" "$dest"
    echo "  Linked $(basename "$dest")"
}

function doIt() {
    echo "Linking dotfiles from $DOTFILES_DIR"
    echo ""

    # Symlink top-level files
    echo "==> Dotfiles"
    for file in "${SYMLINK_FILES[@]}"; do
        backup_and_link "$DOTFILES_DIR/$file" "$HOME/$file"
    done

    # Symlink top-level directories
    echo ""
    echo "==> Directories"
    for dir in "${SYMLINK_DIRS[@]}"; do
        backup_and_link "$DOTFILES_DIR/$dir" "$HOME/$dir"
    done

    # Symlink nested configs (ensure parent dirs exist)
    echo ""
    echo "==> Nested configs"
    for entry in "${NESTED_LINKS[@]}"; do
        local src_rel="${entry%%::*}"
        local dest_rel="${entry##*::}"
        local src="$DOTFILES_DIR/$src_rel"
        local dest="$HOME/$dest_rel"

        # Only link if source exists in the repo
        if [ ! -e "$src" ]; then
            echo "  Skipping $src_rel (not in repo)"
            continue
        fi

        mkdir -p "$(dirname "$dest")"
        backup_and_link "$src" "$dest"
    done

    # Install fonts
    echo ""
    echo "==> Fonts"
    if [ -d "$DOTFILES_DIR/fonts" ]; then
        local font_dir="$HOME/Library/Fonts"
        mkdir -p "$font_dir"
        for font in "$DOTFILES_DIR"/fonts/*; do
            local font_name="$(basename "$font")"
            if [ ! -f "$font_dir/$font_name" ]; then
                cp "$font" "$font_dir/"
                echo "  Installed $font_name"
            fi
        done
    fi

    # Ensure vim undo dir exists
    mkdir -p ~/.vim/undo 2>/dev/null || true

    # VSCode settings directory (macOS-specific path)
    if [ -d "$HOME/Library/Application Support/Code/User" ]; then
        local vscode_src="$DOTFILES_DIR/.config/Code/User/settings.json"
        local vscode_dest="$HOME/Library/Application Support/Code/User/settings.json"
        if [ -f "$vscode_src" ]; then
            echo ""
            echo "==> VSCode (macOS)"
            backup_and_link "$vscode_src" "$vscode_dest"
        fi
    fi

    echo ""
    echo "Done! Dotfiles are symlinked."
    echo ""
    echo "Post-install steps:"
    echo "  1. Run 'brew.sh' to install packages (if not done)"
    echo "  2. Restart your terminal (exec zsh)"
    echo "  3. Run 'p10k configure' to set up your prompt"
    echo "  4. In tmux, press Ctrl-a + I to install plugins"
}

if [ "${1:-}" == "--force" ] || [ "${1:-}" == "-f" ]; then
    doIt
else
    read -p "This will symlink dotfiles into your home directory (existing files will be backed up as .bak). Continue? (y/n) " -n 1
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt
    fi
fi
