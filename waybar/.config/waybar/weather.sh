#!/bin/bash
weather=$(curl -sf --max-time 5 "https://wttr.in/?format=1" 2>/dev/null | tr -d '\n')

if [[ -z "$weather" ]]; then
    echo '{"text": "? --", "tooltip": "Weather unavailable"}'
    exit 0
fi

tooltip=$(curl -sf --max-time 5 "https://wttr.in/?format=3" 2>/dev/null | tr -d '\n')

python3 -c "
import json, sys
print(json.dumps({'text': sys.argv[1], 'tooltip': sys.argv[2]}))
" "$weather" "${tooltip:-Weather unavailable}"
