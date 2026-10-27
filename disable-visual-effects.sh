#!/bin/bash
#
# Optimizes Parrot OS (KDE) for the ROOT user by:
# 1. Disabling KDE visual effects and compositing.
# 2. Ensuring the changes apply to the root user's session.
#

echo "--- Disabling KDE visual effects for ROOT ---"

# Turn off compositing in KWin configuration for the root user
kwriteconfig6 --file kwinrc --group Compositing --key Enabled false 2>/dev/null || \
kwriteconfig5 --file kwinrc --group Compositing --key Enabled false

# Turn off UI animations for the root user
kwriteconfig6 --file kdeglobals --group KDE --key AnimationDurationFactor 0 2>/dev/null || \
kwriteconfig5 --file kdeglobals --group KDE --key AnimationDurationFactor 0

# Instantly suspend the running compositor (if active) for the current session
qdbus org.kde.KWin /Compositor suspend > /dev/null 2>&1

echo "KDE visual effects have been disabled for the root user."
echo "--- Changes will persist after your next reboot or re-login. ---"
