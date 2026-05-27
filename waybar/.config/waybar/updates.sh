#!/bin/bash

pacman_updates=$(checkupdates 2>/dev/null)
pacman_count=$(echo "$pacman_updates" | grep -c .)

aur_count=0
aur_updates=""
if command -v paru &>/dev/null; then
    aur_updates=$(paru -Qua 2>/dev/null)
    aur_count=$(echo "$aur_updates" | grep -c .)
fi

total=$((pacman_count + aur_count))

json_encode() {
    python3 -c "import json,sys; print(json.dumps(sys.stdin.read().rstrip()))" <<< "$1"
}

if [ "$total" -eq 0 ]; then
    echo '{"text": "", "tooltip": "System up to date", "class": "up-to-date"}'
    exit 0
fi

tooltip="${total} update(s) available"

if [ "$pacman_count" -gt 0 ]; then
    pkg_list=$(echo "$pacman_updates" | awk '{print $1 "  " $2 " → " $4}')
    tooltip="${tooltip}

Pacman (${pacman_count}):
${pkg_list}"
fi

if [ "$aur_count" -gt 0 ]; then
    aur_list=$(echo "$aur_updates" | awk '{print $1 "  " $2 " → " $4}')
    tooltip="${tooltip}

AUR (${aur_count}):
${aur_list}"
fi

text_json=$(json_encode "󰚰 ${total}")
tooltip_json=$(json_encode "$tooltip")
class=$( [ "$total" -gt 100 ] && echo "urgent" || echo "has-updates" )

echo "{\"text\": ${text_json}, \"tooltip\": ${tooltip_json}, \"class\": \"${class}\"}"
