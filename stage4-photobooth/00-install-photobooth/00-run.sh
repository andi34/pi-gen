#!/bin/bash -e

install -m 755 files/photobooth-kioskmode.sh "${ROOTFS_DIR}"/home/${FIRST_USER_NAME}/photobooth-kioskmode.sh

on_chroot << EOF
echo '---> KIOSK-MODE for Photobooth'

cd /home/${FIRST_USER_NAME}
./photobooth-kioskmode.sh "${FIRST_USER_NAME}"

EOF

rm  "${ROOTFS_DIR}"/home/${FIRST_USER_NAME}/photobooth-kioskmode.sh

