#!/bin/bash
if ! hyprctl clients -j | grep -q '"class": "dn-focus-term"'; then
    hyprctl dispatch exec "[workspace special:focus silent] kitty --class dn-focus-term -e $HOME/.local/bin/dn focus"
    sleep 0.3
fi
hyprctl dispatch togglespecialworkspace focus
