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

# Color the terminal
PS1='\[\e[35m\]\h | \W:\[\e[0m\] '

source ~/.bash_aliases.sh
