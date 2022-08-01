# ~/.zshrc file for zsh interactive shells.
# see /usr/share/doc/zsh/examples/zshrc for examples
#
# This .zshrc file comes from my Kali HTB - TCM instance
# this curernt file was saved and uploaded on 1/10/2020
#

setopt autocd              	# change directory just by typing its name
setopt correct            	# auto correct mistakes
setopt interactivecomments 	# allow comments in interactive mode
setopt magicequalsubst     	# enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           	# hide error message if there is no match for the pattern
setopt notify              	# report the status of background jobs immediately
setopt numericglobsort     	# sort filenames numerically when it makes sense
setopt promptsubst         	# enable command substitution in prompt
setopt EXTENDED_HISTORY		# record command start time
# Turn off setopt INC_APPEND_HISTORY if setopt share_history is enabled
# setopt INC_APPEND_HISTORY
setopt INC_APPEND_HISTORY_TIME	# append command to history file immediately after execution
setopt share_history

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# configure key keybindings
bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=200000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
#setopt share_history         # share command history data

# force zsh to show the complete history
## alias history="history 0"
alias history='history -i 1'

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

configure_prompt() {
    prompt_symbol=㉿
    [ "$EUID" -eq 0 ] && prompt_symbol=💀
    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PROMPT=$'%F{%(#.blue.green)}┌──${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}%n$prompt_symbol%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]\n└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
            RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)'
            ;;
        oneline)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{%(#.red.blue)}%n@%m%b%F{reset}:%B%F{%(#.blue.green)}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
        backtrack)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{red}%n@%m%b%F{reset}:%B%F{blue}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
    esac
}

# The following block is surrounded by two delimiters.
# These delimiters must not be modified. Thanks.
# START KALI CONFIG VARIABLES
PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=yes
# STOP KALI CONFIG VARIABLES

if [ "$color_prompt" = yes ]; then
    # override default virtualenv indicator in prompt
    VIRTUAL_ENV_DISABLE_PROMPT=1

    configure_prompt

    # enable syntax-highlighting
    if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && [ "$color_prompt" = yes ]; then
        . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
        ZSH_HIGHLIGHT_STYLES[default]=none
        ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
        ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[global-alias]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[path]=underline
        ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[command-substitution]=none
        ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[process-substitution]=none
        ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[assign]=none
        ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
        ZSH_HIGHLIGHT_STYLES[named-fd]=none
        ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
        ZSH_HIGHLIGHT_STYLES[arg0]=fg=green
        ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
    fi
else
    PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%# '
fi
unset color_prompt force_color_prompt

toggle_oneline_prompt(){
    if [ "$PROMPT_ALTERNATIVE" = oneline ]; then
        PROMPT_ALTERNATIVE=twoline
    else
        PROMPT_ALTERNATIVE=oneline
    fi
    configure_prompt
    zle reset-prompt
}
zle -N toggle_oneline_prompt
bindkey ^P toggle_oneline_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty)
    TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%n@%m: %~\a'
    ;;
*)
    ;;
esac

precmd() {
    # Print the previously configured title
    print -Pnr -- "$TERM_TITLE"

    # Print a new line before the prompt, but only if it is not the first line
    if [ "$NEWLINE_BEFORE_PROMPT" = yes ]; then
        if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
            _NEW_LINE_BEFORE_PROMPT=1
        else
            print ""
        fi
    fi
}

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

# some more ls aliases
## alias ll='ls -l'
## alias la='ls -A'
## alias l='ls -CF'

alias cls='clear'

alias ls='exa'                                                              # ls
alias l='exa -lbF'                                                          # list, size, type, git
alias ll='exa -lbGF'                                                        # long list
alias llm='exa -lbGF --sort=modified'                                       # long list, modified date sort
alias la='exa -lbhHigUmuSa --time-style=long-iso --color-scale'             # all list
alias lx='exa -lbhHigUmuSa@ --time-style=long-iso --color-scale'            # all + extended list
alias lS='exa -1'			                                    # one column, just names
alias lt='exa --tree --level=2'                                             # tree
# requires that xclip be installed
# Alias to send text from terminal to clipboard
# This is usually via using cat to output the file and then pipe it to xclip
alias clip="xclip -selection clipboard -rmlastnl"
## 2022-07-16 - Trying new xclip aliases
# alias xclip='xclip -selection clipboard -rmlastnl'
alias paste="xclip -selection clipboard -o"

# alias to TCM Course directory
alias TCM-PenDir='cd Documents/TCM\ Practical\ Ethical\ Hacking\ -\ The\ Complete\ Course/'

# alias to VMware Shared folder /mnt/hgfs/host
alias SharedHostFolder="cd /mnt/hgfs/host"

# alias for wordlists from specific directories
alias fzf-wordlists='find /usr/share/seclists /usr/share/wordlists /usr/share/dirbuster /usr/share/wfuzz /usr/share/dirb -type f | fzf'

# enable auto-suggestions based on the history
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # change suggestion color
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi

# enable command-not-found if installed
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi

# Created by `pipx` on 2021-12-13 05:44:31
export PATH="$PATH:/home/rstrom/.local/bin"


# Functions added - 4/10/2022 RStrom
function grepEmailAddresses() {
	grep -E -o "\b[a-zA-Z0-9.-]+@[a-zA-Z0-9.-](+.|&#46;)[a-zA-Z0-9.-]+\b" $1
}

function grepURLs() {
	grep -oE '\b(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]' $1
}

function convertFromHexGetURLs() {
	## Original regex
	## sed "s/<script language.*('//g" $1 | sed "s/').*$//g" | xxd -r -p | grep -oE '\b(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]'
	sed "s/<script.*('//g" $1 |  sed "s/').*$//g" | sed "/<script/,/<\/script>/d" | sed "/<html/,/<\/html>/d"  | xxd -r -p | grep -oE '\b(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]'
}

function convertFromHexGetEmail() {
	sed "s/<script language.*('//g" $1 | sed "s/').*$//g" | xxd -r -p | sed "s/&#46;/./g" | grep -E -o "\b[a-zA-Z0-9.-]+@[a-zA-Z0-9.-](+.|&#46;)[a-zA-Z0-9.-]+\b"
}

get-geoiplookup-io() {
	#do things with parameters like $1 such as
	curl --insecure https://json.geoiplookup.io/geo/"$1"
}

get-geoipinfo-io() {
	#do things with parameters like $1 such as
	curl --insecure https://ipinfo.io/"$1"
}


OffSec-openvpn-connection() {
sudo openvpn ~/Documents/OpenVPN/offsec_pwk_2022-03-05_3.ovpn
}


HTB-UDP-openvpn-connection() {
sudo openvpn ~/Documents/OpenVPN/lab_HuntingWabbits_UDP.ovpn
}

HTB-443-openvpn-connection() {
sudo openvpn ~/Documents/OpenVPN/lab_HuntingWabbits_443.ovpn
}

zsh-prompt-tun0() {
PS1="%F{%(#.blue.green)}┌──${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}%n$prompt_symbol%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}] %W %t $(ifconfig | grep -A 1 tun0 | grep inet | tr -s ' ' | cut -d ' ' -f 3) %{$reset_color%}
└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset}"
}

zsh-prompt-eth0() {
PS1="%F{%(#.blue.green)}┌──${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}%n$prompt_symbol%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}] %W %* $(ifconfig | grep -A 1 eth0 | grep inet | tr -s ' ' | cut -d ' ' -f 3) %{$reset_color%}
└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset}"
}

TryHackMe-openvpn-connection() {
sudo openvpn ~/Documents/OpenVPN/AnalogKid.ovpn
}

Shrink-Disk() {
sudo vmware-toolbox-cmd disk shrink /
}

start-python-httpserver-80() {
python -m SimpleHTTPServer 80
}

start-python3-httpserver-80() {
python3 -m http.server 80
}

start-python3-HTTPUploadServer() {
python3 -m uploadserver 80
}

start-python-ftp-server() {
python3 -m pyftpdlib -p 21 --write
}

start-apache-web-server() {
	echo "The Apache web servers directory is /var/www/html/"
	sudo systemctl start apache2
}

stop-apache-web-server() {
	sudo systemctl stop apache2
}

start-metasploit-database() {
	sudo systemctl start postgresql
}

start-bash-shell-for-reverse-shell() {
	exec bash --login
	ps -p $$
}

set-rdp-connection-info() {
    echo "Please enter the username"
    read rdp_user_name
    echo "Please enter the password"
    read rdp_password
    echo "Please enter the IP Address"
    read rdp_ip_address
}

get-rdp-connection-info() {
    echo "The RDP username is: $rdp_user_name"
    echo "The RDP password is: $rdp_password"
    echo "The RDP IP Address is: $rdp_ip_address"
}

unset-rdp-connection-info() {
    unset read rdp_user_name
    unset rdp_password
    unset rdp_ip_address
}

start-rdp-connection() {
    # echo "Please enter the username"
    # read rdp_user_name
    # echo "Please enter the password"
    # read rdp_password
    # echo "Please enter the IP Address"
    # read rdp_ip_address
    rdesktop -z -P -x m -u $rdp_user_name -p $rdp_password $rdp_ip_address
}

start-rdp-connection-disk-redirection() {
    # echo "Please enter the username"
    # read rdp_user_name
    # echo "Please enter the password"
    # read rdp_password
    # echo "Please enter the IP Address"
    # read rdp_ip_address
    rdesktop -z -P -x m -u $rdp_user_name -p $rdp_password -r disk:local="/home/rstrom/" $rdp_ip_address
}

start-xfreerdp-connection() {
    # echo "Please enter the username"
    # read rdp_user_name
    # echo "Please enter the password"
    # read rdp_password
    # echo "Please enter the IP Address"
    # read rdp_ip_address
    xfreerdp /cert-ignore /compression /u:$rdp_user_name /p:$rdp_password /w:1366 /h:768 /v:$rdp_ip_address /smart-sizing +auto-reconnect +clipboard 
}

connect-QNAP-sshfs() {
sshfs rstrom@qnap: ~/QNAPMyDocs
}

connect-rstrom-XPS-15-9550-sshfs() {
sshfs rstrom@rstrom-XPS-15-9550: ~/RStromXPS15
}

connect-QNAP-VirtualMachines-sshfs() {
sshfs qnap:'/share/CACHEDEV1_DATA/Virtual Machines/' ~/QNAPVirtualMachines
}

connect-remote-SMB-share() {
    echo "Please enter the SMB username"
    read smb_user_name
    echo "Please enter the SMB password"
    read smb_user_password
    echo "Please enter the IP Address of the SMB server to connect to"
    read smb_ip_address
    echo "Please enter the name of the SMB share to connect to"
    read smb_share
    sudo mount -t cifs -o gid=1000,uid=1000,vers=2.0,username=$smb_user_name,password=$smb_user_password //$smb_ip_address/$smb_share /home/rstrom/SMBMount
}

connect-remote-SMB-share-alt-port() {
    echo "Please enter the SMB username"
    read smb_user_name
    echo "Please enter the SMB password"
    read smb_user_password
    echo "Please enter the IP Address of the SMB server to connect to"
    read smb_ip_address
    echo "Please enter the name of the SMB share to connect to"
    read smb_share
    echo "Please enter the alternate port of the SMB share to connect to"
    read smb_port    
    sudo mount -t cifs -o gid=1000,uid=1000,vers=2.0,username=$smb_user_name,password=$smb_user_password,port=$smb_port //$smb_ip_address/$smb_share /home/rstrom/SMBMount
}

connect-remote-SMB-domain-share() {
    echo "Please enter the SMB username"
    read smb_user_name
    echo "Please enter the SMB password"
    read smb_user_password
    echo "Please enter the name of the Windows domain"
    read smb_domain_name
    echo "Please enter the IP Address of the SMB server to connect to"
    read smb_ip_address
    echo "Please enter the name of the SMB share to connect to"
    read smb_share
    sudo mount -t cifs -o gid=1000,uid=1000,vers=2.0,username=$smb_user_name,domain=$smb_domain_name,password=$smb_user_password //$smb_ip_address/$smb_share /home/rstrom/SMBMount
}

connect-remote-SMB-share-guest() {
    echo "Please enter the IP Address of the SMB server to connect to"
    read smb_ip_address
    echo "Please enter the name of the SMB share to connect to"
    read smb_share
    sudo mount -t cifs -o gid=1000,uid=1000,vers=2.0,username=guest,password="" //$smb_ip_address/$smb_share /home/rstrom/SMBMount
}


disconnect-remote-SMB-share() {
cd ~
sudo umount /home/rstrom/SMBMount
}

nmap-xml-to-html() {
infile=$1
outfile=$(echo $infile | sed 's/xml/html/')
xsltproc $infile -o $outfile
}

convert-NT-DateTime() {
	echo "Please enter the NT Date String"
	read ntdate
	nanotime="$ntdate"
	let "seconds = (($nanotime / 10000000))"
	let "epoch = (($seconds - 11644473600))"
	echo ""
	echo "The NT timestamp conversion translates to this date and time:"
	date -d@$epoch
}

delete-hashcat-potfile() {
rm  /home/rstrom/.local/share/hashcat/hashcat.potfile
}

delete-john-potfile() {
rm  /home/rstrom/.john/john.pot
}

list-hashcat-potfile() {
echo "The contents of the /home/rstrom/.local/share/hashcat/hashcat.potfile file is:"
echo ""
cat  /home/rstrom/.local/share/hashcat/hashcat.potfile
}

list-john-potfile() {
echo "The contents of the /home/rstrom/.john/john.pot file is:"
echo ""
cat  /home/rstrom/.john/john.pot
}

ConvertTo-NTLMPasswordHash() {
smbencrypt $1
}

### When using Kerberos cache credentials for things like impacket-smbclient, impacket-psexec, etc.
### Path to the Kerberos ccache files need to be the full path, not the relative path
### NOT This:
### KRB5CCNAME=~/SamiraA.ccache
### This:
### KRB5CCNAME=/home/rstrom/SamiraA.ccache
