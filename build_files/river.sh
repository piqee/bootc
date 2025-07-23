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
cat > /etc/skel/.config/river/init << 'EOF'
#!/bin/sh

# Экспорт переменных окружения для темной темы
export GTK_THEME=adw-gtk3-dark
export GTK_ICON_THEME=Adwaita
export GTK_APPLICATION_PREFER_DARK_THEME=1
export QT_STYLE_OVERRIDE=adwaita-dark
export QT_QPA_PLATFORMTHEME=qt6ct
export XDG_CURRENT_DESKTOP=river
export XDG_SESSION_DESKTOP=river
export XDG_SESSION_TYPE=wayland

# Настройки клавиатуры (универсальные)
riverctl set-repeat 50 300
riverctl keyboard-layout -options grp:alt_shift_toggle us,ru

# Настройки тачпада (универсальные, могут потребовать корректировки)
riverctl input-group pointer natural-scroll enabled
riverctl input-group pointer tap enabled
riverctl input-group pointer events enabled

# Основные привязки клавиш
# Запуск терминала
riverctl map normal Super+Return spawn foot

# Лаунчер приложений
riverctl map normal Super+d spawn "fuzzel --show=apps"

# Закрытие окна
riverctl map normal Super+Q close

# Выход из RiverWM
riverctl map normal Super+Shift+E exit

# Навигация между окнами
riverctl map normal Super+j focus-view next
riverctl map normal Super+k focus-view previous

# Перемещение окон в стеке
riverctl map normal Super+Shift+j swap next
riverctl map normal Super+Shift+k swap previous

# Фокусировка на разных мониторах
riverctl map normal Super+period focus-output next
riverctl map normal Super+comma focus-output previous

# Отправка окон на другие мониторы
riverctl map normal Super+Shift+period send-to-output next
riverctl map normal Super+Shift+comma send-to-output previous

# Перемещение фокуса наверх стека
riverctl map normal Super+space zoom

# Изменение размеров основной области (rivertile)
riverctl map normal Super+h send-layout-cmd rivertile "main-ratio -0.05"
riverctl map normal Super+l send-layout-cmd rivertile "main-ratio +0.05"

# Изменение количества главных окон (rivertile)
riverctl map normal Super+Shift+h send-layout-cmd rivertile "main-count +1"
riverctl map normal Super+Shift+l send-layout-cmd rivertile "main-count -1"

# Перемещение окон мышью
riverctl map-pointer normal Super BTN_LEFT move-view

# Изменение размера окон мышью
riverctl map-pointer normal Super BTN_RIGHT resize-view

# Переключение плавающего режима мышью
riverctl map-pointer normal Super BTN_MIDDLE toggle-float

# Управление тегами (рабочими столами)
for i in $(seq 1 9); do
  tags=$((1 << ($i - 1)))

  # Super+[1-9] для фокусировки на теге
  riverctl map normal Super+$i set-focused-tags $tags

  # Super+Shift+[1-9] для перемещения окна на тег
  riverctl map normal Super+Shift+$i set-view-tags $tags

  # Super+Control+[1-9] для переключения фокуса тега
  riverctl map normal Super+Control+$i toggle-focused-tags $tags

  # Super+Shift+Control+[1-9] для переключения тега окна
  riverctl map normal Super+Shift+Control+$i toggle-view-tags $tags
done

# Super+0 для фокусировки на всех тегах
all_tags=$(((1 << 32) - 1))
riverctl map normal Super+0 set-focused-tags $all_tags
riverctl map normal Super+Shift+0 set-view-tags $all_tags

# Переключение плавающего режима
riverctl map normal Super+space toggle-float

# Переключение полноэкранного режима
riverctl map normal Super+f toggle-fullscreen

# Изменение ориентации layout
riverctl map normal Super+Up send-layout-cmd rivertile "main-location top"
riverctl map normal Super+Right send-layout-cmd rivertile "main-location right"
riverctl map normal Super+Down send-layout-cmd rivertile "main-location bottom"
riverctl map normal Super+Left send-layout-cmd rivertile "main-location left"

# Режим passthrough
riverctl declare-mode passthrough
riverctl map normal Super+F11 enter-mode passthrough
riverctl map passthrough Super+F11 enter-mode normal

# Медиа-клавиши для normal и locked режимов
for mode in normal locked; do
  # Управление громкостью
  riverctl map $mode None XF86AudioRaiseVolume spawn 'pamixer -i 5'
  riverctl map $mode None XF86AudioLowerVolume spawn 'pamixer -d 5'
  riverctl map $mode None XF86AudioMute spawn 'pamixer --toggle-mute'

  # Управление медиаплеером
  riverctl map $mode None XF86AudioMedia spawn 'playerctl play-pause'
  riverctl map $mode None XF86AudioPlay spawn 'playerctl play-pause'
  riverctl map $mode None XF86AudioPrev spawn 'playerctl previous'
  riverctl map $mode None XF86AudioNext spawn 'playerctl next'

  # Управление яркостью
  riverctl map $mode None XF86MonBrightnessUp spawn 'brightnessctl s +5%'
  riverctl map $mode None XF86MonBrightnessDown spawn 'brightnessctl s 5%-'
  
  # Скриншоты
  riverctl map $mode None Print spawn 'grim -g "$(slurp -d)" ~/Pictures/screenshot_selection_$(date +%Y%m%d_%H%M%S).png'
done

# Установка повтора клавиш
riverctl set-repeat 50 300

# Правила для окон
# Окна с app-id, начинающимся на "float", будут плавающими
riverctl rule-add -app-id 'float*' float

# Установка стандартного layout и его запуск
riverctl default-layout rivertile
rivertile -view-padding 4 -outer-padding 4 &

# Фокус следует за курсором
riverctl focus-follows-cursor always

# Блокировка экрана
riverctl map normal Super+Escape spawn "swaylock -f"

# Управление яркостью с модификатором
riverctl map normal Super+XF86MonBrightnessDown spawn "brightnessctl set 5%-"
riverctl map normal Super+XF86MonBrightnessUp spawn "brightnessctl set +5%"

# Автозапуск приложений и сервисов
# Фон (замените путь на существующий в системе)
# riverctl spawn "swaybg -i '/usr/share/backgrounds/f39/default-dark.png' -m fill"

# Политика доступа
riverctl spawn "/usr/libexec/xfce-polkit"

# Менеджер сети
riverctl spawn "nm-applet --indicator"

# Масштабирование (для HiDPI экранов)
# riverctl spawn "wlr-randr --output eDP-1 --scale 1.2"

# Активация среды D-Bus
riverctl spawn "dbus-update-activation-environment --systemd --all"

# Демон ключей GNOME
riverctl spawn "gnome-keyring-daemon --start --components=secrets"
EOF

# Сделать конфиг исполняемым
chmod +x /etc/skel/.config/river/init

# Создание конфигурации Waybar из вашего файла (из Knowledge Base)
mkdir -p /etc/skel/.config/waybar/

# Конфигурация Waybar (config.jsonc)
cat > /etc/skel/.config/waybar/config.jsonc << 'EOF'
// -*- mode: jsonc -*-
{
    "layer": "top", // Waybar at top layer
    // "position": "bottom", // Waybar position (top|bottom|left|right)
    "height": 33, // Waybar height (to be removed for auto height)
    // "width": 1280, // Waybar width
    "spacing": 4, // Gaps between modules (4px)
    // Choose the order of the modules
    "modules-left": [
        "river/tags",
        "river/mode",
        "sway/scratchpad"
    ],
    "modules-center": [
        "river/window"
    ],
    "modules-right": [
        "idle_inhibitor",
        "pulseaudio",
        "network",
        "power-profiles-daemon",
        "cpu",
        "memory",
        "temperature",
        "backlight",
        "battery",
        "clock",
        "tray"
    ],
    // Modules configuration
    "river/mode": {
        "format": "<span style=\"italic\">{}</span>"
    },
    "sway/scratchpad": {
        "format": "{icon} {count}",
        "show-empty": false,
        "format-icons": ["", ""],
        "tooltip": true,
        "tooltip-format": "{app}: {title}"
    },
    "idle_inhibitor": {
        "format": "{icon}",
        "format-icons": {
            "activated": "",
            "deactivated": ""
        }
    },
    "tray": {
        // "icon-size": 21,
        "spacing": 5
    },
    "clock": {
        // "timezone": "America/New_York",
        "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
        "format-alt": "{:%Y-%m-%d}"
    },
    "cpu": {
        "format": "{usage}% ",
        "tooltip": false
    },
    "memory": {
        "format": "{}% "
    },
    "temperature": {
        // "thermal-zone": 2,
        // "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
        "critical-threshold": 80,
        // "format-critical": "{temperatureC}°C {icon}",
        "format": "{temperatureC}°C {icon}",
        "format-icons": ["", "", ""]
    },
    "backlight": {
        // "device": "acpi_video1",
        "format": "{percent}% {icon}",
        "format-icons": ["🌑", "🌘", "🌗", "🌖", "🌕"]
    },
    "battery": {
        "states": {
            // "good": 95,
            "warning": 30,
            "critical": 15
        },
        "format": "{capacity}% {icon}",
        "format-full": "{capacity}% {icon}",
        "format-charging": "{capacity}% ",
        "format-plugged": "{capacity}% ",
        "format-alt": "{time} {icon}",
        // "format-good": "", // An empty format will hide the module
        // "format-full": "",
        "format-icons": ["", "", "", "", ""]
    },
    "battery#bat2": {
        "bat": "BAT2"
    },
    "power-profiles-daemon": {
      "format": "{icon}",
      "tooltip-format": "Power profile: {profile}\nDriver: {driver}",
      "tooltip": true,
      "format-icons": {
        "default": "",
        "performance": "",
        "balanced": "",
        "power-saver": ""
      }
    },
    "network": {
        // "interface": "wlp2*", // (Optional) To force the use of this interface
        "format-wifi": "{essid} ({signalStrength}%) ",
        "format-ethernet": "{ipaddr}/{cidr} ",
        "tooltip-format": "{ifname} via {gwaddr} ",
        "format-linked": "{ifname} (No IP) ",
        "format-disconnected": "Disconnected ⚠",
        "format-alt": "{ifname}: {ipaddr}/{cidr}"
    },
    "pulseaudio": {
        // "scroll-step": 1, // %, can be a float
        "format": "{volume}% {icon} {format_source}",
        "format-bluetooth": "{volume}% {icon} {format_source}",
        "format-bluetooth-muted": " {icon} {format_source}",
        "format-muted": " {format_source}",
        "format-source": "{volume}% ",
        "format-source-muted": "",
        "format-icons": {
            "headphone": "",
            "hands-free": "",
            "headset": "",
            "phone": "",
            "portable": "",
            "car": "",
            "default": ["", "", ""]
        },
        "on-click": "pavucontrol"
    }
}
EOF

# Стиль Waybar (style.css)
cat > /etc/skel/.config/waybar/style.css << 'EOF'
* {
    font-family: 'Noto Sans Mono', 'Font Awesome 6 Free', 'Font Awesome 6 Brands', monospace;
    font-size: 13px;
}
@define-color inactive_module_color #a9a9a9;
window#waybar {
    background-color: rgba(43, 48, 59, 0.8);
    border-color: rgba(100, 114, 125, 0.5);
    border-style: solid;
    color: #ffffff;
    transition-property: background-color;
    transition-duration: .5s;
}
window#waybar:not(.bottom):not(.left):not(.right) {
    border-bottom-width: 2px;
}
window#waybar.bottom {
    border-top-width: 2px;
}
window#waybar.hidden {
    opacity: 0.2;
}
button {
    /* reset all builtin/theme styles */
    all: unset;
    /* Restore some properties */
    min-height: 24px;
    min-width: 16px;
    padding: 0 10px;
    transition: all 200ms ease-out;
}
/* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
button:hover {
    background: inherit;
}
window#waybar:not(.bottom):not(.left):not(.right) button:hover{
    box-shadow: inset 0 -2px;
}
window#waybar.bottom button:hover {
    box-shadow: inset 0 2px;
}
/*
 * Common module rules
 */
.modules-left > widget > label,
.modules-center > widget > label,
.modules-right > widget > label {
    color: inherit;
    margin: 0;
    padding: 0 10px;
}
.modules-left > widget > box,
.modules-center > widget > box,
.modules-right > widget > box {
    color: inherit;
    margin: 0;
    padding: 0;
}
/* If the leftmost module is a box, omit left margin and padding */
.modules-left > widget:first-child > box {
    margin-left: 0;
    padding-left: 0;
}
/* If the rightmost module is a box, omit right margin and padding */
.modules-right > widget:last-child > box {
    margin-right: 0;
    padding-right: 0;
}
/*
 * Draw module underlines
 */
window#waybar:not(.bottom):not(.left):not(.right) .modules-left > widget > label,
window#waybar:not(.bottom):not(.left):not(.right) .modules-center > widget > label,
window#waybar:not(.bottom):not(.left):not(.right) .modules-right > widget > label {
    box-shadow: inset 0 -2px;
}
window#waybar.bottom .modules-left > widget > label,
window#waybar.bottom .modules-center > widget > label,
window#waybar.bottom .modules-right > widget > label {
    box-shadow: inset 0 2px;
}
window#waybar #window {
    box-shadow: none;
}
#workspaces button {
    background-color: transparent;
    color: #ffffff;
}
#workspaces button:hover {
    background: rgba(0, 0, 0, 0.2);
}
#workspaces button.focused {
    background-color: #64727D;
}
window#waybar:not(.bottom):not(.left):not(.right) #workspaces button.focused {
    box-shadow: inset 0 -2px;
}
window#waybar.bottom #workspaces button.focused {
    box-shadow: inset 0 2px;
}
#workspaces button.urgent {
    background-color: #eb4d4b;
}
#mode {
    background-color: #64727D;
}
window#waybar:not(.bottom):not(.left):not(.right) #mode {
    box-shadow: inset 0 -2px;
}
window#waybar.bottom #mode {
    box-shadow: inset 0 2px;
}
#image {
    margin: 0;
    padding: 0 10px;
}
#battery.charging, #battery.plugged {
    color: #32cd32;
}
@keyframes blink {
    to {
        background-color: #ffffff;
        color: #000000;
    }
}
#battery.critical:not(.charging) {
    color: #f53c3c;
    animation-name: blink;
    animation-duration: 0.5s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
}
#network.disconnected,
#pulseaudio.muted,
#wireplumber.muted {
    color: @inactive_module_color;
}
#tray {
    padding: 0 5px;
}
#tray > .passive {
    -gtk-icon-effect: dim;
}
@keyframes needs-attention {
    to {
        background-color: rgba(235, 77, 75, 0.5);
    }
}
#tray > .needs-attention {
    -gtk-icon-effect: highlight;
    animation-name: needs-attention;
    animation-duration: 1s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
    background-color: transparent;
}
#idle_inhibitor {
    color: @inactive_module_color;
}
#idle_inhibitor.activated {
    color: inherit;
}
#mpd.disconnected,
#mpd.paused,
#mpd.stopped {
    color: @inactive_module_color;
}
#cpu.high,
#temperature.critical {
    color: #eb4d4b;
}
#language {
    min-width: 16px;
}
#keyboard-state {
    min-width: 16px;
}
#keyboard-state > label {
    padding: 0 5px;
}
#keyboard-state > label.locked {
    background: rgba(0, 0, 0, 0.2);
}
#scratchpad {
    background: rgba(0, 0, 0, 0.2);
}
#scratchpad.empty {
        background-color: transparent;
}
/*
 * Module colors
 */
#cpu {
    color: #2ecc71;
}
#memory {
    color: #ba55d3;
}
#disk {
    color: #964B00;
}
#backlight {
    color: #90b1b1;
}
#network {
    color: #00bfff;
}
#pulseaudio,
#wireplumber {
    color: #f1c40f;
}
#temperature {
    color: #f0932b;
}
#mpd {
    color: #66cc99;
}
#mpd.paused {
    color: #51a37a;
}
#language {
    color: #00b093;
}
#keyboard-state {
    color: #97e1ad;
}
EOF

# Настройка SDDM для автологина
mkdir -p /etc/sddm.conf.d/

cat > /etc/sddm.conf.d/20-autologin.conf << 'EOF'
[Autologin]
User=user
Session=river.desktop
EOF

chmod 644 /etc/sddm.conf.d/*.conf

echo "=== RiverWM configuration completed ==="
