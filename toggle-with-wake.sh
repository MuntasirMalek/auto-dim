#!/bin/bash
# Combined toggle: Auto-Dim + KeepingYouAwake
# Hyper+W triggers this - both turn on together, both turn off together

PIDFILE="/tmp/auto-dim.pid"
SCRIPT="/Users/utsho/auto-dim/auto-dim.sh"

if [ -f "$PIDFILE" ] && ps -p "$(cat $PIDFILE)" > /dev/null 2>&1; then
    # Both are running - stop auto-dim and close KeepingYouAwake
    /bin/kill -9 "$(cat $PIDFILE)" 2>/dev/null
    rm -f "$PIDFILE"
    osascript -e 'quit app "KeepingYouAwake"'
    osascript -e 'display notification "Auto-Dim OFF + KeepingYouAwake Closed" with title "Screen"'
else
    # Not running - start auto-dim and open KeepingYouAwake
    rm -f "$PIDFILE"
    nohup "$SCRIPT" > /dev/null 2>&1 &
    echo $! > "$PIDFILE"
    open -a 'KeepingYouAwake.app'
    osascript -e 'display notification "Auto-Dim ON + KeepingYouAwake Opened" with title "Screen"'
fi
