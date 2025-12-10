#!/bin/bash
set -euo pipefail

BREW_DIR="$HOME/homebrew"

# install homebrew (no sudo)
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew into $BREW_DIR ..."
  git clone https://github.com/Homebrew/brew "$BREW_DIR"
fi

# ensure brew is in PATH
eval "$("$BREW_DIR/bin/brew" shellenv)"
grep -q 'homebrew/bin/brew shellenv' ~/.profile || \
  echo 'eval "$($HOME/homebrew/bin/brew shellenv)"' >> ~/.profile

# --- install packages (idempotent) ---
brew install neovim fzf ripgrep
brew install --cask font-iosevka font-jetbrains-mono

# ------------ symlink helper ------------
link() {
  mkdir -p "$(dirname "$2")"      # ensure parent exists
  [ -L "$2" ] && [ "$(readlink "$2")" = "$1" ] && { echo "ok: $2"; return; }
  [ -e "$2" ] && { echo "skip: $2 exists"; return; }
  ln -s "$1" "$2" && echo "linked: $2"
}

# ------------ dotfiles + install paths ------------
INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DF="$INSTALL_DIR/dotfiles"

link "$DF/.gitconfig"          "$HOME/.gitconfig"
link "$DF/nvim.lua"            "$HOME/.config/nvim/init.lua"
link "$DF/.tmux.conf"          "$HOME/.tmux.conf"
link "$DF/.zshrc"              "$HOME/.zshrc"

cp -n "$INSTALL_DIR/other/.netrc" "$HOME/.netrc" 2>/dev/null \
  && echo "copied .netrc" || echo ".netrc exists"

echo "Done"

# --- install fzf-tab

FZFTAB_DIR="$HOME/.zsh/fzf-tab"
FZFTAB_VERSION="v1.2.0"

if [ ! -d "$FZFTAB_DIR/.git" ]; then
  echo "Installing fzf-tab $FZFTAB_VERSION ..."
  git clone --depth 1 --branch "$FZFTAB_VERSION" \
    https://github.com/Aloxaf/fzf-tab "$FZFTAB_DIR"
else
  echo "fzf-tab already installed at $FZFTAB_DIR"
fi
