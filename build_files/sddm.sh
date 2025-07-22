#!/bin/bash
set -ouex pipefail

echo "Настройка файла конфигурации SDDM (/etc/sddm.conf)..."

SDDM_CONF="/etc/sddm.conf"

if [ ! -f "$SDDM_CONF" ]; then
  echo "[Theme]" | tee "$SDDM_CONF" > /dev/null
  echo "Current=breeze" | tee -a "$SDDM_CONF" > /dev/null
  echo "" | tee -a "$SDDM_CONF" > /dev/null
  echo "[Autologin]" | tee -a "$SDDM_CONF" > /dev/null
  echo "[Wayland]" | tee -a "$SDDM_CONF" > /dev/null
  echo "[X11]" | tee -a "$SDDM_CONF" > /dev/null
  echo "[General]" | tee -a "$SDDM_CONF" > /dev/null
  echo "Создан базовый файл $SDDM_CONF."
fi
