#!/bin/bash
set -ouex pipefail

 echo "Настройка файла конфигурации SDDM (/etc/sddm.conf)..."

SDDM_CONF="/etc/sddm.conf"

# Создаем файл конфигурации, если он не существует
if [ ! -f "$SDDM_CONF" ]; then
    echo "[Theme]" | sudo tee "$SDDM_CONF" > /dev/null
    echo "Current=breeze" | sudo tee -a "$SDDM_CONF" > /dev/null
    echo "" | sudo tee -a "$SDDM_CONF" > /dev/null  
    echo "[Autologin]" | sudo tee -a "$SDDM_CONF" > /dev/null
    echo "[Wayland]" | sudo tee -a "$SDDM_CONF" > /dev/null
    echo "[X11]" | sudo tee -a "$SDDM_CONF" > /dev/null
    echo "[General]" | sudo tee -a "$SDDM_CONF" > /dev/null
    echo "Создан базовый файл $SDDM_CONF."
fi
