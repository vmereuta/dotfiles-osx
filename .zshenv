# ~/.zshenv - Always sourced (login, interactive, scripts)
# Keep this minimal - only truly universal env vars

# XDG Base Directory Specification
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_STATE_HOME="${HOME}/.local/state"

# Ensure path arrays do not contain duplicates
typeset -U PATH path
