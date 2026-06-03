#!/bin/bash
# Open a YouTube URL in a floating mpv window.
# Priority: Firefox address bar (requires ydotool + ydotoold) → clipboard → rofi prompt.

is_youtube() {
    [[ "$1" =~ ^https?://(www\.)?(youtube\.com/(watch|shorts|live|playlist)|youtu\.be/) ]]
}

clip() {
    wl-paste --no-newline 2>/dev/null
}

URL=""
ACTIVE_CLASS=$(hyprctl activewindow -j 2>/dev/null | jq -r '.class // empty')

# Step 1: Grab URL from Firefox address bar via key injection
if [[ "$ACTIVE_CLASS" == "firefox" ]] && command -v ydotool &>/dev/null; then
    PREV=$(clip)
    ydotool key ctrl+l
    sleep 0.15
    ydotool key ctrl+c
    sleep 0.15
    URL=$(clip)
    printf '%s' "$PREV" | wl-copy
fi

# Step 2: Fall back to clipboard if it already holds a YouTube URL
if ! is_youtube "$URL"; then
    CLIP=$(clip)
    is_youtube "$CLIP" && URL="$CLIP"
fi

# Step 3: Rofi prompt, pre-filled with clipboard if it looks like a URL
if ! is_youtube "$URL"; then
    HINT=""
    CLIP=$(clip)
    [[ "$CLIP" =~ ^https?:// ]] && HINT="$CLIP"
    URL=$(rofi -dmenu -p " YouTube URL" -filter "$HINT" -theme-str 'window {width: 640px;}' < /dev/null)
fi

if is_youtube "$URL"; then
    mpv --ytdl-format="bestvideo[height<=1080]+bestaudio/best" "$URL" &
elif [[ -n "$URL" ]]; then
    dunstify "yt" "Not a valid YouTube URL" -u low -t 3000
fi
