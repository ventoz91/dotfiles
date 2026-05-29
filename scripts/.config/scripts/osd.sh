#!/bin/bash
# OSD notifications for volume and brightness via dunst progress bars
# Usage: osd.sh volume up|down|mute
#        osd.sh brightness up|down

case "$1" in
    volume)
        case "$2" in
            up)   wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ ;;
            down) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
            mute) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
        esac
        vol_info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
        if echo "$vol_info" | grep -q MUTED; then
            notify-send -h string:x-dunst-stack-tag:osd \
                -h int:value:0 -t 1500 "  Muted" "Volume muted"
        else
            val=$(echo "$vol_info" | awk '{printf "%d", $2*100}')
            notify-send -h string:x-dunst-stack-tag:osd \
                -h int:value:"$val" -t 1500 "  Volume" "${val}%"
        fi
        ;;
    brightness)
        case "$2" in
            up)   brightnessctl -e4 -n2 set 5%+ >/dev/null ;;
            down) brightnessctl -e4 -n2 set 5%- >/dev/null ;;
        esac
        current=$(brightnessctl get)
        max=$(brightnessctl max)
        val=$((current * 100 / max))
        notify-send -h string:x-dunst-stack-tag:osd \
            -h int:value:"$val" -t 1500 "  Brightness" "${val}%"
        ;;
esac
