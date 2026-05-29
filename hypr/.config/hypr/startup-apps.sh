#!/bin/bash
# Staggered workspace layout — called via exec-once so Hyprland is
# fully initialised before we start dispatching windows.

# ws1 (DP-1): Firefox
hyprctl dispatch exec "[workspace 1 silent] firefox"

# Wait for the first Firefox instance to finish starting before asking
# for a second window — it's single-instance so the second call must
# hit an already-running process or it lands on the wrong workspace.
sleep 4

# ws2 (HDMI-A-1): second Firefox window
hyprctl dispatch exec "[workspace 2 silent] firefox --new-window"

sleep 2

# ws3 (HDMI-A-1): Discord
hyprctl dispatch exec "[workspace 3 silent] discord"

# ws5 (DP-1): Discord bot (wrapper script sets correct working dir)
hyprctl dispatch exec "[workspace 5 silent] kitty -e $HOME/.config/scripts/discord-bot.sh"
