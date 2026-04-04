#!/bin/bash
# Uninstall auto-dim service

PLIST_NAME="com.autodim.plist"
PLIST_DEST="$HOME/Library/LaunchAgents/$PLIST_NAME"

# Unload the service
launchctl unload "$PLIST_DEST" 2>/dev/null

# Remove plist
rm -f "$PLIST_DEST"

# Restore brightness just in case
/usr/local/bin/brightness 1 2>/dev/null

# Clean up
rm -f /tmp/auto-dim-state
rm -f /tmp/auto-dim.log

echo "✅ Auto-dim uninstalled"
