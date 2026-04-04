#!/bin/bash
# Auto-dim: Dims screen after inactivity, restores on activity

IDLE_THRESHOLD=${AUTO_DIM_TIMEOUT:-120}  # seconds (default 2 min)
CHECK_INTERVAL=5                          # check every 5 seconds
BRIGHTNESS_CMD="/usr/local/bin/brightness"
RESTORE_BRIGHTNESS=1                      # brightness to restore to (0-1)
STATE_FILE="/tmp/auto-dim-state"

# Track state
is_dimmed=false
saved_brightness=""

get_idle_time() {
    # Get idle time in seconds from macOS
    ioreg -c IOHIDSystem | awk '/HIDIdleTime/ {print int($NF/1000000000); exit}'
}

get_brightness() {
    $BRIGHTNESS_CMD -l 2>/dev/null | grep -o "brightness [0-9.]*" | awk '{print $2}' | head -1
}

dim_screen() {
    if [ "$is_dimmed" = false ]; then
        saved_brightness=$(get_brightness)
        echo "$saved_brightness" > "$STATE_FILE"
        $BRIGHTNESS_CMD 0
        is_dimmed=true
        echo "[$(date '+%H:%M:%S')] Dimmed (was $saved_brightness)"
    fi
}

restore_screen() {
    if [ "$is_dimmed" = true ]; then
        # Restore to saved brightness or default
        restore_to=${saved_brightness:-$RESTORE_BRIGHTNESS}
        if [ -f "$STATE_FILE" ]; then
            restore_to=$(cat "$STATE_FILE")
        fi
        $BRIGHTNESS_CMD "$restore_to"
        is_dimmed=false
        echo "[$(date '+%H:%M:%S')] Restored to $restore_to"
    fi
}

cleanup() {
    restore_screen
    rm -f "$STATE_FILE"
    exit 0
}

trap cleanup SIGINT SIGTERM

echo "Auto-dim started (timeout: ${IDLE_THRESHOLD}s)"
echo "Press Ctrl+C to stop"

while true; do
    idle=$(get_idle_time)
    
    if [ "$idle" -ge "$IDLE_THRESHOLD" ]; then
        dim_screen
    else
        restore_screen
    fi
    
    sleep $CHECK_INTERVAL
done
