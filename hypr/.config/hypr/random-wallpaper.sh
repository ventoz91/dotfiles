#!/bin/bash
WALLDIR="$HOME/Pictures/wallpaper"
INTERVAL=1800  # 30 minutes

# Wait for awww daemon to be ready
until awww query &>/dev/null; do sleep 0.5; done

while true; do
    if [ ! -d "$WALLDIR" ] || [ -z "$(ls -A "$WALLDIR" 2>/dev/null)" ]; then
        echo "random-wallpaper: $WALLDIR is missing or empty, waiting..." >&2
        sleep "$INTERVAL"
        continue
    fi

    WALL=$(find "$WALLDIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) | shuf -n 1)

    if [ -n "$WALL" ]; then
        mkdir -p ~/.cache/hypr
        echo "$WALL" > ~/.cache/hypr/current_wallpaper

        awww img "$WALL" \
            --transition-type grow \
            --transition-pos center \
            --transition-duration 1.5 \
            --transition-fps 60
    fi

    sleep "$INTERVAL"
done
