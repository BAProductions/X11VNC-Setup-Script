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
    read -p "Do You Install X11VNC y/n?" -n 1 -r
    echo    # Do Wou Want Make X11VNC Discover On MacOS?
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Seting UP X11vnc"
        apt-get update
        isPackageInstalled x11vnc
        isPackageInstalled net-tools
        # read -p "Do Wou Want Make X11VNC Discover On MacOS y/n?" -n 1 -r
        # echo    # Do Wou Want Make X11VNC Discover On MacOS?
        # if [[ $REPLY =~ ^[Yy]$ ]]
        # then
        echo "Adding x11vnc to >> /var/spool/cron/root"
        sudo echo "@reboot x11vnc" >> /var/spool/cron/root
        #fi
    fi
}

# Setup avahi-daemon
function SetupAvahiDaemon() {
    read -p "Do You Want Make X11VNC Discover On MacOS y/n?" -n 1 -r
    echo    # Do Wou Want Make X11VNC Discover On MacOS?
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        isPackageInstalled avahi-daemon
        echo "Coping sercives/rfb.service /etc/avahi/services/"
        sudo cp sercives/rfb.service /etc/avahi/services/
        echo "Restarting avahi-daemon"
        sudo systemctl restart avahi-daemon
    fi
}

# init
function init() {
    SetupX11vnc
    SetupAvahiDaemon
}

# Run init
init
