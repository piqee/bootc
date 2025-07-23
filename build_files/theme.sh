# #!/usr/bin/env bash
# set -e

# #Dark theme https://github.com/lassekongo83/adw-gtk3
# gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

#!/bin/bash
set -e

echo "=== Setting up dark theme ==="

# Создание конфигурационных файлов для всех пользователей
mkdir -p /etc/skel/.config/gtk-3.0
mkdir -p /etc/skel/.config/gtk-4.0
mkdir -p /etc/skel/.config/qt6ct

# GTK 3 настройки
cat > /etc/skel/.config/gtk-3.0/settings.ini << EOF
[Settings]
gtk-theme-name = adw-gtk3-dark
gtk-icon-theme-name = Adwaita
gtk-cursor-theme-name = Adwaita
gtk-application-prefer-dark-theme = true
EOF

# GTK 4 настройки
cat > /etc/skel/.config/gtk-4.0/settings.ini << EOF
[Settings]
gtk-theme-name = adw-gtk3-dark
gtk-icon-theme-name = Adwaita
gtk-cursor-theme-name = Adwaita
gtk-application-prefer-dark-theme = true
EOF

# Qt6 настройки
cat > /etc/skel/.config/qt6ct/qt6ct.conf << EOF
[Appearance]
style=adwaita-dark
icon_theme=Adwaita
EOF

# Переменные окружения
cat >> /etc/environment << EOF
GTK_THEME=adw-gtk3-dark
QT_STYLE_OVERRIDE=adwaita-dark
QT_QPA_PLATFORMTHEME=qt6ct
EOF

# Настройка starship (для всех пользователей)
mkdir -p /etc/skel/.config

cat > /etc/skel/.config/starship.toml << 'EOF'
# Inserts a blank line between shell prompts
add_newline = true

# Replace the "❯" symbol in the prompt with "➜"
[character]
success_symbol = "[➜](bold green)"

# Disable the package module, hiding it from the prompt completely
[package]
disabled = true
EOF

echo "=== Theme and starship setup completed ==="
