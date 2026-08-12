#!/bin/bash
# Toggle a floating ytui window on a hidden special workspace.
if ! hyprctl clients -j | grep -q '"class": "ytui"'; then
    hyprctl dispatch exec "[workspace special:ytui silent] kitty --class ytui -d /home/trevor/Documents/Projects/ytui -e .venv/bin/python -m ytui"
    sleep 0.3
fi
hyprctl dispatch togglespecialworkspace ytui
