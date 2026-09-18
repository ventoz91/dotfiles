#!/bin/bash
# Screen/region recording via wf-recorder. Re-running this script while a
# recording is active stops it (SIGINT lets wf-recorder finalize the file).
mkdir -p ~/Videos/Recordings

LASTFILE="$XDG_RUNTIME_DIR/wf-recorder-lastfile"

if pgrep -x wf-recorder > /dev/null; then
    pkill -INT -x wf-recorder
    sleep 0.3
    FILE=$(cat "$LASTFILE" 2>/dev/null)
    notify-send -i "$FILE" "Recording stopped" "$(basename "${FILE:-recording}")"
    exit 0
fi

CHOICE=$(printf "  Region\n  Fullscreen" | \
    rofi -dmenu -p "Record" -i \
    -theme-str 'listview { lines: 2; } window { width: 300px; }')

[[ -z "$CHOICE" ]] && exit 0

sleep 0.2

FILE="$HOME/Videos/Recordings/$(date +%Y-%m-%d_%H-%M-%S).mp4"
echo "$FILE" > "$LASTFILE"

case "$CHOICE" in
    *Region*)
        REGION=$(slurp -d) || exit 0
        wf-recorder -g "$REGION" -f "$FILE" &
        disown
        notify-send "Recording started" "Region — Super+Shift+Print to stop"
        ;;
    *Fullscreen*)
        OUTPUT=$(hyprctl monitors -j | jq -r '.[] | select(.focused==true) | .name')
        wf-recorder -o "$OUTPUT" -f "$FILE" &
        disown
        notify-send "Recording started" "Fullscreen ($OUTPUT) — Super+Shift+Print to stop"
        ;;
esac
