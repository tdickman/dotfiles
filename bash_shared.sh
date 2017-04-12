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

source ~/.bash_aliases.sh
