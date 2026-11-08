#!/bin/bash
# Temporarily disable follow_mouse so the cursor can't override the
# explicit workspace switches we make before each app launch.
hyprctl eval 'hl.config({input={follow_mouse=0}})'

# ws1 (DP-1): Firefox
hyprctl dispatch 'hl.dsp.focus({workspace=1})'
hyprctl dispatch 'hl.dsp.exec_cmd("firefox")'
sleep 1

# ws2 (HDMI-A-1): second Firefox window
hyprctl dispatch 'hl.dsp.focus({workspace=2})'
hyprctl dispatch 'hl.dsp.exec_cmd("firefox --new-window")'
sleep 1

# ws3 (HDMI-A-1): Discord last — it's the slowest to start
hyprctl dispatch 'hl.dsp.focus({workspace=3})'
hyprctl dispatch 'hl.dsp.exec_cmd("discord")'

# Wait for Discord to appear, return to ws1, restore follow_mouse
sleep 8
hyprctl dispatch 'hl.dsp.focus({workspace=1})'
hyprctl eval 'hl.config({input={follow_mouse=1}})'
