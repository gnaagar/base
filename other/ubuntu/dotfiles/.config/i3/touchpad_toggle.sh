#!/bin/bash

# Replace these with your actual device names (use `xinput list`)
TOUCHPAD_ID=$(xinput list | grep -i Touchpad | sed -n 's/.*id=\([0-9]*\).*/\1/p')

while true; do
    MOUSE_PRESENT=$(xinput list | grep -i "mouse" | grep -vi 'elan' | grep -vi 'keyboard')
    
    if [ -n "$MOUSE_PRESENT" ]; then
        xinput disable "$TOUCHPAD_ID"
    else
        xinput enable "$TOUCHPAD_ID"
    fi
    
    sleep 2
done
