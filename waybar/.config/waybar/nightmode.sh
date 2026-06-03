#!/bin/bash
if pgrep -x hyprsunset > /dev/null; then
    echo '{"text": "☾", "tooltip": "Night mode on · 3500K\nSuper+Shift+N to toggle", "class": "night-on"}'
else
    echo '{"text": "☀", "tooltip": "Night mode off\nSuper+Shift+N to toggle", "class": "night-off"}'
fi
