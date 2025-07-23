#!/bin/bash
set -e

echo "=== Configuring RiverWM ==="

# Создание директории для сессии
mkdir -p /usr/share/wayland-sessions/

# Создание .desktop файла для RiverWM
cat > /usr/share/wayland-sessions/river.desktop << 'EOF'
[Desktop Entry]
Name=River
Comment=Dynamic tiling Wayland compositor
Exec=river
Type=Application
DesktopNames=River
EOF

# Создание базовой конфигурации для пользователя
mkdir -p /etc/skel/.config/river/

# Копирование вашей конфигурации RiverWM (исправленная)
cat > /etc/skel/.config/river/init << 'EOF'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            init                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 

EOF

