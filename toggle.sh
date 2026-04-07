#!/bin/bash
# Toggle auto-dim on/off with reliable state tracking

PIDFILE="/tmp/auto-dim.pid"
SCRIPT="/Users/utsho/auto-dim/auto-dim.sh"

if [ -f "$PIDFILE" ] && ps -p "$(cat $PIDFILE)" > /dev/null 2>&1; then
    # Running - stop it
    /bin/kill -9 "$(cat $PIDFILE)" 2>/dev/null
    rm -f "$PIDFILE"
    osascript -e 'display notification "Auto-Dim OFF" with title "Screen"'
else
    # Not running - start it
    rm -f "$PIDFILE"
    nohup "$SCRIPT" > /dev/null 2>&1 &
    echo $! > "$PIDFILE"
    osascript -e 'display notification "Auto-Dim ON" with title "Screen"'
fi
