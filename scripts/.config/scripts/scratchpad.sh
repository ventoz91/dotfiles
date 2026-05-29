#!/bin/bash
if ! hyprctl clients -j | grep -q '"class": "scratch-term"'; then
    hyprctl dispatch exec "[workspace special:scratch silent] kitty --class scratch-term"
    sleep 0.3
fi
hyprctl dispatch togglespecialworkspace scratch
