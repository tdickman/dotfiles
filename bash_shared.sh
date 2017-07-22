platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
    platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
    platform='osx'
fi

set -o vi

# Color for commands
if [[ $platform == 'osx' ]]; then
    export CLICOLOR=1
    export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
fi

# Copy
if [[ $platform == 'linux' ]]; then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
fi

# Color the terminal
# PS1='\[\e[35m\]\h | \W:\[\e[0m\] '
if [ "$SSH_CONNECTION" ]; then
    PS1='\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\W\[\e[0m\] '
else
    PS1='\[\033[01;34m\]\W\[\e[0m\] '
fi

### Yubikey ###
# Enable gpg-agent if it is not running
GPG_AGENT_SOCKET="${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"

# Fall back for 16.04
if [[ $(lsb_release -s -r) = "16.04" ]]; then
    GPG_AGENT_SOCKET="${HOME}/.gnupg/S.gpg-agent.ssh"
fi

if [ ! -S $GPG_AGENT_SOCKET ]; then
  gpg-agent --daemon >/dev/null 2>&1
  export GPG_TTY=$(tty)
fi

# Set SSH to use gpg-agent if it is configured to do so 
GNUPGCONFIG=${GNUPGHOME:-"$HOME/.gnupg/gpg-agent.conf"}
if grep -q enable-ssh-support "$GNUPGCONFIG"; then
  unset SSH_AGENT_PID
  export SSH_AUTH_SOCK=$GPG_AGENT_SOCKET
fi

source ~/.bash_aliases.sh
