# Kali Setup programs to be installed and configuration changes needed

## This collection of information is designed to make it easier to get a Kali instance to a standardized desired base configuration point
## so that it is fully functional with all expected software installed.

## pimpmykali - https://github.com/Dewalt-arch/pimpmykali
sudo git clone https://github.com/Dewalt-arch/pimpmykali /opt/pimpmykali
rm -rf /opt/pimpmykali/
cd /opt/pimpmykali
sudo ./pimpmykali.sh
cd  /

## Install exa
sudo apt install exa
## Add exa aliases to ls to the zsh profile

## Create directory for storing downloaded exploits, etc.

cd ~
mkdir exploits
## Clone Dewalt's pimpmy-phprevshell
git clone https://github.com/Dewalt-arch/pimpmy-phprevshell.git

## Install ShellCheck - A shell script static analysis tool
## https://github.com/koalaman/shellcheck#user-content-in-your-editor
sudo apt install shellcheck

## Install progress viewer
sudo apt install pv

# Install Geany IDE / Editor
sudo apt install geany

## Install Copyq
https://github.com/hluk/CopyQ
https://github.com/hluk/CopyQ/releases/latest

## Install xclip
sudo apt install xclip
## Add xclip aliases to the .zshrc profile

## Install Dolphin
sudo apt install dolphin

# Install rustscan
# https://overide.medium.com/rustscan-fcbdb93e17c9
# https://github.com/RustScan/RustScan/wiki/Installation-Guide
# https://github.com/RustScan/RustScan/releases/
wget https://github.com/RustScan/RustScan/releases/download/2.0.1/rustscan_2.0.1_amd64.deb -o rustscan_2.0.1_amd64.deb
sudo dpkg -i rustscan_2.0.1_amd64.deb

# Install nmapAutomater
git clone https://github.com/21y4d/nmapAutomator.git
sudo ln -s $(pwd)/nmapAutomator/nmapAutomator.sh /usr/local/bin/
