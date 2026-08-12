#!/bin/bash
if ! hyprctl clients -j | grep -q '"class": "com.github.th-ch.youtube-music"'; then
    hyprctl dispatch exec "[workspace special:ytmusic silent] youtube-music"
    sleep 0.3
fi
hyprctl dispatch togglespecialworkspace ytmusic
