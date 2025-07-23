#!/bin/bash

set -ouex pipefail

mkdir -p /root/.gnupg
chmod 700 /root/.gnupg

dnf5 install -y --skip-unavailable tmux btop fastfetch fuzzel foot thunar gnome-software lxappearance swaybg 
dnf5 install -y --skip-unavailable \
    river \
    waybar \
    wlroots \
    xdg-desktop-portal-wlr \
    sddm \
    sddm-theme-maldives \
    foot \
    brightnessctl \
    swayidle \
    swaylock \
    grim \
    slurp \
    wl-clipboard \
    adw-gtk3-theme \
    gnome-themes-extra \
    adwaita-qt5 \
    adwaita-qt6 \
    qt5-qtconfiguration \
    qt5ct \
    qt6ct

dnf5 -y copr enable atim/starship
dnf5 -y install starship

dnf5 -y copr disable atim/starship

systemctl enable podman.socket
