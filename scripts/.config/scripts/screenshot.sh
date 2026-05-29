#!/bin/bash
mkdir -p ~/Pictures/Screenshots
FILE="$HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"

grim -g "$(slurp -d)" - | tee "$FILE" | wl-copy && \
    notify-send -i "$FILE" "Screenshot saved" "$(basename "$FILE")"
