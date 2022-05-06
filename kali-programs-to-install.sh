# Kali Setup programs to be installed and configuration changes needed

## This collection of information is designed to make it easier to get a Kali instance to a standardized desired base configuration point
## so that it is fully functional with all expected software installed.

# Setup shared folder
# See these articles
# https://kb.vmware.com/s/article/60262
# https://docs.vmware.com/en/VMware-Tools/11.2/rn/VMware-Tools-1125-Release-Notes.html#vmware-tools-issues-in-vmware-workstation-or-fusion-known
# Configure shared folder in VMware to point to the folder on the VMware host and leave shared fodlers enable
# Add this line to the /etc/fstab file
# .host:/    /mnt/hgfs        fuse.vmhgfs-fuse    defaults,allow_other    0    0


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

# Install Terminator
sudo apt install terminator

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

# Install Windows Exploit Suggester - Next Generation (WES-NG)
pip3 install wesng

# Install PowerShell Empire
sudo apt install powershell-empire

## How to: Fix “sudo: add-apt-repository: command not found” (Debian/Ubuntu/Kali Linux etc.)
sudo apt-get install software-properties-common

## Install Spectacle screenshot utility
sudo apt install kde-spectacle

## Add Ksnip screenshot utility
## Ksnip looks good but seems to behave strangely in a VM
## sudo apt install ksnip
## The Ksnip AppImage is working correctly
## https://github.com/ksnip/ksnip/releases/tag/v1.9.2
wget https://github.com/ksnip/ksnip/releases/download/v1.9.2/ksnip-1.9.2-x86_64.AppImage

## Install Falmeshot
sudo apt install flameshot

## Install Web Recon programs
## httprobe
## https://github.com/tomnomnom/httprobe
go get -u github.com/tomnomnom/httprobe
## Amass
## https://github.com/OWASP/Amass
go install -v github.com/OWASP/Amass/v3/...@master
## assetfinder
## https://github.com/tomnomnom/assetfinder
go get -u github.com/tomnomnom/assetfinder
## subjack
## https://github.com/haccer/subjack
go get github.com/haccer/subjack
## waybackurls
## https://github.com/tomnomnom/waybackurls
go get github.com/tomnomnom/waybackurls

## Autoenum
wget https://github.com/Gr1mmie/autoenum/archive/refs/tags/v3.zip
unzip v3.zip

## Updog web server
## https://github.com/sc0tfree/updog
pip3 install updog

## html2text
sudo apt install html2text -y

## The mkpsrevshell.py script from - https://gist.github.com/tothi/ab288fb523a4b32b51a53e542d40fe58
## This script creates an encoded PowerShell reverse shell
## I have created a copy of this script renaming it to make-powershell-base64-reverse-shell.py

## The ps_encoder.py script
## https://raw.githubusercontent.com/darkoperator/powershell_scripts/master/ps_encoder.py

## Install csvkit
sudo apt install csvkit


## Create a ~/transfers directory and a ~/transfers/Sysinternals directory
mkdir ~/transfers
mkdir ~/transfers/Sysinternals
# PSTools
# Additional Sysinternals tools needed
# procdump

# Copy all current mkdir Sysinternals tools to the mkdir ~/transfers/Sysinternals directory
# Copy mimikatz.exe to the ~/transfers directory
# Copy Ghostpack-CompiledBinaries-master.zip to the ~/transfers directory
# Copy sbd.exe  to the ~/transfers directory
# Copy /usr/share/windows-resources/binaries/nc.exe to the ~/transfers directory
# Copy /usr/share/windows-resources/binaries/plink.exe to the ~/transfers directory
# Copy /usr/share/windows-resources/binaries/wget.exe to the ~/transfers directory
# Copy cp -R /usr/share/windows-resources/binaries/nbtenum to the ~/transfers directory
# Copy cp -R /usr/share/windows-resources/binaries/mbenum to the ~/transfers directory
# Copy cp -R /usr/share/windows-resources/binaries/enumplus to the ~/transfers directory
# Copy cp -R /usr/share/windows-resources/binaries/fgdump to the ~/transfers directory
# Copy cp -R /usr/share/windows-resources/binaries/fport to the ~/transfers directory

# evil-winrm
sudo apt install evil-winrm

# Install Remmina
sudo apt install remmina

# Install kerbrute
pip3 install kerbrute

# Install wine
dpkg --add-architecture i386 && apt-get update && apt-get install wine32

# Setup fuse group and add user to fuse group for sshfs use
sudo groupadd fuse
sudo usermod -a -G fuse rstrom

# Create a directory for mounting remote SMB shares
mkdir ~/SMBmount

# Install vsftpd
# How To Set Up vsftpd for a User's Directory on Ubuntu 20.04
# https://www.digitalocean.com/community/tutorials/how-to-set-up-vsftpd-for-a-user-s-directory-on-ubuntu-20-04
# How to Setup FTP Server with VSFTPD
# https://adamtheautomator.com/vsftpd/
sudo apt install vsftpd
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.orig
sudo adduser ftp
sudo mkdir -p /home/ftp/ftp
sudo chown nobody:nogroup /home/ftp/ftp
sudo chmod a-w /home/ftp/ftp
sudo mkdir -p /home/ftp/ftp/files
sudo chown ftp:ftp /home/ftp/ftp/files

