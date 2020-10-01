#!/bin/bash
# Use X11vnc, net-tools & the avahi-daemon for Apple user.

# Check is Package Installed
function isPackageInstalled() {

    dpkg -s $1 &> /dev/null

    if [ $? -eq 0 ]; then
        echo "Package  is installed!"
    else
        echo "Package  is NOT installed!"
        sudo apt-get install $1
        echo "The Package $1 Successfully Install"
    fi
}

# Setup X11vnc, net-tools
function SetupX11vnc() {
        echo "Seting UP X11vnc"
        sudo apt-get update
        SucessBanner
        isPackageInstalled x11vnc
        SucessBanner
        isPackageInstalled net-tools
        SucessBanner
        echo "Adding x11vnc to >> /var/spool/cron/root"
        sudo echo "@reboot x11vnc" >> /var/spool/cron/root
        SucessBanner
        echo "Seting UP X11vnc Password"
        x11vnc -storepasswd
        SucessBanner
        echo "Coping $HOME/.vnc/passwd /root/"
        sudo cp -avr $HOME/.vnc/passwd /root/
        SucessBanner
}

# Setup avahi-daemon
function SetupAvahiDaemon() {
    isPackageInstalled avahi-daemon
    echo "Coping sercives/rfb.service /etc/avahi/services/"
    sudo cp sercives/rfb.service /etc/avahi/services/
    SucessBanner
    echo "Restarting avahi-daemon"
    sudo systemctl restart avahi-daemon
    SucessBanner

}
function SucessMessage() {
    if [ $1 -eq 0 ]; then
        echo "x11vnc was successfully installed and configured and you can now control your linux computer from any devices with a \"VNC Viewer\""
        SucessBannerLG
        CreatorBanner
    else
        echo "x11vnc was successfully installed and configured and you can now control your linux computer from any devices with a \"VNC Viewer\""
        echo "avahi daemon was successfully configured x11vnc is now discoverable natively by MacOS or Any Apple devices with VNC view that supports bonjour  Enjoy!!!!"
        SucessBannerLG
        CreatorBanner
    fi
}

#Sucess Banner XS
function SucessBannerXS() {
    echo -e " --------";
    echo -e "| Secess |";
    echo -e " --------";
}

# Sucess Banner LG
function SucessBannerLG() {
    echo -e " ------------------------------------------------------------------------------------------------------------------------";
    echo -e "|\t\t\t\t\t    ____                             \t\t\t\t\t\t |";
    echo -e "|\t\t\t\t\t  / ___| _   _  ___ ___ ___  ___ ___ \t\t\t\t\t\t |";
    echo -e "|\t\t\t\t\t  \___ \| | | |/ __/ __/ _ \/ __/ __|\t\t\t\t\t\t |";
    echo -e "|\t\t\t\t\t   ___) | |_| | (_| (_|  __/\__ \__ \\t\t\t\t\t\t |";
    echo -e "|\t\t\t\t\t  |____/ \__,_|\___\___\___||___/___/\t\t\t\t\t\t |";
    echo -e "|\t\t\t\t\t                                     \t\t\t\t\t\t |";
    echo -e " ------------------------------------------------------------------------------------------------------------------------";
}

# Banner
 function CreatorBanner() {
    echo -e " ------------------------------------------------------------------------------------------------------------------------";
    echo -e "|   ____      _   _    ____  _   _ _       _   _               ____                _            _   _                  \t |";
    echo -e "|  |  _ \    | | / \  | __ )| | | (_)_ __ | | | | ___  _ __   |  _ \ _ __ ___   __| |_   _  ___| |_(_) ___  _ __  ___  \t |";
    echo -e "|  | | | |_  | |/ _ \ |  _ \| |_| | | '_ \| |_| |/ _ \| '_ \  | |_) | '__/ _ \ / _\` | | | |/ __| __| |/ _ \| '_ \/ __| \t |";
    echo -e "|  | |_| | |_| / ___ \| |_) |  _  | | |_) |  _  | (_) | |_) | |  __/| | | (_) | (_| | |_| | (__| |_| | (_) | | | \__ \\ \t |";
    echo -e "|  |____/ \___/_/   \_\____/|_| |_|_| .__/|_| |_|\___/| .__/  |_|   |_|  \___/ \__,_|\__,_|\___|\__|_|\___/|_| |_|___/ \t |";
    echo -e "|                                   |_|               |_|                                                              \t |";
    echo -e "| \t\t\t\t     https://github.com/BAProductions/X11VNC-Setup-Script \t\t\t\t |";
    echo -e "| \tUse the \"x11vnc -storepasswd\" command on additional user accounts on the system to grant them access to x11vnc \t |";
    echo -e " ------------------------------------------------------------------------------------------------------------------------";
}

# init
function init() {
    CreatorBanner
    if [ $1 ="-y" ]
    then
        SetupX11vnc
        SetupAvahiDaemon
        SucessMessage 1
    else
        read -p "Do you want to Install X11VNC y/n?" -n 1 -r
        echo    # Do you want to Install X11VNC y/n?
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            SetupX11vnc
            read -p "Do you want make X11VNC discover on MacOS with the avahi daemon y/n?" -n 1 -r
            echo    # Do you want make X11VNC discover on MacOS with the avahi daemon y/n?
            if [[ $REPLY =~ ^[Yy]$ ]]
            then
                SetupAvahiDaemon
                SucessMessage 1
            else
                SucessMessage 0
            fi
        fi
    fi
}

# Run init
init
