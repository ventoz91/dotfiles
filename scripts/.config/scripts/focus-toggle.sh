#!/bin/bash
if ! hyprctl clients -j | grep -q '"class": "dn-focus-term"'; then
    # Only pauses the terminal on a genuine crash (non-zero exit) — a normal
    # completed/abandoned session still closes immediately, so this doesn't
    # add an extra keypress to the common path.
    cmd="kitty --class dn-focus-term -e bash -c '$HOME/.local/bin/dn focus || { echo; echo \"dn focus exited with an error — press Enter to close\"; read; }'"
    hyprctl dispatch "hl.dsp.exec_cmd([==[$cmd]==], {workspace=\"special:focus silent\"})"
    sleep 0.3
fi
hyprctl dispatch 'hl.dsp.workspace.toggle_special("focus")'
