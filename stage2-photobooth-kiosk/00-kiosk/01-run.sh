#!/bin/bash -e

on_chroot << EOF

echo "http://127.0.0.1" > /boot/kiosk.url
chown 1000:1000 /boot/kiosk.url

echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
export DEBIAN_FRONTEND=noninteractive
EOF

HOME="${ROOTFS_DIR}/home/${FIRST_USER_NAME}"
install -m 755 -o 1000 -g 1000 files/kiosk.sh "${HOME}/"
install -m 644 -o 1000 -g 1000 files/.profile "${HOME}/"
install -m 644 -o 1000 -g 1000 files/.xinitrc "${HOME}/"
install -m 755 -o 1000 -g 1000 -d "${HOME}/bin/"
install -m 755 -o 1000 -g 1000 files/bin/browser "${HOME}/bin/"
