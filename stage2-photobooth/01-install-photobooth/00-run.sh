#!/bin/bash -e

# Modify /usr/lib/os-release
sed -i "s/Raspbian/photobooth-os/gI" ${ROOTFS_DIR}/usr/lib/os-release
sed -i "s/^HOME_URL=.*$/HOME_URL=\"https:\/\/github.com\/PhotoboothProject\/photobooth\/\"/g" ${ROOTFS_DIR}/usr/lib/os-release
sed -i "s/^SUPPORT_URL=.*$/SUPPORT_URL=\"https:\/\/github.com\/PhotoboothProject\/photobooth\/\"/g" ${ROOTFS_DIR}/usr/lib/os-release
sed -i "s/^BUG_REPORT_URL=.*$/BUG_REPORT_URL=\"https:\/\/github.com\/PhotoboothProject\/photobooth\/\"/g" ${ROOTFS_DIR}/usr/lib/os-release

# Custom motd
# Replace message of the day (ssh greeting text)
rm "${ROOTFS_DIR}"/etc/motd
rm "${ROOTFS_DIR}"/etc/update-motd.d/10-uname
install -m 755 files/motd-photobooth "${ROOTFS_DIR}"/etc/update-motd.d/10-photobooth

# Copy install script into chroot environment
wget https://raw.githubusercontent.com/PhotoboothProject/photobooth/dev/install-photobooth.sh -O files/install-photobooth.sh
install -m 755 files/install-photobooth.sh "${ROOTFS_DIR}"/home/${FIRST_USER_NAME}/install-photobooth.sh

# Remove the "last login" information
sed -i "s/^#PrintLastLog yes.*/PrintLastLog no/" ${ROOTFS_DIR}/etc/ssh/sshd_config

on_chroot << EOF
echo '---> call photobooth install script'
cd /home/${FIRST_USER_NAME}
./install-photobooth.sh -username="${FIRST_USER_NAME}" -raspberry -silent -branch="stable4"
EOF

rm "${ROOTFS_DIR}"/home/${FIRST_USER_NAME}/install-photobooth.sh
rm files/install-photobooth.sh
