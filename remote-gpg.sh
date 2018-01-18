#! /bin/bash

set -e

host="$@"
echo $host
if [ -z "$host" ]; then
    echo "Supply a hostname"
    exit 1
fi

# remove any existing agent socket (in theory `StreamLocalBindUnlink yes` does this,
# but in practice, not so much - https://bugzilla.mindrot.org/show_bug.cgi?id=2601)
ssh $host rm -f ~/.gnupg/S.gpg-agent
ssh -t -R ~/.gnupg/S.gpg-agent:.gnupg/S.gpg-agent-extra $host \
    sh -c 'echo; echo "Perform remote GPG operations and hit enter"; \
        read; \
        rm -f ~/.gnupg/S.gpg-agent'; 
