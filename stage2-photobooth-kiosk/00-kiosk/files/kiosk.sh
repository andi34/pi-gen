#!/usr/bin/env bash

# read URL from easily accessible location
URL=$(head -n 1 /boot/kiosk.url)

# never blank the screen
xset s off -dpms

# start the cec-client & browser
browser --fullscreen "${URL:='http://127.0.0.1'}"
