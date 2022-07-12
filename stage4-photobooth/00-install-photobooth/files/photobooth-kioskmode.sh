#!/bin/bash

# Stop on the first sign of trouble
set -e

USERNAME="$1"
AUTOSTART_FILE=""
WEBBROWSER="chromium-browser"
KIOSK_FLAG="--kiosk http://127.0.0.1"
CHROME_DEFAULT_FLAGS="--noerrdialogs --disable-infobars --disable-features=Translate --no-first-run --check-for-update-interval=31536000 --touch-events=enabled --password-store=basic"
EXTRA_FLAGS="$CHROME_DEFAULT_FLAGS --use-gl=egl"
INSTALLFOLDERPATH="/var/www/html"

if [ -z "$USERNAME" ]; then
    echo "Username not defined!"
    exit 1
fi

browser_shortcut() {
    echo "[Desktop Entry]" > "$AUTOSTART_FILE"
    echo "Version=1.3" >> "$AUTOSTART_FILE"
    echo "Terminal=false" >> "$AUTOSTART_FILE"
    echo "Type=Application" >> "$AUTOSTART_FILE"
    echo "Name=Photobooth" >> "$AUTOSTART_FILE"
    echo "Exec=$WEBBROWSER $KIOSK_FLAG $EXTRA_FLAGS" >> "$AUTOSTART_FILE"
    echo "Icon=$INSTALLFOLDERPATH/resources/img/favicon-96x96.png" >> "$AUTOSTART_FILE"
    echo "StartupNotify=false" >> "$AUTOSTART_FILE"
    echo "Terminal=false" >> "$AUTOSTART_FILE"
}

echo "### Adding photobooth shortcut to Desktop"
if [ ! -d "/home/$USER_NAME/Desktop" ]; then
    mkdir -p /home/$USER_NAME/Desktop
    chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/Desktop
fi
AUTOSTART_FILE="/home/$USER_NAME/Desktop/photobooth.desktop"
browser_shortcut
chmod +x /home/$USER_NAME/Desktop/photobooth.desktop
chown $USER_NAME:$USER_NAME /home/$USER_NAME/Desktop/photobooth.desktop

echo "### Starting photobooth in Kiosk-Mode on every start"
AUTOSTART_FILE="/etc/xdg/autostart/photobooth.desktop"
browser_shortcut

echo "### Hide the mouse cursor on every start and disable the screen saver."
LXDE_AUTOSTART="/etc/xdg/lxsession/LXDE-pi/autostart"

echo "# Photobooth" >> "$LXDE_AUTOSTART"
echo "# turn off display power management system" >> "$LXDE_AUTOSTART"
echo "@xset -dpms" >> "$LXDE_AUTOSTART"
echo "# turn off screen blanking" >> "$LXDE_AUTOSTART"
echo "@xset s noblank" >> "$LXDE_AUTOSTART"
echo "# turn off screen saver" >> "$LXDE_AUTOSTART"
echo "@xset s off" >> "$LXDE_AUTOSTART"
echo "# Hide mousecursor" >> "$LXDE_AUTOSTART"
echo "@unclutter -idle 3" >> "$LXDE_AUTOSTART"
echo "# Photobooth End" >> "$LXDE_AUTOSTART"
