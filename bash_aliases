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

# This file
alias aedit='vim ~/.bash_aliases'
alias aload='source ~/.bash_aliases'
alias ashow='cat ~/.bash_aliases'

alias ..='cd ..'
alias -- -='cd -'
alias v=vim
alias l=ls
function mcd { mkdir "$1"; cd "$1"; }
export mcd

color()(set -o pipefail;"$@" 2>&1>&3|sed $'s,.*,\e[31m&\e[m,'>&2)3>&1

alias g=git
function gr { grep -r --exclude-dir=node_modules --exclude=*.pyc --exclude=tags "$1" *; }
export -f gr

# TODO
alias todo='vim ~/todo.txt'

# Ctags
function pytags {
    ctags -R --fields=+l --languages=python --python-kinds=-iv -f ./tags $(python -c "import os, sys; print(' '.join('{}'.format(d) for d in sys.path if os.path.isdir(d)))")
}
export -f pytags
alias jstags='ctags -R --exclude=.git --exclude=log *'
