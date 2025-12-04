#!/bin/bash

set -euo pipefail

install_package() {
  sudo apt install -y $1
}

sudo apt update -y

install_package vim

# Base packages
# install_package xorg
# install_package lightdm
# install_package i3-wm
#
install_package alacritty

# Dev tools
install_package python3.13
install_package g++
install_package build-essential
install_package git

# Generic utility
install_package tree
install_package htop
install_package xclip
install_package curl
install_package stow
install_package unzip
install_package ripgrep
# install_package vim-gtk3

# Terminal
install_package zsh
install_package tmux

