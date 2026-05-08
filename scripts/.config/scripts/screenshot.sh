#!/bin/bash

mkdir -p ~/Pictures/Screenshots

sleep 0.1

grim -g "$(slurp -d)" - \
| tee ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png \
| wl-copy
