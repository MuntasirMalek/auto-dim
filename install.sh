#!/bin/bash
# Install auto-dim as a startup service

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLIST_NAME="com.autodim.plist"
PLIST_SRC="$SCRIPT_DIR/$PLIST_NAME"
PLIST_DEST="$HOME/Library/LaunchAgents/$PLIST_NAME"

# Make script executable
chmod +x "$SCRIPT_DIR/auto-dim.sh"

# Create LaunchAgents folder if needed
mkdir -p "$HOME/Library/LaunchAgents"

# Copy plist and update path
sed "s|__INSTALL_PATH__|$SCRIPT_DIR|g" "$PLIST_SRC" > "$PLIST_DEST"

# Unload if already loaded
launchctl unload "$PLIST_DEST" 2>/dev/null

# Load the service
launchctl load "$PLIST_DEST"

echo "✅ Auto-dim installed and running!"
echo "   Timeout: 120 seconds (edit $PLIST_DEST to change)"
echo "   Log: /tmp/auto-dim.log"
echo ""
echo "To uninstall: ./uninstall.sh"
