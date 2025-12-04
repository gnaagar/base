#!/bin/bash
set -euo pipefail

INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

LOCAL_INSTALL_DIR="$HOME/.local/bin"
TMP_DIR="/tmp/setup/$(date +"%Y%m%d%H%M%S")"
FONTS_DIR="$HOME/Library/Fonts"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

ARCH="$(uname -m)"   # arm64 or x86_64 on mac

NVIM_VERSION='v0.11.0'
FZF_VERSION='v0.67.0'
OMZ_COMMIT_HASH="f8022980a3423f25e3d5e1b6a60d2372a2ba006b"
FZF_TAB_VERSION='v1.2.0'

mkdir -p "$LOCAL_INSTALL_DIR" "$TMP_DIR" "$FONTS_DIR"

install_fzf() {
  if command -v fzf >/dev/null; then
    return
  fi

  if command -v brew >/dev/null; then
    brew install fzf
    return
  fi

  local fzf_dir="$TMP_DIR/fzf"
  git clone --depth 1 --branch "$FZF_VERSION" https://github.com/junegunn/fzf.git "$fzf_dir"
  "$fzf_dir/install" --bin
  mv "$fzf_dir/bin/fzf" "$LOCAL_INSTALL_DIR/"
  mv "$fzf_dir/shell/"*.zsh "$LOCAL_INSTALL_DIR/"
}

install_nvim() {
  if command -v nvim >/dev/null; then
    return
  fi

  local pkg_url
  if [ "$ARCH" = "arm64" ]; then
    pkg_url="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-macos-arm64.tar.gz"
  else
    pkg_url="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-macos-x86_64.tar.gz"
  fi

  curl -fsSL -o "$TMP_DIR/nvim.tar.gz" "$pkg_url"
  mkdir -p "$TMP_DIR/nvim"
  tar -xzf "$TMP_DIR/nvim.tar.gz" -C "$TMP_DIR/nvim"

  # extracted structure is "nvim-macos-*/"
  local extracted_dir
  extracted_dir="$(find "$TMP_DIR/nvim" -maxdepth 1 -type d -name "nvim-*")"

  mkdir -p "$HOME/.local"
  rsync -a "$extracted_dir/" "$HOME/.local/"
}

install_omz() {
  if [ -d "$HOME/.oh-my-zsh" ]; then
    return
  fi

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/$OMZ_COMMIT_HASH/tools/install.sh)" "" --unattended
  rm -f "$HOME/.zshrc"
}

install_fzf_tab() {
  local plugin_dir="$ZSH_CUSTOM/plugins/fzf-tab"
  if [ -d "$plugin_dir" ]; then
    return
  fi
  git clone --branch "$FZF_TAB_VERSION" https://github.com/Aloxaf/fzf-tab "$plugin_dir"
}

install_font_iosevka() {
  if ls "$FONTS_DIR" | grep -qi "Iosevka"; then
    return
  fi

  local font_url="https://github.com/be5invis/Iosevka/releases/download/v33.2.5/PkgTTF-Iosevka-33.2.5.zip"
  local font_dir="$TMP_DIR/iosevka"

  curl -fsSL -o "$TMP_DIR/iosevka.zip" "$font_url"
  unzip -d "$font_dir" "$TMP_DIR/iosevka.zip"

  mv "$font_dir"/*.ttf "$FONTS_DIR/"
}

install_font_jbmono() {
  if ls "$FONTS_DIR" | grep -qi "JetBrainsMono"; then
    return
  fi

  local font_url="https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip"
  local font_dir="$TMP_DIR/jbmono"

  curl -fsSL -o "$TMP_DIR/jbmono.zip" "$font_url"
  unzip -d "$font_dir" "$TMP_DIR/jbmono.zip"

  mv "$font_dir"/fonts/ttf/*.ttf "$FONTS_DIR/"
}

install_homebrew() {
  homebrew_dir=$HOME/.homebrew
  if [ -d "$homebrew_dir" ]; then
    return
  fi
  mkdir -p $homebrew_dir
  git clone https://github.com/Homebrew/brew $homebrew_dir
}

install_fzf
install_nvim
install_omz
install_fzf_tab
install_font_iosevka
install_font_jbmono
install_homebrew

rm -rf "$TMP_DIR"

## Part 2 : Creating symlinks

make_link() {
  local src="$1"
  local dest="$2"

  # ensure parent dir exists
  mkdir -p "$(dirname "$dest")"

  # if dest exists
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    # if it is already the correct symlink
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
      echo "skipped: $dest"
      return
    fi

    # exists but not the correct link
    echo "exists (different): $dest"
    return
  fi

  ln -s "$src" "$dest"
  echo "linked: $dest"
}

DF=$INSTALL_DIR/dotfiles

make_link $DF/.zshenv $HOME/.zshenv
make_link $DF/.gitconfig $HOME/.gitconfig

make_link $DF/.config/zsh/.zshrc $HOME/.config/zsh/.zshrc
make_link $DF/.config/zsh/custom_post.zsh $HOME/.config/zsh/custom_post.zsh
make_link $DF/.config/zsh/custom_pre.zsh $HOME/.config/zsh/custom_pre.zsh
make_link $DF/.config/zsh/custom_pre.zsh $HOME/.config/zsh/custom_pre.zsh
make_link $DF/.config/zsh/fv.zsh $HOME/.config/zsh/fv.zsh
make_link $DF/.config/zsh/.fvlist $HOME/.config/zsh/.fvlist

make_link $DF/.vim/colors/xv3_light.vim $HOME/.vim/colors/xv3_light.vim
make_link $DF/.vim/custom.vim $HOME/.vim/custom.vim
make_link $DF/.vim/filetype.vim $HOME/.vim/filetype.vim
make_link $DF/.vim/status.vim $HOME/.vim/status.vim
make_link $DF/.vim/util.vim $HOME/.vim/util.vim
make_link $DF/.vim/vimrc $HOME/.vim/vimrc

make_link $DF/.config/nvim/init.lua $HOME/.config/nvim/init.lua
make_link $DF/.config/nvim/lua/config/lazy.lua $HOME/.config/nvim/lua/config/lazy.lua
make_link $DF/.config/nvim/lua/plugins/base.lua $HOME/.config/nvim/lua/plugins/base.lua
make_link $DF/.config/nvim/lua/plugins/cmp.lua $HOME/.config/nvim/lua/plugins/cmp.lua

make_link $DF/.config/tmux/tmux.conf $HOME/.config/tmux/tmux.conf

make_link $DF/.local/bin/v $HOME/.local/bin/v
make_link $DF/.local/bin/git-dirst $HOME/.local/bin/git-dirst

cp -n $INSTALL_DIR/other/.netrc ~/.netrc

