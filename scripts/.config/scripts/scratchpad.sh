#!/bin/bash
if ! hyprctl clients -j | grep -q '"class": "scratch-term"'; then
    hyprctl dispatch 'hl.dsp.exec_cmd("kitty --class scratch-term", {workspace="special:scratch silent"})'
    sleep 0.3
fi
hyprctl dispatch 'hl.dsp.workspace.toggle_special("scratch")'
