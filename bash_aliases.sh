platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
    platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
    platform='osx'
fi

# Kubernetes
alias k=kubectl
function gproject { gcloud config set project "$1"; }
export gproject
function gcluster { gcloud config set container/cluster "$1"; gcloud container clusters get-credentials "$1"; }
export -f gcluster
function gswitch { gproject "$1"; gcluster "$2"; }
export -f gswitch
function gdockerlogin { docker login -u _token -p $(gcloud auth print-access-token) https://gcr.io; }
export -f gdockerlogin
# Deploys the kubernetes project in the current directory to the labs-sandbox cluster
function kup {
    project=${PWD##*/};
    # TODO: Make this faster by only updating the project / cluster if it is not currently correct
    gswitch labs-sandbox logging-cluster;

    # Generate a uuid for the build process
    uuid=$(uuidgen)
    
    docker build -t gcr.io/labs-sandbox/${project}:${uuid} .
    gcloud docker push gcr.io/labs-sandbox/${project}:${uuid}
    sed "s/IMAGENAME/gcr.io\/labs-sandbox\/${project}:${uuid}/g" controller.yaml | kubectl apply -f -
}
export -f kup
function ks {
    export CONTEXT=$(kubectl config view | awk '/current-context/ {print $2}');
    kubectl config set-context $CONTEXT --namespace="$1";
}
export -f ks
alias kdown="kubectl delete -f ."

transfer() { 
    # check arguments
    if [ $# -eq 0 ]; 
    then 
        echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"
        return 1
    fi

    # get temporarily filename, output is written to this file show progress can be showed
    tmpfile=$( mktemp -t transferXXX )
    
    # upload stdin or file
    file=$1

    if tty -s; 
    then 
        basefile=$(basename "$file" | sed -e 's/[^a-zA-Z0-9._-]/-/g') 

        if [ ! -e $file ];
        then
            echo "File $file doesn't exists."
            return 1
        fi
        
        if [ -d $file ];
        then
            # zip directory and transfer
            zipfile=$( mktemp -t transferXXX.zip )
            cd $(dirname $file) && zip -r -q - $(basename $file) >> $zipfile
            curl --progress-bar --upload-file "$zipfile" "https://transfer.sh/$basefile.zip" >> $tmpfile
            rm -f $zipfile
        else
            # transfer file
            curl --progress-bar --upload-file "$file" "https://transfer.sh/$basefile" >> $tmpfile
        fi
    else 
        # transfer pipe
        curl --progress-bar --upload-file "-" "https://transfer.sh/$file" >> $tmpfile
    fi
   
    # cat output link
    cat $tmpfile

    # cleanup
    rm -f $tmpfile
}

# This file
alias aedit='vim ~/.bash_aliases.sh'
alias aload='source ~/.bash_aliases.sh'
alias ashow='cat ~/.bash_aliases.sh'

alias ..='cd ..'
alias -- -='cd -'
alias v=vim
alias l=ls
function mcd { mkdir "$1"; cd "$1"; }
export mcd

color()(set -o pipefail;"$@" 2>&1>&3|sed $'s,.*,\e[31m&\e[m,'>&2)3>&1

alias g=git
function gr { grep -r --exclude-dir=node_modules --exclude=*.pyc --exclude=*.swp --exclude=tags "$1" *; }
export -f gr

# TODO
alias todo='vim ~/todo.txt'

# SSH Tunnel
function phome { ssh -N -L $1:localhost:$1 -p 2222 home.epicconstructions.com; }
export phome

# Ctags
function pytags {
    ctags -R --fields=+l --languages=python --python-kinds=-iv -f ./tags $(python -c "import os, sys; print(' '.join('{}'.format(d) for d in sys.path if os.path.isdir(d)))")
}
export -f pytags
alias jstags='ctags -R --exclude=.git --exclude=log *'

alias mhome='mosh -a tom@home.epicconstructions.com --ssh="ssh -p 2222"'
function loadnvm {
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
}
export -f loadnvm

# Copies 2 factor auth code to clipboard from yubikey.
# Requires this: https://developers.yubico.com/yubikey-manager/
# Usage: otp -> list of accounts
# Usage: otp aws -> copies code to clipboard for entry that contains aws
# TODO: You receive the wrong code if there are multiple matches
function otp {
    if [ -z "$1" ]; then
        ykman oath list;
        echo "Enter a partial name from above, ex 2factor aws";
    else
        codeLength=0;
        attempts=0;
        # Retry since this returns intermittent errors
        while [ "$codeLength" -ne 6 ]; do
            if [ "$attempts" -ge 5 ]; then
                echo "Failed to get code. Make sure yubikey is plugged in";
                exit 1;
            fi
            ((attempts=attempts+1));
            resp=`ykman oath code $1 2> /dev/null`
            code="${resp##* }"
            codeLength="${#code}"
        done
        echo -n $code | pbcopy;
        echo "Code copied to clipboard ($resp)";
    fi
}
export -f otp

# Mount encrypted dir
alias mencrypted='pass show encrypted-dir | head -n 1 | encfs -S ~/Dropbox/Encrypted ~/Encrypted'
alias uencrypted='sudo umount ~/Encrypted'
alias start_torrent="~/dotfiles/start_torrent.sh"
