#!/bin/bash
set -euo pipefail

# ------------ package installer (apt for Debian/Ubuntu) ------------
install_packages() {
  if command -v apt-get >/dev/null 2>&1; then
    # Debian/Ubuntu
    sudo apt-get update
    sudo apt-get install -y neovim fzf ripgrep tree tmux git curl
  elif command -v dnf >/dev/null 2>&1; then
    # Fedora
    sudo dnf install -y neovim fzf ripgrep tree tmux git curl
  elif command -v pacman >/dev/null 2>&1; then
    # Arch
    sudo pacman -S --noconfirm neovim fzf ripgrep tree tmux git curl
  elif command -v zypper >/dev/null 2>&1; then
    # openSUSE
    sudo zypper install -y neovim fzf ripgrep tree tmux git curl
  else
    echo "No supported package manager found (apt/dnf/pacman/zypper)"
    exit 1
  fi
}

# --- install packages ---
echo "Installing packages..."
install_packages

# --- install Neovim plugins (lazy.nvim style) ---
NVIM_DIR="$HOME/.local/share/nvim"
mkdir -p "$NVIM_DIR/lazy/lazy.nvim"
if [ ! -f "$NVIM_DIR/lazy/lazy.nvim/plugin-loader.lua" ]; then
  echo "Installing lazy.nvim..."
  git clone --depth 1 https://github.com/folke/lazy.nvim.git "$NVIM_DIR/lazy/lazy.nvim"
fi

# ------------ symlink helper ------------
link() {
  mkdir -p "$(dirname "$2")"      # ensure parent exists
  [ -L "$2" ] && [ "$(readlink "$2")" = "$1" ] && { echo "ok: $2"; return; }
  [ -e "$2" ] && { echo "skip: $2 exists"; return; }
  ln -s "$1" "$2" && echo "linked: $2"
}

# ------------ dotfiles + install paths ------------
INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DF="$INSTALL_DIR/config"

link "$DF/.gitconfig"          "$HOME/.gitconfig"
link "$DF/nvim.lua"            "$HOME/.config/nvim/init.lua"
link "$DF/.tmux.conf"          "$HOME/.tmux.conf"
link "$DF/.zshrc"              "$HOME/.zshrc"


cp -n "$INSTALL_DIR/other/.netrc" "$HOME/.netrc" 2>/dev/null \
  && echo "copied .netrc" || echo ".netrc exists"

link "$INSTALL_DIR/utils/tz"              "$HOME/.local/bin/tz"

echo "Done"

# --- install fzf-tab ---

FZFTAB_DIR="$HOME/.zsh/fzf-tab"
FZFTAB_VERSION="v1.2.0"

if [ ! -d "$FZFTAB_DIR/.git" ]; then
  echo "Installing fzf-tab $FZFTAB_VERSION ..."
  git clone --depth 1 --branch "$FZFTAB_VERSION" \
    https://github.com/Aloxaf/fzf-tab "$FZFTAB_DIR"
else
  echo "fzf-tab already installed at $FZFTAB_DIR"
fi
