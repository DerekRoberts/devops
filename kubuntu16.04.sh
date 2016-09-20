#!/bin/bash
#
set -eux


# Insync GPG key and source file
#
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C
echo "deb http://apt.insynchq.com/ubuntu xenial non-free contrib" |\
    sudo tee /etc/apt/sources.list.d/insync.list


# Google Chrome key and source file
#
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub |\
    sudo apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" |\
    sudo tee /etc/apt/sources.list.d/google-chrome.list


# Atom.io PPA
#
sudo add-apt-repository -y ppa:webupd8team/atom


# Packaes
#
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt install -y \
  atom \
  audacity \
  build-essential \
  comix \
  google-chrome-stable \
  insync \
  linux-headers-generic \
  linux-headers-$( uname -r ) \
  vlc


# Dropbox
#
[ -s ~/.dropbox-dist/dropbox-lnx.x86_64*/dropbox ]|| \
  ( cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf - )


# Global Shortcuts from file
#
wget -qO ~/.config/kglobalshortcutsrc "https://raw.githubusercontent.com/DerekRoberts/devops/master/kde/kglobalshortcutsrc"


# Cleanup
#
sudo apt install -f
sudo apt autoremove -y
sudo update-grub
