#!/bin/bash
CACHE="$HOME/.cache/waybar-weather.json"

weather=$(curl -sf --max-time 5 "https://wttr.in/?format=1" 2>/dev/null | tr -d '\n')

if [[ -z "$weather" ]]; then
    # Bad pull — return cached result if available, otherwise stay silent
    if [[ -f "$CACHE" ]]; then
        cat "$CACHE"
    fi
    exit 0
fi

tooltip=$(curl -sf --max-time 5 "https://wttr.in/?format=3" 2>/dev/null | tr -d '\n')

result=$(python3 -c "
import json, sys
print(json.dumps({'text': sys.argv[1], 'tooltip': sys.argv[2]}))
" "$weather" "${tooltip:-$weather}")

echo "$result" | tee "$CACHE"
