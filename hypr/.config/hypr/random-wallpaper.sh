#!/bin/bash
WALLDIR="$HOME/Pictures/wallpaper"
INTERVAL=1800  # 30 minutes

# Wait for swww daemon to be ready
until swww query &>/dev/null; do sleep 0.5; done

while true; do
    WALL=$(find "$WALLDIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) | shuf -n 1)

    if [ -n "$WALL" ]; then
        mkdir -p ~/.cache/hypr
        echo "$WALL" > ~/.cache/hypr/current_wallpaper

        swww img "$WALL" \
            --transition-type grow \
            --transition-pos center \
            --transition-duration 1.5 \
            --transition-fps 60
    fi

    sleep "$INTERVAL"
done
