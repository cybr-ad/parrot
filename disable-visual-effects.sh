#!/bin/bash
#
# Optimizes Parrot OS (KDE) by:
# 1. Disabling visual effects and compositing.
# 2. Enabling persistent and robust terminal history.
#
# Run as your normal user. Do NOT use sudo.
#

echo "--- Disabling KDE visual effects and compositing ---"

# Turn off compositing in KWin configuration
kwriteconfig6 --file kwinrc --group Compositing --key Enabled false 2>/dev/null || \
kwriteconfig5 --file kwinrc --group Compositing --key Enabled false

# Turn off UI animations
kwriteconfig6 --file kdeglobals --group KDE --key AnimationDurationFactor 0 2>/dev/null || \
kwriteconfig5 --file kdeglobals --group KDE --key AnimationDurationFactor 0

# Instantly suspend the running compositor (if active)
qdbus org.kde.KWin /Compositor suspend > /dev/null 2>&1

echo "KDE visual effects have been disabled."

echo "--- Enabling persistent terminal history ---"

# Define the block of history settings to add to ~/.bashrc
HISTORY_CONFIG='
# --- Enhanced Bash History Configuration ---
# Append to the history file, don't overwrite it
shopt -s histappend
# Set a very large history size (effectively unlimited)
HISTSIZE=1000000
HISTFILESIZE=2000000
# Add timestamps to history entries (optional but useful)
HISTTIMEFORMAT="%F %T "
# Force the shell to save each command immediately after it is executed
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
# -------------------------------------------
'

# Check if the configuration block already exists to prevent duplicates
if grep -q "Enhanced Bash History Configuration" "$HOME/.bashrc"; then
    echo "Bash history configuration already exists in ~/.bashrc. Skipping."
else
    # Append the configuration block to ~/.bashrc
    echo "$HISTORY_CONFIG" >> "$HOME/.bashrc"
    echo "Bash history configuration has been added to ~/.bashrc."
fi

echo "Terminal history has been enabled and will persist across sessions."

echo "--- Optimization complete. Please log out and back in for all changes to take full effect. ---"
