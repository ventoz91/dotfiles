#!/bin/bash
# Temporarily disable follow_mouse so the cursor can't override the
# explicit workspace switches we make before each app launch.
hyprctl keyword input:follow_mouse 0

# ws1 (DP-1): Firefox
hyprctl dispatch workspace 1
hyprctl dispatch exec firefox
sleep 4

# ws2 (HDMI-A-1): second Firefox window
# The 4s sleep above lets the first instance finish starting so that
# --new-window hits a running process rather than racing against it.
hyprctl dispatch workspace 2
hyprctl dispatch exec "firefox --new-window"
sleep 2

# ws5 (HDMI-A-1): Discord bot terminal
hyprctl dispatch workspace 5
hyprctl dispatch exec "kitty -e $HOME/.config/scripts/discord-bot.sh"
sleep 1

# ws3 (HDMI-A-1): Discord last — it's the slowest to start
hyprctl dispatch workspace 3
hyprctl dispatch exec discord

# Wait for Discord to appear, return to ws1, restore follow_mouse
sleep 8
hyprctl dispatch workspace 1
hyprctl keyword input:follow_mouse 1
