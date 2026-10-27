#!/bin/bash
#
# Disables visual effects and compositing on Parrot OS (MATE)
# to reduce RAM and CPU usage.
#

echo "Disabling MATE window manager compositing..."
gsettings set org.mate.Marco.general compositing-manager false

echo "Disabling global desktop animations..."
gsettings set org.gnome.desktop.interface enable-animations false

echo "Enabling reduced resource usage mode for Marco..."
gsettings set org.mate.Marco.general reduced-resources true

# Optional: If you have a standalone compositor like picom or compton running,
# the script will stop it and prevent it from auto-starting.
# Uncomment the lines below if you are using one.

# echo "Stopping and disabling standalone compositor (picom/compton)..."
# killall picom 2>/dev/null
# killall compton 2>/dev/null
# systemctl --user disable --now picom 2>/dev/null
# systemctl --user disable --now compton 2>/dev/null

echo "Visual effects have been disabled. Changes are persistent after reboot."
