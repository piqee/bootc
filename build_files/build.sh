#!/bin/bash

set -ouex pipefail

dnf5 install -y --skip-unavailable tmux btop fastfetch fuzzel foot thunar gnome-software lxappearance swaybg 
dnf5 install -y --skip-unavailable \
    wlr-randr \
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
    qt6ct \
    # sound
    wireplumber \
    pipewire \
    pamixer \
    pulseaudio-utils 

dnf5 -y copr enable atim/starship
dnf5 -y copr enable scottames/ghostty

dnf5 -y install starship
dnf5 -y install ghostty

dnf5 -y copr disable atim/starship
dnf5 -y copr disable scottames/ghostty

systemctl enable podman.socket
