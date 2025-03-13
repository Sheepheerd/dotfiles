#!/usr/bin/env sh

#!/bin/bash

DEVICE="kbd_backlight"  # Keyboard backlight device name

# Get current brightness and max brightness
CURRENT_BRIGHTNESS=$(brightnessctl --device="$DEVICE" g)
MAX_BRIGHTNESS=$(brightnessctl --device="$DEVICE" m)

# Calculate the next brightness level (0 -> Low -> High -> 0)
if [ "$CURRENT_BRIGHTNESS" -lt "$MAX_BRIGHTNESS" ]; then
    NEXT_BRIGHTNESS=$((CURRENT_BRIGHTNESS + 50))
else
    NEXT_BRIGHTNESS=0
fi

# Set the next brightness level
brightnessctl --device="$DEVICE" set "$NEXT_BRIGHTNESS"
