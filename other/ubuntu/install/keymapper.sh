#!/bin/bash

set -euo pipefail

install_package() {
  sudo apt install -y $1
}

KEYMAPPER_PACKAGE=/tmp/keymapper.deb
curl -fsSL -o $KEYMAPPER_PACKAGE https://github.com/houmain/keymapper/releases/download/4.12.1/keymapper-4.12.1-Linux-x86_64.deb
[ "$(shasum -a 256 $KEYMAPPER_PACKAGE | awk '{print $1}')" = "a77a58e0eadb81a245065de992f855c6cfdd244300c0eb64f3daf94412998085" ] && echo "Verified package" || exit 1
install_package $KEYMAPPER_PACKAGE
sudo systemctl enable keymapperd
