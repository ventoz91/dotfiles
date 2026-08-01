#!/usr/bin/env bash
# Right-click context menu for waybar's network module — toggles the wg0 WireGuard tunnel.

if systemctl is-active --quiet wg-quick@wg0; then
    action=$(printf "Disconnect VPN\nStatus" | rofi -dmenu -p "VPN (connected)")
else
    action=$(printf "Connect VPN\nStatus" | rofi -dmenu -p "VPN (disconnected)")
fi

case "$action" in
    "Connect VPN")
        if pkexec systemctl start wg-quick@wg0; then
            notify-send "VPN" "wg0 connected"
        else
            notify-send -u critical "VPN" "Failed to connect wg0"
        fi
        ;;
    "Disconnect VPN")
        if pkexec systemctl stop wg-quick@wg0; then
            notify-send "VPN" "wg0 disconnected"
        else
            notify-send -u critical "VPN" "Failed to disconnect wg0"
        fi
        ;;
    "Status")
        notify-send "VPN" "$(wg show wg0 2>&1 || echo 'wg0 is not up')"
        ;;
esac
