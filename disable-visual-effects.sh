#!/bin/bash
#
# Parrot OS (KDE) Optimization Script for ROOT
# 1. Disables compositing (removes window transparency/shadows).
# 2. Kills all UI animations.
# 3. Enables robust, persistent terminal history.
#

echo "--- 1. Removing graphical visual effects (Compositing) ---"
# Turn off the KWin compositor
kwriteconfig6 --file kwinrc --group Compositing --key Enabled false 2>/dev/null || \
kwriteconfig5 --file kwinrc --group Compositing --key Enabled false

# Instantly suspend the compositor in the current session
qdbus org.kde.KWin /Compositor suspend > /dev/null 2>&1

echo "--- 2. Removing all UI animations ---"
# Set animation duration to 0 (makes all KDE animations instant)
kwriteconfig6 --file kdeglobals --group KDE --key AnimationDurationFactor 0 2>/dev/null || \
kwriteconfig5 --file kdeglobals --group KDE --key AnimationDurationFactor 0

# Tell KWin to immediately reload its configuration
qdbus org.kde.KWin /KWin reconfigure > /dev/null 2>&1

echo "--- 3. Configuring persistent terminal history ---"
# Define the history configuration block
HISTORY_CONFIG='
# --- Enhanced Bash History Configuration ---
# Append to the history file, do not overwrite it
shopt -s histappend
# Set a very large history size
HISTSIZE=1000000
HISTFILESIZE=2000000
# Add timestamps to history entries
HISTTIMEFORMAT="%F %T "
# Force the shell to save each command immediately after it is executed
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
# -------------------------------------------
'

# Check if already added to avoid duplicates
if grep -q "Enhanced Bash History Configuration" "$HOME/.bashrc"; then
    echo "History configuration already exists in $HOME/.bashrc. Skipping."
else
    echo "$HISTORY_CONFIG" >> "$HOME/.bashrc"
    echo "History configuration successfully added to $HOME/.bashrc."
fi

echo "--- Optimization Complete! ---"
echo "Please reboot your machine or log out and log back in for all changes to take full effect."
