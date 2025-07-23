#!/bin/bash
set -e

echo "=== Configuring SDDM ==="

# Создание директории для конфигурации SDDM
mkdir -p /etc/sddm.conf.d/

# Создание файла темы
cat > /etc/sddm.conf.d/10-theme.conf << 'EOF'
[Theme]
Current=maldives
CursorTheme=breeze
Font=Noto Sans Mono
EOF

# Создание основной конфигурации
cat > /etc/sddm.conf.d/20-general.conf << 'EOF'
[General]
GreeterEnvironment=QTWEBENGINE_CHROMIUM_FLAGS=--disable-gpu
Numlock=on

[Wayland]
CompositorCommand=river

[X11]
ServerArguments=-dpi 96
EOF

# Установка правильных прав доступа
chmod 644 /etc/sddm.conf.d/*.conf

# Включение SDDM сервиса
systemctl enable sddm

echo "=== SDDM configuration completed ==="
