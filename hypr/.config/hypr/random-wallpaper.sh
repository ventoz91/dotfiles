#!/bin/bash

WALLDIR="$HOME/Pictures/wallpaper"

WALL=$(find "$WALLDIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) | shuf -n 1)

[ -z "$WALL" ] && exit 1

mkdir -p ~/.cache/hypr
echo "$WALL" > ~/.cache/hypr/current_wallpaper

hyprctl hyprpaper unload all
hyprctl hyprpaper preload "$WALL"
hyprctl hyprpaper wallpaper "DP-1,$WALL"
hyprctl hyprpaper wallpaper "HDMI-A-1,$WALL"
