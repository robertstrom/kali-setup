# Kali Setup programs to be installed and configuration changes needed

## This collection of information is designed to make it easier to get a Kali instance to a standardized desired base configuration point
## so that it is fully functional with all expected software installed.

# For a VM install - setup shared folder
# See these articles
# https://kb.vmware.com/s/article/60262
# https://docs.vmware.com/en/VMware-Tools/11.2/rn/VMware-Tools-1125-Release-Notes.html#vmware-tools-issues-in-vmware-workstation-or-fusion-known
# Configure shared folder in VMware to point to the folder on the VMware host and leave shared folders enable
# Add this line to the /etc/fstab file
# .host:/    /mnt/hgfs        fuse.vmhgfs-fuse    defaults,allow_other    0    0
sudo bash -c 'echo ".host:/    /mnt/hgfs        fuse.vmhgfs-fuse    defaults,allow_other    0    0" >> /etc/fstab'


## pimpmykali - https://github.com/Dewalt-arch/pimpmykali
# sudo git clone https://github.com/Dewalt-arch/pimpmykali /opt/pimpmykali
# rm -rf /opt/pimpmykali/
# cd /opt/pimpmykali
# sudo ./pimpmykali.sh
# cd  /

## Install exa
sudo apt install exa -y
## Add exa aliases to ls to the zsh profile
## This will be done when the .zshrc profile is downloaded from GitHub at the end of this configuration

## Create directory for storing downloaded exploits, etc.

cd ~
mkdir exploits

# Create directory for sshfs mount for QNAP NAS
mkdir -p ~/QNAPMyDocs

# Create directories for python and PowerShell scripts
mkdir -p ~/Documents/scripts/python/
mkdir -p ~/Documents/scripts/PowerShell

# Create a directory for mounting remote SMB shares
mkdir ~/SMBmount


## Create a ~/transfers directory and a ~/transfers/Sysinternals directory
mkdir ~/transfers
mkdir -p  ~/transfers/Sysinternals

# Setup fuse group and add user to fuse group for sshfs use
sudo groupadd fuse
sudo usermod -a -G fuse rstrom

# Install sshfs
sudo apt install sshfs -y

export qnap='192.168.0.99'

sshfs rstrom@$qnap: ~/QNAPMyDocs

cd '/home/rstrom/QNAPMyDocs/My Documents/IRTools/Sysinternals'

cp * ~/transfers/Sysinternals/

cd ~

# PSTools
# Additional Sysinternals tools needed
# procdump

# Copy all current Sysinternals tools to the ~/transfers/Sysinternals directory
# Copy mimikatz.exe to the ~/transfers directory
# Copy Ghostpack-CompiledBinaries-master.zip to the ~/transfers directory
# Copy sbd.exe  to the ~/transfers directory
# Copy /usr/share/windows-resources/binaries/nc.exe to the ~/transfers directory
cp /usr/share/windows-resources/binaries/nc.exe ~/transfers
# Copy /usr/share/windows-resources/binaries/plink.exe to the ~/transfers directory
cp /usr/share/windows-resources/binaries/plink.exe ~/transfers
# Copy /usr/share/windows-resources/binaries/wget.exe to the ~/transfers directory
cp /usr/share/windows-resources/binaries/wget.exe ~/transfers
# Copy cp -R /usr/share/windows-resources/binaries/nbtenum to the ~/transfers directory
cp -R /usr/share/windows-resources/binaries/nbtenum ~/transfers/
# Copy cp -R /usr/share/windows-resources/binaries/mbenum to the ~/transfers directory
cp -R /usr/share/windows-resources/binaries/mbenum ~/transfers/
# Copy cp -R /usr/share/windows-resources/binaries/enumplus to the ~/transfers directory
cp -R /usr/share/windows-resources/binaries/enumplus ~/transfers/
# Copy cp -R /usr/share/windows-resources/binaries/fgdump to the ~/transfers directory
cp -R /usr/share/windows-resources/binaries/fgdump ~/transfers/
# Copy cp -R /usr/share/windows-resources/binaries/fport to the ~/transfers directory
cp -R /usr/share/windows-resources/binaries/fport ~/transfers/


## Install ShellCheck - A shell script static analysis tool
## https://github.com/koalaman/shellcheck#user-content-in-your-editor
sudo apt install shellcheck

## Install progress viewer
sudo apt install pv -y

# Install Geany IDE / Editor
sudo apt install geany -y

# Install Terminator
sudo apt install terminator -y

## Install Copyq
# https://github.com/hluk/CopyQ
# https://github.com/hluk/CopyQ/releases/latest
# sudo apt install copyq -y

## Install xclip
sudo apt install xclip -y
## Add xclip aliases to the .zshrc profile

## Install Dolphin
sudo apt install dolphin -y

# Install Krusader
sudo apt install krusader -y

# Install rustscan
# https://overide.medium.com/rustscan-fcbdb93e17c9
# https://github.com/RustScan/RustScan/wiki/Installation-Guide
# https://github.com/RustScan/RustScan/releases/
wget https://github.com/RustScan/RustScan/releases/download/2.0.1/rustscan_2.0.1_amd64.deb -O rustscan_2.0.1_amd64.deb
sudo dpkg -i rustscan_2.0.1_amd64.deb
rm -rf rustscan_2.0.1_amd64.deb

# Install nmapAutomater
git clone https://github.com/21y4d/nmapAutomator.git
sudo ln -s $(pwd)/nmapAutomator/nmapAutomator.sh /usr/local/bin/

# Install Windows Exploit Suggester - Next Generation (WES-NG)
pip3 install wesng

# Install PowerShell Empire
# sudo apt install powershell-empire -y

## How to: Fix “sudo: add-apt-repository: command not found” (Debian/Ubuntu/Kali Linux etc.)
# sudo apt-get install software-properties-common -y

## Install Spectacle screenshot utility
sudo apt install kde-spectacle -y

## Add Ksnip screenshot utility
## Ksnip looks good but seems to behave strangely in a VM
## sudo apt install ksnip
## The Ksnip AppImage is working correctly
## https://github.com/ksnip/ksnip/releases/tag/v1.9.2
# wget https://github.com/ksnip/ksnip/releases/download/v1.9.2/ksnip-1.9.2-x86_64.AppImage

## Install Falmeshot
sudo apt install flameshot -y

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
sudo apt install csvkit -y

# evil-winrm
## This is now install by default in Kali 2022.2
## sudo apt install evil-winrm -y

# Install Remmina
sudo apt install remmina -y

# Install kerbrute
pip3 install kerbrute

# Install wine
sudo dpkg --add-architecture i386 && apt-get update && apt-get install wine32


# Install vsftpd
# How To Set Up vsftpd for a User's Directory on Ubuntu 20.04
# https://www.digitalocean.com/community/tutorials/how-to-set-up-vsftpd-for-a-user-s-directory-on-ubuntu-20-04
# How to Setup FTP Server with VSFTPD
# https://adamtheautomator.com/vsftpd/
sudo apt install vsftpd -y
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.orig
sudo adduser ftp
sudo mkdir -p /home/ftp/ftp
sudo chown nobody:nogroup /home/ftp/ftp
sudo chmod a-w /home/ftp/ftp
sudo mkdir -p /home/ftp/ftp/files
sudo chown ftp:ftp /home/ftp/ftp/files

# Install Pure-FTPd
sudo apt update && sudo apt install pure-ftpd -y
# Create users and configuration
# Run this as root, not sudo, or the two commands to create the link to the PureDB will not work
#!/bin/bash

sudo groupadd ftpgroup
sudo useradd -g ftpgroup -d /dev/null -s /etc ftpuser
sudo pure-pw useradd offsec -u ftpuser -d /ftphome
sudo pure-pw mkdb
# The cd command below does not work if you are not not running as root
sudo cd /etc/pure-ftpd/auth/
# If you do not get cd'd into the directory above the command to create a link below will not work and then the user logons will not work
sudo ln -s ../conf/PureDB 60pdb
sudo mkdir -p /ftphome
sudo chown -R ftpuser:ftpgroup /ftphome/
sudo systemctl restart pure-ftpd

# Install Python HTTP Upload server
# https://pypi.org/project/uploadserver/
pip install uploadserver
## Usage = python3 -m uploadserver
## python3 -m uploadserver 80

# Install atftp TFTP server
sudo apt install atftp -y
# Configure the home directory for the TFTP server files
sudo mkdir /tftp
# Configure the permissions for the TFTP server files
sudo chown nobody: /tftp
# Start the TFTP server
sudo atftpd --daemon --port 69 /tftp

# Install urlencode
sudo apt install gridsite-clients -y


# Save the ps_encoder.py script to the ~/Documents/scripts/python directory
# https://github.com/darkoperator/powershell_scripts/blob/master/ps_encoder.py
wget https://raw.githubusercontent.com/darkoperator/powershell_scripts/master/ps_encoder.py -O ~/Documents/scripts/python/ps_encoder.py
chmod +x ~/Documents/scripts/python/ps_encoder.py

# Install shelter (may already be installed)
# Dynamic shellcode injection tool and dynamic PE infector
sudo apt install shellter -y

# Install the Veil framework
# https://github.com/Veil-Framework/Veil
# Kali quick install
# Veil was found to already be installed, but when you run veil the program still does need to be configured - 5/14/2022
sudo apt install veil -y
/usr/share/veil/config/setup.sh --force --silent

# Install the Hollywood Activate / Kali Screensaver (April Fools)
sudo apt -y install kali-screensaver
sudo apt -y install hollywood-activate
# Start the screensaver with the command below
# hollywood-activate

# Install Kali Wallpapers
sudo apt install kali-wallpapers-all -y

# Pull down the custom Kali .zshrc file from GitHub
cp ~/.zshrc ~/.zshrc.sav
wget https://raw.githubusercontent.com/robertstrom/kali-setup/main/zshrc -O ~/.zshrc
source ~/.zshrc
