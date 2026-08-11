#!/usr/bin/env bash
# Bulletproof 1-liner wofi toggle: kill if running, launch if closed
pkill -x wofi || wofi --show drun --allow-images
