#!/usr/bin/env bash
# Fix Hyprland socket path for apt-installed Waybar
# Links XDG_RUNTIME_DIR socket to /tmp/hypr where Waybar expects it

SIGNATURE="$HYPRLAND_INSTANCE_SIGNATURE"
if [ -z "$SIGNATURE" ]; then
    exit 1
fi

mkdir -p /tmp/hypr
ln -sfn "$XDG_RUNTIME_DIR/hypr/$SIGNATURE" "/tmp/hypr/$SIGNATURE"
