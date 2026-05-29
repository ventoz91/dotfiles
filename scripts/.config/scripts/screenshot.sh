#!/bin/bash
mkdir -p ~/Pictures/Screenshots

CHOICE=$(printf "  Region\n  Fullscreen\n  Active Window" | \
    rofi -dmenu -p "Screenshot" -i \
    -theme-str 'listview { lines: 3; } window { width: 280px; }')

[[ -z "$CHOICE" ]] && exit 0

sleep 0.2

FILE="$HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"

case "$CHOICE" in
    *Region*)
        REGION=$(slurp -d) || exit 0
        grim -g "$REGION" - | tee "$FILE" | wl-copy
        ;;
    *Fullscreen*)
        grim - | tee "$FILE" | wl-copy
        ;;
    *Active*)
        GEOM=$(hyprctl activewindow -j | python3 -c "
import json, sys
w = json.load(sys.stdin)
x, y = w['at']
wd, ht = w['size']
print(f'{x},{y} {wd}x{ht}')
")
        grim -g "$GEOM" - | tee "$FILE" | wl-copy
        ;;
esac

notify-send -i "$FILE" "Screenshot saved" "$(basename "$FILE")"
