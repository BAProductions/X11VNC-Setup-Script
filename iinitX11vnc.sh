#!/bin/bash
# Use to mount smb//bamserver.local/media ~/Music/iTunes.

# Check is Package Installed
function isPackageInstalled() {

    dpkg -s $1 &> /dev/null

    if [ $? -eq 0 ]; then
        echo "Package  is installed!"
    else
        echo "Package  is NOT installed!"
        sudo apt-get install $1
    fi
}

# Setup X11vnc, net-tools
function SetupX11vnc() {
    apt-get update
    isPackageInstalled x11vnc
    isPackageInstalled net-tools
    sudo "echo "@reboot x11vnc" >> /var/spool/cron/root"
}

# Setup avahi-daemon
function SetupAvahiDaemon() {
    isPackageInstalled avahi-daemon
    sudo cp sercives/rfb.service /etc/avahi/services/
    sudo systemctl restart avahi-daemon
}

# init
function init() {
    SetupX11vnc
    SetupAvahiDaemon
}

# Run init
init
