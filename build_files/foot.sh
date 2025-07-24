#!/bin/bash
set -e

mkdir -p /etc/skel/.config/foot/

cat > /etc/skel/.config/foot/foot.ini << 'EOF'
# -*- conf -*-


#shell=$SHELL (if set, otherwise user's default shell from /etc/passwd)
#term=foot (or xterm-256color if built with -Dterminfo=disabled)
#login-shell=no

app-id=foot # globally set wayland app-id. Default values are "foot" and "footclient" for desktop and server mode
title=foot
locked-title=no

font=monospace:size=16
#font-bold=<bold variant of regular font>
#font-italic=<italic variant of regular font>
# font-bold-italic=<bold+italic variant of regular font>
 font-size-adjustment=0.5
# line-height=<font metrics>
 letter-spacing=0
 horizontal-letter-offset=0
 vertical-letter-offset=0
# underline-offset=<font metrics>
# underline-thickness=<font underline thickness>
# strikeout-thickness=<font strikeout thickness>
 box-drawings-uses-font-glyphs=no
 dpi-aware=no
 gamma-correct-blending=no

# initial-window-size-pixels=700x500  # Or,
# initial-window-size-chars=<COLSxROWS>
# initial-window-mode=windowed
# pad=0x0                             # optionally append 'center'
# resize-by-cells=yes
# resize-keep-grid=yes
# resize-delay-ms=100

# bold-text-in-bright=no
# word-delimiters=,│`|:"'()[]{}<>
# selection-target=primary
# workers=<number of logical CPUs>
# utmp-helper=/usr/lib/utempter/utempter  # When utmp backend is ‘libutempter’ (Linux)
# utmp-helper=/usr/libexec/ulog-helper    # When utmp backend is ‘ulog’ (FreeBSD)

[environment]
# name=value

[security]
# osc52=enabled  # disabled|copy-enabled|paste-enabled|enabled

[bell]
# system=yes
# urgent=no
# notify=no
# visual=no
# command=
# command-focused=no

[desktop-notifications]
# command=notify-send --wait --app-name ${app-id} --icon ${app-id} --category ${category} --urgency ${urgency} --expire-time ${expire-time} --hint STRING:image-path:${icon} --hint BOOLEAN:suppress-sound:${muted} --hint STRING:sound-name:${sound-name} --replace-id ${replace-id} ${action-argument} --print-id -- ${title} ${body}
# command-action-argument=--action ${action-name}=${action-label}
# close=""
# inhibit-when-focused=yes


[scrollback]
# lines=1000
# multiplier=3.0
# indicator-position=relative
# indicator-format=""

[url]
# launch=xdg-open ${url}
# label-letters=sadfjklewcmpgh
# osc8-underline=url-mode
# regex=(((https?://|mailto:|ftp://|file:|ssh:|ssh://|git://|tel:|magnet:|ipfs://|ipns://|gemini://|gopher://|news:)|www\.)([0-9a-zA-Z:/?#@!$&*+,;=.~_%^\-]+|\([]\["0-9a-zA-Z:/?#@!$&'*+,;=.~_%^\-]*\)|\[[\(\)"0-9a-zA-Z:/?#@!$&'*+,;=.~_%^\-]*\]|"[]\[\(\)0-9a-zA-Z:/?#@!$&'*+,;=.~_%^\-]*"|'[]\[\(\)0-9a-zA-Z:/?#@!$&*+,;=.~_%^\-]*')+([0-9a-zA-Z/#@$&*+=~_%^\-]|\([]\["0-9a-zA-Z:/?#@!$&'*+,;=.~_%^\-]*\)|\[[\(\)"0-9a-zA-Z:/?#@!$&'*+,;=.~_%^\-]*\]|"[]\[\(\)0-9a-zA-Z:/?#@!$&'*+,;=.~_%^\-]*"|'[]\[\(\)0-9a-zA-Z:/?#@!$&*+,;=.~_%^\-]*'))

# You can define your own regex's, by adding a section called
# 'regex:<ID>' with a 'regex' and 'launch' key. These can then be tied
# to a key-binding. See foot.ini(5) for details

# [regex:your-fancy-name]
# regex=<a POSIX-Extended Regular Expression>
# launch=<path to script or application> ${match}
#
# [key-bindings]
# regex-launch=[your-fancy-name] Control+Shift+q
# regex-copy=[your-fancy-name] Control+Alt+Shift+q

[cursor]
# style=block
# color=<inverse foreground/background>
# blink=no
# blink-rate=500
# beam-thickness=1.5
# underline-thickness=<font underline thickness>

[mouse]
# hide-when-typing=no
# alternate-scroll-mode=yes

[touch]
# long-press-delay=400

[colors]
alpha=0.95
alpha-mode=default # Can be `default`, `matching` or `all`
background=242424
foreground=ffffff
flash=7f7f00
flash-alpha=0.5
EOF
