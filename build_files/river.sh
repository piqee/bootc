#!/bin/bash

set -ouex pipefail

echo "Создание файла сессии River Wayland для SDDM..."

RIVER_SESSION_DIR="/usr/share/wayland-sessions"
RIVER_SESSION_FILE="$RIVER_SESSION_DIR/river.desktop"

# Создаем директорию, если она не существует
mkdir -p "$RIVER_SESSION_DIR"

if [ ! -f "$RIVER_SESSION_FILE" ]; then
    echo "[Desktop Entry]" | tee "$RIVER_SESSION_FILE" > /dev/null
    echo "Name=River" | tee -a "$RIVER_SESSION_FILE" > /dev/null
    echo "Comment=A dynamic tiling Wayland compositor" | tee -a "$RIVER_SESSION_FILE" > /dev/null
    echo "Exec=/usr/bin/river" | tee -a "$RIVER_SESSION_FILE" > /dev/null # Убедитесь, что путь к исполняемому файлу River верный
    echo "Type=Application" | tee -a "$RIVER_SESSION_FILE" > /dev/null
    echo "Keywords=tiling;wayland;compositor;" | tee -a "$RIVER_SESSION_FILE" > /dev/null
    echo "DesktopNames=River" | tee -a "$RIVER_SESSION_FILE" > /dev/null
    echo "NoDisplay=false" | tee -a "$RIVER_SESSION_FILE" > /dev/null
    echo "Создан файл сессии River: $RIVER_SESSION_FILE."
    echo "Примечание: Убедитесь, что сам River Wayland-композитор установлен в вашей системе."
else
    echo "Файл сессии River уже существует: $RIVER_SESSION_FILE. Пропускаем создание."
fi
