#!/bin/bash
if pgrep -x hyprsunset > /dev/null; then
    pkill -x hyprsunset
    until ! pgrep -x hyprsunset > /dev/null; do sleep 0.05; done
else
    hyprsunset -t 3500 &
    until pgrep -x hyprsunset > /dev/null; do sleep 0.05; done
fi
pkill -SIGRTMIN+9 waybar
