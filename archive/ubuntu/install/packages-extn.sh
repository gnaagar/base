#!/bin/bash

set -euo pipefail

install_package() {
  sudo apt install -y $1
}

sudo apt update -y

install_package wl-clipboard

# install_package sway
# install_package waybar
# install_package wofi
# install_package lm-sensors
# install_package swaylock

# Image related tools
# install_package grim
# install_package slurp
# install_package imv

# sudo usermod -aG video $USER
# install_package brightnessctl

# KEYMAPPER_PACKAGE=/tmp/keymapper.deb
# curl -fsSL -o $KEYMAPPER_PACKAGE https://github.com/houmain/keymapper/releases/download/5.3.0/keymapper-5.3.0-Linux-x86_64.deb
# [ "$(shasum -a 256 $KEYMAPPER_PACKAGE | awk '{print $1}')" = "ad7edc71c52dba3dbec7a2bcb10eed35956e44f94e07832559fd48ba274a3474" ] && echo "Verified package" || exit 1
# install_package $KEYMAPPER_PACKAGE
# Run this after install:
# sudo systemctl enable keymapperd

# GUI extn.
# install_package i3blocks
# install_package feh
# install_package picom
# install_package rofi
# 
# # Extension
# install_package autorandr
# install_package fonts-firacode
# install_package markdownlint
# install_package ffmpeg
# install_package nodejs
# install_package npm
# install_package libtext-lorem-perl
# install_package obs-studio
# install_package python3-venv

# Problematic
# This one works on gdm
# install_package network-manager-applet

# For utils
install_package python3-pytz
install_package python3-venv
