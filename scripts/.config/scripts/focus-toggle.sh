#!/bin/bash
if ! hyprctl clients -j | grep -q '"class": "dn-focus-term"'; then
    # Only pauses the terminal on a genuine crash (non-zero exit) — a normal
    # completed/abandoned session still closes immediately, so this doesn't
    # add an extra keypress to the common path.
    hyprctl dispatch exec "[workspace special:focus silent] kitty --class dn-focus-term -e bash -c '$HOME/.local/bin/dn focus || { echo; echo \"dn focus exited with an error — press Enter to close\"; read; }'"
    sleep 0.3
fi
hyprctl dispatch togglespecialworkspace focus
