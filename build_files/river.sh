#!/bin/bash

set -ouex pipefail

echo "Создание файла сессии River Wayland для SDDM..."

RIVER_SESSION_DIR="/usr/share/wayland-sessions"
RIVER_SESSION_FILE="$RIVER_SESSION_DIR/river.desktop"

sudo mkdir -p "$RIVER_SESSION_DIR"

if [ ! -f "$RIVER_SESSION_FILE" ]; then
    echo "[Desktop Entry]" | sudo tee "$RIVER_SESSION_FILE" > /dev/null
    echo "Name=River" | sudo tee -a "$RIVER_SESSION_FILE" > /dev/null
    echo "Comment=A dynamic tiling Wayland compositor" | sudo tee -a "$RIVER_SESSION_FILE" > /dev/null
    echo "Exec=/usr/bin/river" | sudo tee -a "$RIVER_SESSION_FILE" > /dev/null # Убедитесь, что путь к исполняемому файлу River верный
    echo "Type=Application" | sudo tee -a "$RIVER_SESSION_FILE" > /dev/null
    echo "Keywords=tiling;wayland;compositor;" | sudo tee -a "$RIVER_SESSION_FILE" > /dev/null
    echo "DesktopNames=River" | sudo tee -a "$RIVER_SESSION_FILE" > /dev/null
    echo "NoDisplay=false" | sudo tee -a "$RIVER_SESSION_FILE" > /dev/null
    echo "Создан файл сессии River: $RIVER_SESSION_FILE."
    echo "Примечание: Убедитесь, что сам River Wayland-композитор установлен в вашей системе."
else
    echo "Файл сессии River уже существует: $RIVER_SESSION_FILE. Пропускаем создание."
fi
