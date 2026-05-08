#!/bin/bash

WALLDIR="$HOME/Pictures/wallpapers"

WALL=$(find "$WALLDIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) | shuf -n 1)

# save current wallpaper for lockscreen sync
echo "$WALL" > ~/.cache/hypr/current_wallpaper

# restart hyprpaper cleanly
pkill hyprpaper
hyprpaper &

sleep 0.3

# apply wallpaper
hyprctl hyprpaper preload "$WALL"
hyprctl hyprpaper wallpaper ",$WALL"
