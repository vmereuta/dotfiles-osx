# ~/.zprofile - Login shell setup (sourced once on login, before .zshrc)

# ──────────────────────────────────────────────────────────────
# Homebrew
# ──────────────────────────────────────────────────────────────

# Apple Silicon
if [ -f "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
# Intel Mac
elif [ -f "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# ──────────────────────────────────────────────────────────────
# PATH
# ──────────────────────────────────────────────────────────────

# GNU coreutils (prefer over macOS builtins)
if command -v brew &>/dev/null; then
    brew_prefix="$(brew --prefix)"
    for gnubin in "${brew_prefix}/opt/"*/libexec/gnubin; do
        export PATH="${gnubin}:${PATH}"
    done
    for gnuman in "${brew_prefix}/opt/"*/libexec/gnuman; do
        export MANPATH="${gnuman}:${MANPATH}"
    done
fi

# User binaries
export PATH="${HOME}/bin:${HOME}/.local/bin:${PATH}"

# uv / Python
export PATH="${HOME}/.local/bin:${PATH}"

# ──────────────────────────────────────────────────────────────
# Load user's custom PATH additions
# ──────────────────────────────────────────────────────────────

[ -r "${HOME}/.path" ] && source "${HOME}/.path"
