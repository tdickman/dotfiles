platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
    platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
    platform='osx'
fi

# Kubernetes
alias k=kubectl
alias ko=kubectl-old
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
function ksn {
    export CONTEXT=$(kubectl config view | awk '/current-context/ {print $2}');
    kubectl config set-context $CONTEXT --namespace="$1";
}
export -f ksn
alias ksc='kubectl config use-context $1'
alias kgc='kubectl config get-contexts'
alias krc='kubectl config rename-context $1 $2'
alias kdc='kubectl config delete-context $1'
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
function gr { grep -r --exclude-dir=.terraform --exclude-dir=node_modules --exclude-dir=venv --exclude=*.backup --exclude=*.pyc --exclude=*.swp --exclude-dir=.mypy_cache --exclude=tags "$1" *; }
export -f gr

# TODO
alias todo='vim ~/todo.txt'

# SSH Tunnel
function pp { ssh -N -L $2:localhost:$2 $1; }
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

function yubi-remote {
    GPG_AGENT_SOCKET="${HOME}/.gnupg/S.gpg-agent.ssh.remote"
}
export -f yubi-remote
function yubi-remote-clean {
    rm "${HOME}/.gnupg/S.gpg-agent.ssh.remote"
}
export -f yubi-remote-clean

# Mount encrypted dir
alias mencrypted='pass show encrypted-dir | head -n 1 | encfs -S ~/Drive/Encrypted ~/Encrypted'
alias uencrypted='fusermount -u ~/Encrypted'
alias gc='pass show encrypted-dir | head -n 1 | encfs -S ~/Drive/Encrypted ~/Encrypted && xdg-open Encrypted/giftcards/reselling.ods && echo "Press enter to unmount volume" && read _ && sudo umount ~/Encrypted'
alias start_torrent="~/dotfiles/start_torrent.sh"
alias dc="docker-compose"
function ssh-yubi {
    ssh -t $1 "rm /run/user/1000/gnupg/S.gpg-agent.ssh"
    ssh -R /run/user/1000/gnupg/S.gpg-agent.ssh:/run/user/1000/gnupg/S.gpg-agent.ssh $1
}
export -f ssh-yubi
function ssh-yubi-home {
    ssh -t $1 "rm ~/.gnupg/S.gpg-agent.ssh"
    ssh -R /home/tom/.gnupg/S.gpg-agent.ssh:/run/user/1000/gnupg/S.gpg-agent.ssh $1
}
export -f ssh-yubi-home
function ssh-yubi-home {
    ssh -t $1 "rm ~/.gnupg/S.gpg-agent.ssh"
    home=$(ssh -t $1 "pwd ~" | tr -d '\r')
    forwardpath="$home/.gnupg/S.gpg-agent.ssh:/run/user/1000/gnupg/S.gpg-agent.ssh"
    ssh -R $forwardpath $1
}
export -f ssh-yubi-home
function vpnlocal {
    echo $'vpn\n'$(pass 192.168.1.1/vpn | head -n 1) > /tmp/vpn
    chmod 600 /tmp/vpn
    sudo openvpn --config ~/Drive/VPN/home.epicconstructions.com.local.ovpn --auth-user-pass /tmp/vpn
    rm /tmp/vpn
}
export -f vpnlocal
function vpnall {
    echo $'vpn\n'$(pass 192.168.1.1/vpn | head -n 1) > /tmp/vpn
    chmod 600 /tmp/vpn
    sudo openvpn --config ~/Drive/VPN/home.epicconstructions.com.all.ovpn --auth-user-pass /tmp/vpn
    rm /tmp/vpn
}
export -f vpnall

# Task Warrior
alias t='task'
alias to='taskopen'

# Tmux
alias f='tmux attach -dt f || tmux new-session -s f'
function sf {
    ssh -t $1 "tmux attach -dt f || tmux new-session -s f"
}
export -f sf

# Tmux
alias w='tmux attach -dt w || tmux new-session -s w'
function sw {
    ssh -t tom-foldapp@$1 "tmux attach -dt w || tmux new-session -s w"
}
export -f sw

# Trigger a rolling deploy after changing secrets
function kroll {
    kubectl patch deployment $1 -p "{\"spec\":{\"template\":{\"metadata\":{\"annotations\":{\"date\":\"`date +'%s'`\"}}}}}"
}
export -f kroll

alias genpass='cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1'
function gitprs {
    git log --pretty="%h - %s" $1..$2 | grep "Merge pull request"
}
export -f gitprs

function freplace {
    egrep --exclude-dir=.git -lRZ $1 . | xargs -0 -l sed -i -e 's/'$1/$2'/g'
}
export -f freplace

function viewcert {
    curl -k -v $1  2>&1 | awk 'BEGIN { cert=0 } /^\* SSL connection/ { cert=1 } /^\*/ { if (cert) print }'
}
export -f viewcert

# Usage: `kshellplus app`
function kshellplus {
    POD=`kubectl get pod -l app=$1 --no-headers | grep Running | head -1 | cut -f 1 -d " "`
    kubectl exec -it $POD python manage.py shell_plus
}
export -f kshellplus
function ksh {
    POD=`kubectl get pod -l app=$1 --no-headers | grep Running | head -1 | cut -f 1 -d " "`
    if [[ -z "$2" ]]; then
        kubectl exec -it $POD sh
    else
        kubectl exec -it $POD "${@:2}"
    fi
}
export -f ksh

# Scale all deployments to the given number of replicas
function kscale {
    kubectl scale deployment/$1 --replicas $2
}
export -f kscale

# Setup symlink to poetry virtual environment to make ALE happy
function poetryenv {
    ln -s $(poetry env list --full-path | head -n 1 | awk '{print $1;}') $(pwd)/.venv
}
export -f poetryenv

function kindup {
    # desired cluster name; default is "kind"
    KIND_CLUSTER_NAME="${KIND_CLUSTER_NAME:-kind}"

    # create registry container unless it already exists
    reg_name='kind-registry'
    reg_port='5000'
    running="$(docker inspect -f '{{.State.Running}}' "${reg_name}" 2>/dev/null || true)"
    if [ "${running}" != 'true' ]; then
      docker run \
        -d --restart=always -p "${reg_port}:5000" --name "${reg_name}" \
        registry:2
    fi
    reg_ip="$(docker inspect -f '{{.NetworkSettings.IPAddress}}' "${reg_name}")"

    # create a cluster with the local registry enabled in containerd
cat <<EOF | kind create cluster --name "${KIND_CLUSTER_NAME}" --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
containerdConfigPatches: 
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."localhost:${reg_port}"]
    endpoint = ["http://${reg_ip}:${reg_port}"]
EOF

    krc kind-kind a-kind
    kubectl config set default-report localhost:5000
    kubectl config set local-cluster false
}
export -f kindup

function kinddown {
    kind delete cluster
    reg_name='kind-registry'
    docker stop $reg_name
    docker rm $reg_name
    kdc a-kind || true
}
export -f kinddown
