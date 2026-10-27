#!/bin/bash
#
# Optimizes Parrot OS (KDE) by:
# 1. Disabling visual effects and compositing.
# 2. Enabling persistent and robust terminal history.
#
# IMPORTANT: Run as your NORMAL USER, do NOT use sudo.
#

# --- Safety Check for Root ---
if [ "$EUID" -eq 0 ]; then
  echo "ERROR: Please do not run this script as root."
  echo "Run it as your normal desktop user so the settings apply to your account."
  exit 1
fi

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

# Check if the configuration block already exists to prevent duplicates
if grep -q "Enhanced Bash History Configuration" "$HOME/.bashrc"; then
    echo "Bash history configuration already exists in ~/.bashrc. Skipping."
else
    # Append the configuration block safely using cat and EOF
    cat << 'EOF' >> "$HOME/.bashrc"

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
EOF
    echo "Bash history configuration has been added to ~/.bashrc."
fi

echo "Terminal history has been enabled and will persist across sessions."

echo "--- Optimization complete! ---"
echo "Please log out and log back in for all changes to take full effect."
