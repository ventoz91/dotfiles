#!/bin/bash
# Toggle a floating ytui window on a hidden special workspace.
#
# - Videos ytui launches (mpv) open on whatever workspace is in front, i.e.
#   special:ytui while ytui is showing. They're moved to the regular
#   workspace underneath on every toggle, so hiding ytui never hides the video.
# - If the ytui window has ended up on a regular workspace, it's moved back
#   first; otherwise toggling would just show an empty, dimmed special:ytui.

WS="special:ytui"

ytui_addr() {
    hyprctl clients -j | jq -r '.[] | select(.class == "ytui") | .address' | head -n1
}

addr=$(ytui_addr)
if [ -z "$addr" ]; then
    hyprctl dispatch "hl.dsp.exec_cmd(\"kitty --class ytui -d /home/trevor/Documents/Projects/ytui -e .venv/bin/ytui\", {workspace=\"$WS silent\"})"
    # Wait (up to ~3s) for the window to map instead of a fixed sleep.
    for _ in $(seq 30); do
        addr=$(ytui_addr)
        [ -n "$addr" ] && break
        sleep 0.1
    done
fi

regular_ws=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .activeWorkspace.id')
clients=$(hyprctl clients -j)

# Keep videos out of the scratchpad.
for mpv in $(jq -r --arg ws "$WS" '.[] | select(.class == "mpv" and .workspace.name == $ws) | .address' <<<"$clients"); do
    hyprctl dispatch "hl.dsp.window.move({workspace=$regular_ws, window=\"address:$mpv\", follow=false})"
done

# Self-heal: put ytui back on its special workspace if it wandered off.
if [ -n "$addr" ]; then
    ytui_ws=$(jq -r --arg a "$addr" '.[] | select(.address == $a) | .workspace.name' <<<"$clients")
    if [ "$ytui_ws" != "$WS" ]; then
        hyprctl dispatch "hl.dsp.window.move({workspace=\"$WS\", window=\"address:$addr\", follow=false})"
    fi
fi

hyprctl dispatch 'hl.dsp.workspace.toggle_special("ytui")'
