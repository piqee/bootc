#!/bin/bash

set -ouex pipefail

dnf5 install -y tmux btop fastfetch fuzzel foot grim thunar gnome-software lxappearance \
                swaybg \
                wlr-randr adw-gtk3-theme qt6ct #themes/libs

dnf5 install -y river waybar sddm

dnf5 -y copr enable atim/starship
dnf5 -y install starship

dnf5 -y copr disable atim/starship

systemctl enable podman.socket
