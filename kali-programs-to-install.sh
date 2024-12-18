#!/bin/bash

scriptstarttime=$(date)

# Kali Setup programs to be installed and configuration changes needed

# XFCE Information for possible automation at a later date
# XFCE Settings Editor = xfce4-settings-editor
# Monitor changes to XFCE / XFCE panel = xfconf-query -c xfce4-panel -m -v
# XFconf-query - https://docs.xfce.org/xfce/xfconf/xfconf-query
# XFCE configuration appears to be stored here - /home/rstrom/.config/xfce4/
# XFCE panel launchers are stored here - /home/rstrom/.config/xfce4/panel
# Launcher files are named like this - /home/rstrom/.config/xfce4/panel/launcher-35/16588019193.desktop
# Launcher files are sinple text files - like the one shown below
# └─$ cat /home/rstrom/.config/xfce4/panel/launcher-35/16588019193.desktop
##
# User specific location for .desktop launcher files is ~/.local/share/applications
# the directory does not exist by default so it is best to create it using the command
# mkdir -p ~/.local/share/applications
##
# [Desktop Entry]
# Version=1.0
# Type=Application
# Name=MSGViewer
# Comment=MSGViewer
# Exec=java -jar /opt/msgviewer
# Icon=email
# Path=
# Terminal=false
# StartupNotify=false
# Display all of the .desktop file contents to the console
# find /home/rstrom/.config/xfce4/panel/ -iname '*.desktop' -exec cat {} \;


# Command to run on the new Kali system to download and execute this script
# wget -O - https://raw.githubusercontent.com/robertstrom/kali-setup/main/kali-programs-to-install.sh | bash

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
## RStrom - 5/28/2023 - Added all group memberships below
sudo adduser rstrom sudo
### For VirtualBox
## sudo adduser rstrom vboxsf
sudo adduser rstrom kaboxer
sudo adduser rstrom wireshark
sudo adduser rstrom adm
sudo adduser rstrom cdrom
sudo adduser rstrom floppy
sudo adduser rstrom audio
sudo adduser rstrom dip
sudo adduser rstrom video
sudo adduser rstrom plugdev
sudo adduser rstrom netdev
sudo adduser rstrom bluetooth
sudo adduser rstrom scanner


# 2022-08-27 - Commented out since Code is already installed in the "Large" install
# Install Visual Studio Code
# curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
# sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
# echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
## sudo apt update
## sudo apt install code -y


## pimpmykali - https://github.com/Dewalt-arch/pimpmykali
# sudo git clone https://github.com/Dewalt-arch/pimpmykali /opt/pimpmykali
# rm -rf /opt/pimpmykali/
# cd /opt/pimpmykali
# sudo ./pimpmykali.sh
# cd  /

# 2024-11-06
# create a ~/.screenrc file so that it is possible to scroll when using screen
touch ~/.screenrc
echo "# Enable mouse scrolling and scroll bar history scrolling" > ~/.screenrc
echo "termcapinfo xterm* ti@:te@" >> ~/.screenrc

## Install exa
sudo apt install eza -y
## Add exa aliases to ls to the zsh profile
## This will be done when the .zshrc profile is downloaded from GitHub at the end of this configuration

## Create directory for storing downloadeds, etc.

cd ~
mkdir exploits
mkdir ~/exploits/msf_scripts
mkdir ~/exploits/powershell-empire
mkdir wordlists
sudo gunzip /usr/share/wordlists/rockyou.txt.gz
sudo cp /usr/share/wordlists/rockyou.txt ~/wordlists/
cat ~/wordlists/rockyou.txt | head -n 1000 > ~/wordlists/rockyou-1000.txt
cat ~/wordlists/rockyou.txt | head -n 500 > ~/wordlists/rockyou-500.txt
cat ~/wordlists/rockyou.txt | head -n 5000 > ~/wordlists/rockyou-5000.txt
cat ~/wordlists/rockyou.txt | head -n 10000 > ~/wordlists/rockyou-10000.txt

# Create a directory for CherryTree content in the ~/Documents directory
# mkdir ~/Documents/CherryTree
# Download some CherryTree templates
# pushd  ~/Documents/CherryTree
# wget https://github.com/unmeg/hax/raw/master/BOX-SKELETON.ctb
# wget https://411hall.github.io/assets/files/CTF_template.ctb
# popd

# Create directory for sshfs mount for QNAP NAS
mkdir -p ~/QNAPMyDocs

mkdir -p /home/rstrom/.local/bin/

# Create directories for python and PowerShell scripts
mkdir -p ~/Documents/scripts/python/
mkdir -p ~/Documents/scripts/PowerShell

# Create a directory for mounting remote SMB shares
mkdir ~/SMBmount

# Create a working directory for temp type actions
mkdir ~/working

## Create a ~/transfers directory and a ~/transfers/Sysinternals directory
mkdir ~/transfers
mkdir -p  ~/transfers/Sysinternals
mkdir -p  ~/transfers/Nmap_static

# Setup fuse group and add user to fuse group for sshfs use
sudo groupadd fuse
sudo usermod -a -G fuse rstrom

sudo apt update && sudo apt upgrade -y

# Install sshfs
sudo apt install sshfs -y

export qnap='192.168.0.99'

sshfs rstrom@$qnap: ~/QNAPMyDocs

pushd '/home/rstrom/QNAPMyDocs/My Documents/IRTools/Sysinternals'

cp * ~/transfers/Sysinternals/

popd

# PSTools
# Additional Sysinternals tools needed
# procdump

# Copy all current Sysinternals tools to the ~/transfers/Sysinternals directory
# Copy mimikatz.exe to the ~/transfers directory
cp -R /usr/share/windows-resources/mimikatz/ ~/transfers/

# Copy Ghostpack-CompiledBinaries-master.zip to the ~/transfers directory
wget https://github.com/r3motecontrol/Ghostpack-CompiledBinaries/archive/refs/heads/master.zip -O ~/transfers/Ghostpack-CompiledBinaries-master.zip
pushd ~/transfers
unzip Ghostpack-CompiledBinaries-master.zip
popd
# Download the linux-exploit-suggester script
wget https://raw.githubusercontent.com/mzet-/linux-exploit-suggester/master/linux-exploit-suggester.sh -O ~/transfers/linux-exploit-suggester.sh
chmod +x ~/transfers/linux-exploit-suggester.sh

# Download pspy
wget https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy32
wget https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy32s
wget https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy64
wget https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy64s
chmod +x ~/transfers/pspy32
chmod +x ~/transfers/pspy32s
chmod +x ~/transfers/pspy64
chmod +x ~/transfers/pspy64s

# Copy sbd.exe  to the ~/transfers directory
cp /usr/share/windows-resources/sbd/sbd.exe ~/transfers/
# Copy /usr/share/windows-resources/binaries/nc.exe to the ~/transfers directory
cp /usr/share/windows-resources/binaries/nc.exe ~/transfers/
# Copy /usr/share/windows-resources/binaries/plink.exe to the ~/transfers directory
cp /usr/share/windows-resources/binaries/plink.exe ~/transfers/
# Copy /usr/share/windows-resources/binaries/wget.exe to the ~/transfers directory
cp /usr/share/windows-resources/binaries/wget.exe ~/transfers/
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
# Copy ncat static binary to the ~/transfers/Nmap_static directory
wget https://github.com/andrew-d/static-binaries/raw/master/binaries/linux/x86_64/ncat -O ~/transfers/Nmap_static/ncat && chmod +x ~/transfers/Nmap_static/ncat
# Copy socat static binary to the ~/transfers/Nmap_static directory
wget https://github.com/andrew-d/static-binaries/raw/master/binaries/linux/x86_64/socat -O ~/transfers/socat && chmod +x ~/transfers/socat
# Copy the linux-smart-enumeration to the ~/exploits directory
wget https://raw.githubusercontent.com/diego-treitos/linux-smart-enumeration/master/lse.sh -O ~/exploits/lse.sh && chmod +x ~/exploits/lse.sh


## 2024-11-06 - Install NoMachine
pushd ~/Downloads
wget https://www.nomachine.com/free/linux/64/deb -O nomachine.deb
sudo dpkg -i nomachine.deb
popd

## Install ShellCheck - A shell script static analysis tool
## https://github.com/koalaman/shellcheck#user-content-in-your-editor
## Install progress viewer
# Install Geany IDE / Editor
## 2024-09-23  - Added ripgrep pandoc poppler-utils ffmpeg to support ripgrep-al - https://github.com/phiresky/ripgrep-all?tab=readme-ov-file
## Also see this ripgrep-all blog  https://phiresky.github.io/blog/2019/rga--ripgrep-for-zip-targz-docx-odt-epub-jpg/
## 2024-10-28 - added zbar-tools to the list of programs to install. zbar-tools has the zbarimg command to analyze barcodes at the command line. Including QR codes
## 2024-11-09 - Added gnupg2 because it is a dependency for 1password
## 2024-11-09 - Added the install of vivaldi

sudo apt install -yy shellcheck libimage-exiftool-perl pv terminator copyq xclip dolphin krusader kdiff3 krename kompare xxdiff krename kde-spectacle \
flameshot html2text csvkit remmina kali-wallpapers-all hollywood-activate kali-screensaver gridsite-clients shellter sipcalc \
xsltproc rinetd torbrowser-launcher httptunnel kerberoast tesseract-ocr ncdu wkhtmltopdf grepcidr speedtest-cli neofetch sshuttle mpack filezilla lolcat \
ripgrep bat dcfldd shellter redis-tools feroxbuster name-that-hash jq keepassxc okular exfat-fuse exfatprogs kate xsel ripgrep pandoc poppler-utils ffmpeg \
zbar-tools gnupg2 vivaldi-stable dc3dd

## 2024-11-09 - Added the install of 1password
pushd ~/Downloads
wget https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb
sudo dpkg -i 1password-latest.deb
popd

# i3 program installs
## sudo apt install kali-desktop-i3
## sudo apt install feh
## Need to add these line to the i3 config file for copyq
## for_window [instance="^copyq$" class="^copyq$"] border pixel 1, floating enable
## exec copyq
## Font Awesome font cheatsheet
## https://fontawesome.com/v5/cheatsheet/free/solid
## Font Aesome version 5 fonts - has TTF fonts
## https://github.com/FortAwesome/Font-Awesome/releases/download/5.0.6/fontawesome-free-5.0.6.zip
## link to the - Yosemite San Francisco Font - https://github.com/supermarin/YosemiteSanFranciscoFont/archive/master.zip

## pull down the ripgrep-all binary and move the executables to the /usr/bin directory

pushd ~/Downloads
wget https://github.com/phiresky/ripgrep-all/releases/download/v0.10.6/ripgrep_all-v0.10.6-x86_64-unknown-linux-musl.tar.gz
tar -xzvf ripgrep_all-v0.10.6-x86_64-unknown-linux-musl.tar.gz
sudo mv ./ripgrep_all-v0.10.6-x86_64-unknown-linux-musl/rga* /usr/bin
rm -rf ./ripgrep_all-v0.10.6-x86_64-unknown-linux-musl
rm -rf ./ripgrep_all-v0.10.6-x86_64-unknown-linux-musl*.gz*
popd

# Setting up link to bat for the batcat install
ln -s /usr/bin/batcat ~/.local/bin/bat

# Install fzf via github
git clone --depth 1 https://github.com/junegunn/fzf.git
cd ~/fzf
./install --all
source ~/.zshrc
cd ~/


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

# Install nmap-converter
pushd /opt
sudo git clone https://github.com/mrschyte/nmap-converter.git
sudo pip install python-libnmap
sudo pip install XlsxWriter
sudo chown rstrom -R ./nmap-converter
pythonvar=$(which python3)
sed -i "s|/usr\/bin/env python|$pythonvar|" ./nmap-converter/nmap-converter.py
unset pythonvar
cd /usr/bin
sudo ln -s /opt/nmap-converter/nmap-converter.py nmap-converter 
sudo chown -R rstrom nmap-converter
popd

# Install wwwtree
sudo git clone https://github.com/t3l3machus/wwwtree /opt/wwwtree
cd /opt/wwwtree
sudo pip3 install -r requirements.txt
sudo chmod +x wwwtree.py
cd /usr/bin
sudo ln -s /opt/wwwtree/wwwtree.py wwwtree

# Install Reverse Shell Generator
# https://github.com/bing0o/Reverse_Shell_Generator
sudo curl https://raw.githubusercontent.com/bing0o/Reverse_Shell_Generator/main/payload.sh --create-dirs -o /opt/reverse-shell-generator/payload.sh
sudo chown -R rstrom:rstrom /opt/reverse-shell-generator
chmod +x /opt/reverse-shell-generator/payload.sh
cd /usr/bin
sudo ln -s /opt/reverse-shell-generator/payload.sh reverse-shell-generator
cd ~

# Install MsgViewer
# https://github.com/lolo101/MsgViewer/releases/download/msgviewer-1.8.7/msgviewer.jar
sudo wget https://github.com/lolo101/MsgViewer/releases/download/msgviewer-1.8.7/msgviewer.jar -O /opt/msgviewer.jar
sudo chmod +x /opt/msgviewer.jar
mkdir -p ~/.local/share/applications
wget https://raw.githubusercontent.com/robertstrom/kali-setup/main/MsgViewer.desktop -O ~/.local/share/applications/MsgViewer.desktop


# Install Villain
sudo git clone https://github.com/t3l3machus/Villain /opt/Villain
cd /opt/Villain
sudo pip3 install -r requirements.txt
sudo chmod +x Villain.py
sudo ln -s /opt/Villain/Villain.py Villain
cd ~

# Install Windows Exploit Suggester - Next Generation (WES-NG)
pip3 install wesng

# Install AutoRecon
# https://github.com/Tib3rius/AutoRecon
python3 -m pip install git+https://github.com/Tib3rius/AutoRecon.git

# Install PowerShell Empire
# sudo apt install powershell-empire -y

## How to: Fix “sudo: add-apt-repository: command not found” (Debian/Ubuntu/Kali Linux etc.)
# sudo apt-get install software-properties-common -y


## Install Web Recon programs
## httprobe
## https://github.com/tomnomnom/httprobe
go install github.com/tomnomnom/httprobe@latest
## Amass
## https://github.com/OWASP/Amass
go install -v github.com/OWASP/Amass/v3/...@master
## assetfinder
## https://github.com/tomnomnom/assetfinder
go install github.com/tomnomnom/assetfinder@latest
## subjack
## https://github.com/haccer/subjack
go install github.com/haccer/subjack@latest
## waybackurls
## https://github.com/tomnomnom/waybackurls
go install github.com/tomnomnom/waybackurls@latest

## Autoenum
wget https://github.com/Gr1mmie/autoenum/archive/refs/tags/v3.zip
unzip v3.zip

## Updog web server
## https://github.com/sc0tfree/updog
pip3 install updog

## The mkpsrevshell.py script from - https://gist.github.com/tothi/ab288fb523a4b32b51a53e542d40fe58
## This script creates an encoded PowerShell reverse shell
## I have created a copy of this script renaming it to make-powershell-base64-reverse-shell.py

# evil-winrm
## This is now install by default in Kali 2022.2
## sudo apt install evil-winrm -y


# Install kerbrute
pip3 install kerbrute

# Install wine
sudo dpkg --add-architecture i386 && sudo apt-get update && sudo apt-get install wine32 -y


# Install vsftpd
# How To Set Up vsftpd for a User's Directory on Ubuntu 20.04
# https://www.digitalocean.com/community/tutorials/how-to-set-up-vsftpd-for-a-user-s-directory-on-ubuntu-20-04
# How to Setup FTP Server with VSFTPD
# https://adamtheautomator.com/vsftpd/
## sudo apt install vsftpd -y
# 2022-08-27 - Commented out below due to errors waiting for input
# sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.orig
# sudo adduser ftp
# sudo mkdir -p /home/ftp/ftp
# sudo chown nobody:nogroup /home/ftp/ftp
# sudo chmod a-w /home/ftp/ftp
# sudo mkdir -p /home/ftp/ftp/files
# sudo chown ftp:ftp /home/ftp/ftp/files

# Install Pure-FTPd
# sudo apt update && sudo apt install pure-ftpd -y
# Create users and configuration
# Run this as root, not sudo, or the two commands to create the link to the PureDB will not work
#!/bin/bash

# 2022-08-27 - Commented out below due to errors waiting for input
# sudo groupadd ftpgroup
# sudo useradd -g ftpgroup -d /dev/null -s /etc ftpuser
# sudo pure-pw useradd offsec -u ftpuser -d /ftphome
# sudo pure-pw mkdb
# The sudo cd command below does not work if you are not not running as root
# sudo cd /etc/pure-ftpd/auth/
# cd /etc/pure-ftpd/auth
# If you do not get cd'd into the directory above the command to create a link below will not work and then the user logons will not work
# sudo ln -s ../conf/PureDB 60pdb
# sudo mkdir -p /ftphome
# sudo chown -R ftpuser:ftpgroup /ftphome/
# sudo systemctl restart pure-ftpd

# Install Python HTTP Upload server
# https://pypi.org/project/uploadserver/
pip3 install uploadserver
## Usage = python3 -m uploadserver
## python3 -m uploadserver 80

# Install atftp TFTP server
sudo apt install atftp -y
# Configure the home directory for the TFTP server files
sudo mkdir /tftp
# Configure the permissions for the TFTP server files
sudo chown nobody: /tftp
# Command to start the TFTP server
# sudo atftpd --daemon --port 69 /tftp


# Save the ps_encoder.py script to the ~/Documents/scripts/python directory
# https://github.com/darkoperator/powershell_scripts/blob/master/ps_encoder.py
wget https://raw.githubusercontent.com/darkoperator/powershell_scripts/master/ps_encoder.py -O ~/Documents/scripts/python/ps_encoder.py
chmod +x ~/Documents/scripts/python/ps_encoder.py


# Install the Veil framework
# https://github.com/Veil-Framework/Veil
# Kali quick install
# Veil was found to already be installed, but when you run veil the program still does need to be configured - 5/14/2022
sudo apt install veil -y
sudo /usr/share/veil/config/setup.sh --force --silent

# Install rlwrap for better / more stable reverse shells
sudo apt install rlwrap

# Install KDE partition manager
sudo apt install -y partitionmanager

sudo apt install -y neofetch lolcat

# Install Kali Undercover - make Kali look like Windows 10
sudo apt install -y kali-undercover

sudo apt autoremove --purge -y


# Configure SAMBA to a minimum SMB version of SMBv2 - for Windows 2016 and above
sudo bash -c 'echo "" >> /etc/samba/smb.conf'
sudo bash -c 'echo "min protocol = SMB2" >> /etc/samba/smb.conf'

# Clone the Invoke-SocksProxy repo
cd ~/exploits
git clone https://github.com/tokyoneon/Invoke-SocksProxy.git
cd ~/

# Download and "install" the penelope.py Advanced Shell Handler
pushd /opt
sudo wget https://raw.githubusercontent.com/brightio/penelope/main/penelope.py
sudo chmod +x penelope.py
popd
pushd /usr/bin
sudo ln -s /opt/penelope.py penelope-reverse-shell
popd

# Download and "install" namemash.py
pushd /opt
sudo wget https://gist.githubusercontent.com/superkojiman/11076951/raw/74f3de7740acb197ecfa8340d07d3926a95e5d46/namemash.py
sudo chmod +x namemash.py
popd
pushd /usr/bin
sudo ln -s /opt/namemash.py namemash
popd

# Download the ConPtyShell for Windows and place it in the ~/transfers directory
pushd ~/transfers
wget https://github.com/antonioCoco/ConPtyShell/releases/download/1.5/ConPtyShell.zip
unzip ConPtyShell.zip
curl https://raw.githubusercontent.com/antonioCoco/ConPtyShell/master/Invoke-ConPtyShell.ps1 -o Invoke-ConPtyShell.ps1
unix2dos Invoke-ConPtyShell.ps1
rm -rf ConPtyShell.zip
popd

# Install pwncat - https://robertscocca.medium.com/upgrade-your-common-hacking-tools-45ba700d42bb
# sudo apt install python3.10-venv
# python3 -m venv pwncat-env
# source pwncat-env/bin/activate
# pip install pwncat-cs

# Download and install 7zip 22.01
pushd ~/Downloads
wget https://www.7-zip.org/a/7z2201-linux-x64.tar.xz
tar -xvf 7z2201-linux-x64.tar.xz 7zzs
tar -xvf 7z2201-linux-x64.tar.xz 7zz
sudo mv 7zz* /usr/bin/
popd

# Install Certipy
# git clone https://github.com/ly4k/Certipy
# cd Certipy
# sudo python3 setup.py install
# cd ..
# sudo rm -rf ~/Certipy/
# 6/4/2023 - RStrom
# the README says to install using pip
## pip3 install certipy-ad
## 2/10/2024 - RStrom - ^^^ commenting out the line above since the new way to install certipy is using the command below
## sudo apt install python3-certipy
## ^^^ 2/10/2024 - RStrom - this does not appear to be necessary anymore (it doesn't want to install anyway due to a conflict with the certipy-ad).
## It appears that certipy-ad is pre-installed and has taken the place of the certipy program

# Install bloodhound python
# 2024-11-06 - this is deprecated now by Bloodhound CE
## pip3 install bloodhound

# Install Bat-Potato
## https://github.com/0x4xel/Bat-Potato
pushd ~/exploits
git clone https://github.com/0x4xel/Bat-Potato.git
chmod +x ./Bat-Potato/Bat-Potato.py
popd

# Pull down the custom Kali .zshrc file from GitHub
cp ~/.zshrc ~/.zshrc.sav
wget https://raw.githubusercontent.com/robertstrom/kali-setup/main/zshrc -O ~/.zshrc
source ~/.zshrc

# Download and extract hashcat kwprocessor Advanced keyboard-walk generator

wget https://github.com/hashcat/kwprocessor/releases/download/v1.00/kwprocessor-1.00.7z
7zz x kwprocessor-1.00.7z
rm -rf kwprocessor-1.00.7z

# Download and extract the hashcat utils

wget https://github.com/hashcat/hashcat-utils/releases/download/v1.9/hashcat-utils-1.9.7z
7zz e hashcat-utils-1.9.7z -ohashcatutils hashcat-utils-1.9/bin/*
rm -rf hashcat-utils-1.9.7z

scriptendtime=$(date)
echo " "
echo "The script started at $scriptstarttime"
echo " "
echo "The script completed at $scriptendtime"
echo " "
echo "The installation and configuration of this new Kali build has completed"
echo "Happy Hacking!"
# source ~/.zshrc
