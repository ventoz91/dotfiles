#!/bin/bash
if ! hyprctl clients -j | grep -q '"class": "com.github.th-ch.youtube-music"'; then
    hyprctl dispatch 'hl.dsp.exec_cmd("youtube-music", {workspace="special:ytmusic silent"})'
    sleep 0.3
fi
hyprctl dispatch 'hl.dsp.workspace.toggle_special("ytmusic")'
