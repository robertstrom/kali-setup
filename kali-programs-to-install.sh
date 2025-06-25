#!/bin/bash

scriptstarttime=$(date)


# Kali Setup programs to be installed and configuration changes needed

### 2025-04-06 - Major rework to identify which CPU architechture the OS is running (Intel/AMD or ARM in particular)
### Also removed old packages that are no longer available, moved some python based programs to use pipx instead of pip
### Modified a few installs to read the latest version that is available on GitHub and install that version instead of a
## static version definition

### 2025-01-26 - Major modifications to clean things up ###

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
# The wget command below is the old method of kicking off the script on a new Kali build
# This needed to be changed when I added the prompt to change the machine name
# The read -p command would not work with wget but it does work with the curl command
# wget -O - https://raw.githubusercontent.com/robertstrom/kali-setup/main/kali-programs-to-install.sh | bash
# See this post for more information
# https://www.reddit.com/r/learnprogramming/comments/23kiz9/read_command_in_bash_script_not_waiting_for_user/
#
################################################################################################################################################
#                                   Use the curl command below to start the script
# 
#  bash <(curl --silent https://raw.githubusercontent.com/robertstrom/kali-setup/main/kali-programs-to-install.sh) | tee kali-install-script.log
#
#
################################################################################################################################################

## This collection of information is designed to make it easier to get a Kali instance to a standardized desired base configuration point
## so that it is fully functional with all expected software installed.

# For a VM install - setup shared folder
# See these articles
# https://kb.vmware.com/s/article/60262
# https://docs.vmware.com/en/VMware-Tools/11.2/rn/VMware-Tools-1125-Release-Notes.html#vmware-tools-issues-in-vmware-workstation-or-fusion-known
# Configure shared folder in VMware to point to the folder on the VMware host and leave shared folders enable
# Add this line to the /etc/fstab file
# .host:/    /mnt/hgfs        fuse.vmhgfs-fuse    defaults,allow_other    0    0
## sudo bash -c 'echo ".host:/    /mnt/hgfs        fuse.vmhgfs-fuse    defaults,allow_other    0    0" >> /etc/fstab'


## RStrom - 5/28/2023 - Added all group memberships below
## sudo adduser rstrom sudo


### For VirtualBox ###
## sudo adduser rstrom vboxsf
## sudo adduser rstrom kaboxer
## sudo adduser rstrom wireshark
## sudo adduser rstrom adm
## sudo adduser rstrom cdrom
## sudo adduser rstrom floppy
## sudo adduser rstrom audio
## sudo adduser rstrom dip
## sudo adduser rstrom video
## sudo adduser rstrom plugdev
## sudo adduser rstrom netdev
## sudo adduser rstrom bluetooth
## sudo adduser rstrom scanner

### End for VirtualBox


## pimpmykali - https://github.com/Dewalt-arch/pimpmykali
# sudo git clone https://github.com/Dewalt-arch/pimpmykali /opt/pimpmykali
# rm -rf /opt/pimpmykali/
# cd /opt/pimpmykali
# sudo ./pimpmykali.sh
# cd  /

# 2025-04-13 - Added prompt to set the hostname
# Setting hostname
read -p "What is the hostname of this machine? " sethostname
sudo hostnamectl set-hostname $sethostname
# Fixing the hostname in the /etc/hostname file - uses the variable set above when setting the hostname
getprevhostname=$(grep 127.0.1.1 /etc/hosts | awk '{ print $2 }')
sudo  sed -i "s/$getprevhostname/$sethostname/" /etc/hosts

# 2024-11-06
# create a ~/.screenrc file so that it is possible to scroll when using screen
touch ~/.screenrc
echo "# Enable mouse scrolling and scroll bar history scrolling" > ~/.screenrc
echo "termcapinfo xterm* ti@:te@" >> ~/.screenrc

## Create directory for storing downloads, etc.

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

## Create a directory for copying down prebuilt Docker Images from NAS
mkdir ~/Docker-Images

# Setup fuse group and add user to fuse group for sshfs use
sudo groupadd fuse
sudo usermod -a -G fuse rstrom

sudo DEBIAN_FRONTEND=noninteractive apt update && sudo DEBIAN_FRONTEND=noninteractive apt full-upgrade -yq

# PSTools
# Additional Sysinternals tools needed
# procdump

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
pushd ~/transfers
wget https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy32
wget https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy32s
wget https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy64
wget https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy64s
chmod +x ~/transfers/pspy32
chmod +x ~/transfers/pspy32s
chmod +x ~/transfers/pspy64
chmod +x ~/transfers/pspy64s
popd

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
## pushd ~/Downloads
## wget https://www.nomachine.com/free/linux/64/deb -O nomachine.deb
## sudo dpkg -i nomachine.deb
## popd

## Install ShellCheck - A shell script static analysis tool
## https://github.com/koalaman/shellcheck#user-content-in-your-editor
## Install progress viewer
# Install Geany IDE / Editor
## 2024-09-23  - Added ripgrep pandoc poppler-utils ffmpeg to support ripgrep-al - https://github.com/phiresky/ripgrep-all?tab=readme-ov-file
## Also see this ripgrep-all blog  https://phiresky.github.io/blog/2019/rga--ripgrep-for-zip-targz-docx-odt-epub-jpg/
## 2024-10-28 - added zbar-tools to the list of programs to install. zbar-tools has the zbarimg command to analyze barcodes at the command line. Including QR codes
## 2024-11-09 - Added gnupg2 because it is a dependency for 1password
## 2024-11-09 - Added the install of vivaldi

arch=$(uname -m)

case "$arch" in
  x86_64|amd64)
    sudo DEBIAN_FRONTEND=noninteractive apt install -yq shellcheck libimage-exiftool-perl pv terminator copyq xclip dolphin krusader kdiff3 krename kompare xxdiff krename kde-spectacle \
    flameshot html2text csvkit remmina kali-wallpapers-all hollywood-activate kali-screensaver gridsite-clients shellter sipcalc fd-find \
    xsltproc rinetd torbrowser-launcher httptunnel kerberoast tesseract-ocr ncdu grepcidr speedtest-cli sshuttle mpack filezilla lolcat \
    ripgrep bat dcfldd redis-tools feroxbuster name-that-hash jq keepassxc okular exfat-fuse exfatprogs kate xsel pandoc poppler-utils ffmpeg \
    zbar-tools gnupg2 dc3dd rlwrap partitionmanager kali-undercover fastfetch hyfetch lolcat 7zip-standalone eza autorecon docker.io docker-cli \
    obsidian breeze-icon-theme trufflehog python3-trufflehogregexes coercer golang-go ligolo-ng sublist3r tcpspy xrdp mono-complete
    ;;
  i?86)
    echo "Architecture: x86 (32-bit)"
    ;;
  arm*)
    echo "Architecture: ARM"
    ;;
  aarch64)
    echo "Architecture: AArch64 (64-bit ARM)"
    mkdir ~/Downloads
    sudo DEBIAN_FRONTEND=noninteractive apt install -yq shellcheck libimage-exiftool-perl pv terminator copyq xclip dolphin krusader kdiff3 krename kompare xxdiff krename kde-spectacle \
    flameshot html2text csvkit remmina kali-wallpapers-all hollywood-activate kali-screensaver gridsite-clients sipcalc \
    xsltproc rinetd httptunnel kerberoast tesseract-ocr ncdu grepcidr speedtest-cli sshuttle mpack filezilla lolcat \
    ripgrep bat dcfldd redis-tools feroxbuster name-that-hash jq keepassxc okular exfat-fuse exfatprogs kate xsel pandoc poppler-utils ffmpeg \
    zbar-tools gnupg2 dc3dd rlwrap partitionmanager kali-undercover fastfetch hyfetch lolcat 7zip-standalone eza autorecon docker.io docker-cli \
    obsidian breeze-icon-theme trufflehog python3-trufflehogregexes coercer golang-go ligolo-ng sublist3r tcpspy xrdp libraspberrypi-bin
    ;;
  ppc64le)
    echo "Architecture: PowerPC 64-bit Little Endian"
    ;;
  *)
    echo "Architecture: Unknown ($arch)"
    ;;
esac

# Enab;le the ssh service
sudo systemctl enable ssh --now

# Enable the docker service
sudo systemctl enable docker --now

## Enable the xrdp service
sudo systemctl enable xrdp --now

# Add the currenbt user to the docker group so that you don't need to use sudo to run docker commands
sudo usermod -aG docker $USER

# Install docker compose

## One way of getting the current version information from GitHub
## curl -Ls https://api.github.com/repos/docker/compose/releases/latest | jq -r ".assets[].browser_download_url" | grep -v '\.json\|\.sha256'

## An alternate way of getting the current version information from GitHub
## curl -Ls https://api.github.com/repos/docker/compose/releases/latest | grep browser_download | egrep linux-aarch64\"$ | awk -F"\""  '{ print $4 }'

dockercomposelatestamd64=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r ".assets[].browser_download_url" | grep docker-compose-linux-x86_64$)
dockercomposelatestaarch64=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r ".assets[].browser_download_url" | grep docker-compose-linux-aarch64$)
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins

case "$arch" in
  x86_64|amd64)
    echo "Architecture: x86-64 (64-bit)"
    wget $dockercomposelatestamd64 -O $DOCKER_CONFIG/cli-plugins/docker-compose
    ;;
  i?86)
    echo "Architecture: x86 (32-bit)"
    ;;
  arm*)
    echo "Architecture: ARM"
    ;;
  aarch64)
    echo "Architecture: AArch64 (64-bit ARM)"
    wget $dockercomposelatestaarch64 -O $DOCKER_CONFIG/cli-plugins/docker-compose
    ;;
  ppc64le)
    echo "Architecture: PowerPC 64-bit Little Endian"
    ;;
  *)
    echo "Architecture: Unknown ($arch)"
    ;;
esac

chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

# Install python virtual environments venv
pip install virtualenv

# pipx ensurepath
pipx ensurepath
## sudo pipx ensurepath --global # optional to allow pipx actions with --global argument

## 2024-11-09 - Added the install of 1password
pushd ~/Downloads

case "$arch" in
  x86_64|amd64)
    echo "Architecture: x86-64 (64-bit)"
    wget https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb
    sudo dpkg -i 1password-latest.deb
    ;;
  i?86)
    echo "Architecture: x86 (32-bit)"
    ;;
  arm*)
    echo "Architecture: ARM"
    ;;
  aarch64)
    ## https://support.1password.com/install-linux/#arm-or-other-distributions-targz
    echo "Architecture: AArch64 (64-bit ARM)"
    curl -sSO https://downloads.1password.com/linux/tar/stable/aarch64/1password-latest.tar.gz
    sudo tar -xf 1password-latest.tar.gz
    sudo mkdir -p /opt/1Password
    sudo mv 1password-*/* /opt/1Password
    sudo /opt/1Password/after-install.sh
    rm -rf 1password*
    ;;
  ppc64le)
    echo "Architecture: PowerPC 64-bit Little Endian"
    ;;
  *)
    echo "Architecture: Unknown ($arch)"
    ;;
esac
popd

# Download and install VS Code
# Used to be able to install VS Code via apt install code-oss but that package does not appear to be available in the repo anymore
pushd ~/Downloads
wget -O vscode-latest-x64.deb https://update.code.visualstudio.com/latest/linux-deb-x64/stable
sudo dkpg -i vscode-latest-x64.deb
popd

# i3 program installs
## sudo apt install kali-desktop-i3
## sudo apt install feh
## Need to add these line to the i3 config file for copyq
## for_window [instance="^copyq$" class="^copyq$"] border pixel 1, floating enable
## exec copyq
## Font Awesome font cheatsheet
## https://fontawesome.com/v5/cheatsheet/free/solid
## Font Awesome version 5 fonts - has TTF fonts
## https://github.com/FortAwesome/Font-Awesome/releases/download/5.0.6/fontawesome-free-5.0.6.zip
## link to the - Yosemite San Francisco Font - https://github.com/supermarin/YosemiteSanFranciscoFont/archive/master.zip


## pull down the ripgrep-all binary and move the executables to the /usr/bin directory
## One way of getting the current version information from GitHub
ripgrepamd64=$(curl -s https://api.github.com/repos/phiresky/ripgrep-all/releases/latest | jq -r ".assets[].browser_download_url" | grep x86_64-unknown-linux-musl)
ripgreparm=$(curl -s https://api.github.com/repos/phiresky/ripgrep-all/releases/latest | jq -r ".assets[].browser_download_url" | grep arm-unknown-linux-gnueabihf)
ripgrepversion=$(echo $ripgreparm | awk -F"/" '{ print $8 }')

## An alternate way of getting the current version information from GitHub
## curl -s https://api.github.com/repos/phiresky/ripgrep-all/releases/latest | grep browser_download

pushd ~/Downloads

case "$arch" in
  x86_64|amd64)
    echo "Architecture: x86-64 (64-bit)"
    wget $ripgrepamd64
    tar -xzvf ripgrep_all-$ripgrepversion-x86_64-unknown-linux-musl.tar.gz
    sudo mv ./ripgrep_all-$ripgrepversion-x86_64-unknown-linux-musl/rga* /usr/bin
    rm -rf ./ripgrep_all-$ripgrepversion-x86_64-unknown-linux-musl
    rm -rf ./ripgrep_all-$ripgrepversion-x86_64-unknown-linux-musl*.gz*
    ;;
  i?86) 
    echo "Architecture: x86 (32-bit)"
    ;;
  arm*)
    echo "Architecture: ARM"
    ;;
  aarch64)
    echo "Architecture: AArch64 (64-bit ARM)"
    wget $ripgreparm
    tar -xzvf ripgrep_all-$ripgrepversion-arm-unknown-linux-gnueabihf.tar.gz
    sudo mv ./ripgrep_all-$ripgrepversion-arm-unknown-linux-gnueabihf/rga* /usr/bin
    rm -rf ./ripgrep_all-$ripgrepversion-arm-unknown-linux-gnueabihf
    rm -rf ./ripgrep_all-$ripgrepversion-arm-unknown-linux-gnueabihf*.gz*
    ;;
  ppc64le)
    echo "Architecture: PowerPC 64-bit Little Endian"
    ;;
  *)
    echo "Architecture: Unknown ($arch)"
    ;;
esac

popd

pushd ~/Downloads

## PowerShell install for ARM

case "$arch" in
  aarch64)
    echo "Architecture: AArch64 (64-bit ARM)"
    pushd ~/Downloads
    bits=$(getconf LONG_BIT)
    powershellarm=$(curl -sL https://api.github.com/repos/PowerShell/PowerShell/releases/latest | jq -r ".assets[].browser_download_url" | grep "linux-arm${bits}.tar.gz")
    powershellversion=$(echo $powershellarm | awk -F"-" '{ print $2 }')
    curl -Ls $powershellarm -o powershell.tar.gz
    # Create the target folder where powershell will be placed
    sudo mkdir -p /opt/microsoft/powershell/7
    # Expand powershell to the target folder
    sudo tar zxf ./powershell.tar.gz -C /opt/microsoft/powershell/7
    # Set execute permissions
    sudo chmod +x /opt/microsoft/powershell/7/pwsh
    # Create the symbolic link that points to pwsh
    sudo ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh
    rm -rf powershell.tar.gz
        ;;
  *)
    echo "Architecture: Unknown ($arch)"
    ;;
esac

popd

## Snaffler download

case "$arch" in
  x86_64|amd64)
    echo "Architecture: x86-64 (64-bit)"
    pushd ~/exploits
    snafflerdownload=$(curl -s https://api.github.com/repos/SnaffCon/Snaffler/releases/latest | jq -r ".assets[].browser_download_url")
    wget $snafflerdownload
    chmod a+x ./Snaffler.exe
    wget https://raw.githubusercontent.com/zh54321/SnafflerParser/refs/heads/main/snafflerParser.ps1
    chmod a+x ./snafflerParser.ps1
        ;;
  *)
    echo "Architecture: Unknown ($arch)"
    ;;
esac

popd

# Setting up link to bat for the batcat install
ln -s /usr/bin/batcat ~/.local/bin/bat

# Install fzf via github
git clone --depth 1 https://github.com/junegunn/fzf.git
cd ~/fzf
./install --all
cd ~/

# Install rustscan
# https://overide.medium.com/rustscan-fcbdb93e17c9
# https://github.com/RustScan/RustScan/wiki/Installation-Guide
# https://github.com/RustScan/RustScan/releases/
## Get latest version information
## curl -s https://api.github.com/repos/bee-san/RustScan/releases/latest | jq -r ".assets[].browser_download_url"

rustscanlatestamd64=$(curl -s https://api.github.com/repos/bee-san/RustScan/releases/latest | jq -r ".assets[].browser_download_url" | grep x86_64-linux-rustscan.tar.gz.zip)
rustscanlatestaarch64=$(curl -s https://api.github.com/repos/bee-san/RustScan/releases/latest | jq -r ".assets[].browser_download_url" | grep aarch64-linux-rustscan.zip)

pushd ~/Downloads

case "$arch" in
  x86_64|amd64)
    echo "Architecture: x86-64 (64-bit)"
    wget $rustscanlatestamd64
    unzip x86_64-linux-rustscan.tar.gz.zip
    tar -xzvf x86_64-linux-rustscan.tar.gz
    sudo mv ./rustscan /usr/bin
    rm -rf ./x86_64-linux-rustscan.tar.gz.zip
    rm -rf ./x86_64-linux-rustscan.tar.gz
    ;;
  i?86) 
    echo "Architecture: x86 (32-bit)"
    ;;
  arm*)
    echo "Architecture: ARM"
    ;;
  aarch64)
    echo "Architecture: AArch64 (64-bit ARM)"
    wget $rustscanlatestaarch64
    unzip aarch64-linux-rustscan.zip
    sudo mv ./rustscan /usr/bin
    rm -rf ./aarch64-linux-rustscan.zip
    ;;
  ppc64le)
    echo "Architecture: PowerPC 64-bit Little Endian"
    ;;
  *)
    echo "Architecture: Unknown ($arch)"
    ;;
esac

popd


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


# Install Windows Exploit Suggester - Next Generation (WES-NG)
git clone https://github.com/bitsadmin/wesng --depth 1

# Install AutoRecon
# https://github.com/Tib3rius/AutoRecon
## This is now an installable package via apt install
## python3 -m pip install git+https://github.com/Tib3rius/AutoRecon.git


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

# Install glow terminal markdown renderer
# https://github.com/charmbracelet/glow?tab=readme-ov-file
go install github.com/charmbracelet/glow@latest

## Autoenum
wget https://github.com/Gr1mmie/autoenum/archive/refs/tags/v3.zip
unzip v3.zip
rm v3.zip

## Updog web server
## https://github.com/sc0tfree/updog
pipx install updog

## The mkpsrevshell.py script from - https://gist.github.com/tothi/ab288fb523a4b32b51a53e542d40fe58
## This script creates an encoded PowerShell reverse shell
## I have created a copy of this script renaming it to make-powershell-base64-reverse-shell.py


# Install kerbrute
pipx install kerbrute

# Install wine
## sudo dpkg --add-architecture i386 && sudo apt-get update && sudo apt-get install wine32 -y


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
pipx install uploadserver
## Usage = python3 -m uploadserver
## python3 -m uploadserver 80

# Install atftp TFTP server
## sudo apt install atftp -y
# Configure the home directory for the TFTP server files
## sudo mkdir /tftp
# Configure the permissions for the TFTP server files
## sudo chown nobody: /tftp
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
## sudo apt install veil -y
## sudo /usr/share/veil/config/setup.sh --force --silent

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


# Install Bat-Potato
## https://github.com/0x4xel/Bat-Potato
pushd ~/exploits
git clone https://github.com/0x4xel/Bat-Potato.git
chmod +x ./Bat-Potato/Bat-Potato.py
popd

# Download and extract hashcat kwprocessor Advanced keyboard-walk generator

wget https://github.com/hashcat/kwprocessor/releases/download/v1.00/kwprocessor-1.00.7z
7zz x kwprocessor-1.00.7z
rm -rf kwprocessor-1.00.7z

# Download and extract the hashcat utils

wget https://github.com/hashcat/hashcat-utils/releases/download/v1.9/hashcat-utils-1.9.7z
7zz e hashcat-utils-1.9.7z -ohashcatutils hashcat-utils-1.9/bin/*
rm -rf hashcat-utils-1.9.7z


israspberrypi=$(uname -n)
if [[ "$israspberrypi" == "kali-raspberrypi" ]]; then
    chsh -s /bin/zsh
fi

## export qnap='192.168.0.99'

# Download all current Sysinternals tools to the ~/transfers/Sysinternals directory
# sshfs rstrom@$qnap: ~/QNAPMyDocs -oStrictHostKeyChecking=accept-new
# pushd '/home/rstrom/QNAPMyDocs/My Documents/IRTools/Sysinternals'
wget https://download.sysinternals.com/files/SysinternalsSuite.zip
unzip SysinternalsSuite.zip -d ~/transfers/Sysinternals/
rm -rf SysinternalsSuite.zip

## Download prebuilt Docker images from Dropbox

case "$arch" in
  x86_64|amd64)
    echo "Architecture: x86-64 (64-bit)"
    pushd ~/Docker-Images
    # scp rstrom@qnap:/share/CACHEDEV1_DATA/VM-Backups/Docker-container-backups/*.tar ./
    # loading the saved Docker images to make them available for use
    # using sg to run the docker load command as the docker user since the new group member for the logged in user has not taken effect yet (needs to load a new shell instance)
    ## Ubuntu 14.04 Docker Image
    wget "https://www.dropbox.com/scl/fi/t3scttx9x84hszbodxgk8/ubuntu1404_docker_container.tar.gz?rlkey=e8gl96ig07jobbr0p468t45nf&st=d55sfy85&dl=1" -O ubuntu1404_docker_container.tar.gz
    gzip -d ubuntu1404_docker_container.tar.gz
    ## Ubuntu 16.04 Docker Image
    wget "https://www.dropbox.com/scl/fi/zip2srqcq5xpv7zh98ggu/ubuntu1604_docker_container.tar.gz?rlkey=1wvz45cpuohj53gqfpt4bmrca&st=eszeq0j4&dl=1" -O ubuntu1604_docker_container.tar.gz
    gzip -d ubuntu1604_docker_container.tar.gz
    ## Ubuntu 18.04 Docker Image
    wget "https://www.dropbox.com/scl/fi/nbaj9d7ple4pa39brnei0/ubuntu1804_docker_container.tar.gz?rlkey=sfkeb3uy8ujm5n3rcs176slxp&st=d9daops3&dl=1" -O ubuntu1804_docker_container.tar.gz
    gzip -d ubuntu1804_docker_container.tar.gz
    ## Ubuntu 20.04 Docker Image
    wget "https://www.dropbox.com/scl/fi/40xttbut5zdgyu03kkuht/ubuntu2004_docker_container.tar.gz?rlkey=e3u3pqyg148qqie4og8haul25&st=9l25pzwm&dl=1" -O ubuntu2004_docker_container.tar.gz
    gzip -d ubuntu2004_docker_container.tar.gz
    for i in $(ls ./*tar); do sg docker -c "docker load --input  $i"; done
    rm -rf ubuntu*.tar
    ;;
  *)
    echo "Architecture: Unknown ($arch)"
    ;;
esac

popd


# Install SIETpy3 - SIET - Cisco Smart Install Exploitation Tool
# https://github.com/Sab0tag3d/SIETpy3 - python3 rewrite
# https://github.com/frostbits-security/SIET - original python2 version with documentation
cd ~
sudo git clone https://github.com/Sab0tag3d/SIETpy3.git /opt/sietpy3
cd /opt/sietpy3
cd /usr/bin
sudo ln -s /opt/sietpy3/siet.py siet

# Installing uv
# See - UV vs. PIP: Revolutionizing Python Package Management
# https://medium.com/@sumakbn/uv-vs-pip-revolutionizing-python-package-management-576915e90f7e
 curl -LsSf https://astral.sh/uv/install.sh | sh


# Creating a link to the fdfind binary so that it can be launched using the command fd
ln -s $(which fdfind) ~/.local/bin/fd


# Pull down the custom Kali .zshrc file from GitHub
cp ~/.zshrc ~/.zshrc.sav
wget https://raw.githubusercontent.com/robertstrom/kali-setup/main/zshrc -O ~/.zshrc
## source ~/.zshrc

scriptendtime=$(date)
echo " "
echo "The script started at $scriptstarttime"
echo " "
echo "The script completed at $scriptendtime"
echo " "
echo "The installation and configuration of this new Kali build has completed"
echo "Happy Hacking\!"
# source ~/.zshrc
## read -rsp $'Press any key to reboot, or wait 10 seconds and the system will reboot automatically ...\n' -n 1 -t 10;

## sudo apt autoremove --purge -y
## sudo reboot
