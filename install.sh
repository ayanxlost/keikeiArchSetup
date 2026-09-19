#!/bin/bash

set -e

echo "==> Updating system..."
sudo pacman -Syu

echo "==> Installing required tools..."
sudo pacman -S --needed git base-devel

# Install yay if it isn't already installed
if ! command -v yay &> /dev/null; then
    echo "==> Installing yay..."

    tmpdir=$(mktemp -d)

    git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
    cd "$tmpdir/yay"
    makepkg -si --noconfirm

    cd -
    rm -rf "$tmpdir"
fi

echo "==> Installing official Arch packages..."

mapfile -t PACMAN_PACKAGES < <(
    grep -vE '^\s*(#|$)' pkglist.txt
)

sudo pacman -S --needed "${PACMAN_PACKAGES[@]}"

echo "==> Installing AUR packages..."

mapfile -t AUR_PACKAGES < <(
    grep -vE '^\s*(#|$)' aurpkglist.txt
)

yay -S --needed "${AUR_PACKAGES[@]}"

echo "==> Package installation complete!"
