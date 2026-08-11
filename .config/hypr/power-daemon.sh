#!/usr/bin/env bash
# ==============================================================================
# AUTOMATIC POWER MANAGEMENT DAEMON
# AC Plugged  -> Performance Mode + High Brightness
# On Battery  -> Power Saver Mode + Screen Dimming
# ==============================================================================

PREV_STATUS=""

while true; do
    if [ -f /sys/class/power_supply/AC/online ]; then
        STATUS=$(cat /sys/class/power_supply/AC/online)
    else
        STATUS=0
    fi

    if [ "$STATUS" != "$PREV_STATUS" ]; then
        PREV_STATUS="$STATUS"
        if [ "$STATUS" -eq 1 ]; then
            # AC Plugged In -> Max Performance
            powerprofilesctl set performance 2>/dev/null || powerprofilesctl set balanced 2>/dev/null
            brightnessctl set 80% >/dev/null 2>&1
            notify-send -r 9920 -t 2000 "⚡ Power Mode" "AC Plugged: Max Performance Mode"
        else
            # On Battery -> Power Saver
            powerprofilesctl set power-saver 2>/dev/null
            brightnessctl set 35% >/dev/null 2>&1
            notify-send -r 9920 -t 2000 "🔋 Power Mode" "Battery: Power Saver Mode"
        fi
    fi

    sleep 3
done
