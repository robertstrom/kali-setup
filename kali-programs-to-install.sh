# Kali Setup programs to be installed and configuration changes needed

## This collection of information is designed to make it easier to get a Kali instance to a standardized desired base configuration point
## so that it is fully functional with all expected software installed.

## pimpmykali - https://github.com/Dewalt-arch/pimpmykali
git clone https://github.com/Dewalt-arch/pimpmykali /opt/pimpmykali
rm -rf /opt/pimpmykali/
cd /opt/pimpmykali
sudo ./pimpmykali.sh
cd  /

## Install exa
sudo apt install exa

## Create directory for storing downloaded exploits, etc.

cd ~
mkdir exploits
## Clone Dewalt's pimpmy-phprevshell
git clone https://github.com/Dewalt-arch/pimpmy-phprevshell.git
