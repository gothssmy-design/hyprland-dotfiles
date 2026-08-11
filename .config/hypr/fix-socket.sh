#!/usr/bin/env bash
# ==============================================================================
# HYPRLAND SOCKET FIX & WAYBAR AUTOSTART LAUNCHER
# Links XDG_RUNTIME_DIR socket to /tmp/hypr for Waybar IPC compatibility
# ==============================================================================

SIGNATURE="$HYPRLAND_INSTANCE_SIGNATURE"

# Retry loop in case signature env var takes 100ms to propagate
for i in {1..5}; do
    if [ -n "$SIGNATURE" ] && [ -d "$XDG_RUNTIME_DIR/hypr/$SIGNATURE" ]; then
        mkdir -p /tmp/hypr
        ln -sfn "$XDG_RUNTIME_DIR/hypr/$SIGNATURE" "/tmp/hypr/$SIGNATURE"
        break
    fi
    sleep 0.2
    SIGNATURE="$HYPRLAND_INSTANCE_SIGNATURE"
done

# Restart Waybar cleanly once socket is ready
pkill -x waybar 2>/dev/null || true
sleep 0.2
waybar &
