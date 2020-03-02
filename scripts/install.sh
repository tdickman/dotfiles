#! /bin/bash
set -e
SCRIPTPATH=`pwd`

# Install
sudo add-apt-repository ppa:jonathonf/vim
sudo apt install encfs silversearcher-ag npm vim-gtk3
sudo snap install pyls

mkdir -p ~/.tmp
rm -rf ~/.vim
ln -sf $SCRIPTPATH/vim ~/.vim
ln -sf $SCRIPTPATH/emacs ~/.emacs
ln -sf $SCRIPTPATH/tmux.conf ~/.tmux.conf
ln -sf $SCRIPTPATH/bash_aliases.sh ~/.bash_aliases.sh
ln -sf $SCRIPTPATH/bash_shared.sh ~/.bash_shared.sh
ln -sf $SCRIPTPATH/.jshintrc ~/.jshintrc
ln -sf $SCRIPTPATH/.ctags ~/.ctags
ln -sf $SCRIPTPATH/.taskopenrc ~/.taskopenrc
ln -sf $SCRIPTPATH/.taskrc ~/.taskrc
ln -sf /run/user/$UID/gnupg ~/.gnupg-run
sudo ln -sf $SCRIPTPATH/ksec.py /usr/local/bin/ksec
sudo chmod +x /usr/local/bin/ksec
ln -sf ~/.vim/vimrc ~/.vimrc
vim +PlugInstall +qall

# GPG
sudo apt-get install gnupg2 gnupg-agent libpth20 pinentry-curses libccid pcscd scdaemon libksba8
curl "https://raw.githubusercontent.com/tdickman/dotfiles/master/gpg/tom-public-key.asc" | gpg2 --import
printf 'default-cache-ttl 600\nmax-cache-ttl 7200\nenable-ssh-support\n' > ~/.gnupg/gpg-agent.conf

# Git aliases
git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.st status
git config --global core.excludesfile ~/dotfiles/global_gitignore

# Syntastic dependencies
sudo npm install -g jshint eslint eslint-plugin-vue

# Tmux resurrect / continuum
git -C tmux-resurrect pull || git clone https://github.com/tmux-plugins/tmux-resurrect
git -C tmux-continuum pull || git clone https://github.com/tmux-plugins/tmux-continuum

# Install kubetail
mkdir -p ~/.local/
mkdir -p ~/.local/bin/
wget https://github.com/johanhaleby/kubetail/raw/master/kubetail -O ~/.local/bin/kubetail
chmod +x ~/.local/bin/kubetail
sudo wget https://raw.githubusercontent.com/johanhaleby/kubetail/master/completion/kubetail.bash -O /etc/bash_completion.d/kubetail.bash

# Linux packages
sudo apt update
sudo apt install -y taskwarrior

# Install kube context statusbar
wget -O kube.tmux https://raw.githubusercontent.com/jonmosco/kube-tmux/master/kube.tmux

# Install task-open
sudo apt-get install -y libjson-perl
mkdir -p .packages/
cd .packages/
if [ ! -d taskopen ]; then
    git clone https://github.com/ValiValpas/taskopen.git
    cd taskopen
    make PREFIX=/usr
    sudo make PREFIX=/usr install
fi

cd $SCRIPTPATH

# Install hub
sudo snap install --classic hub

# https://unix.stackexchange.com/questions/251595/vim-losing-ability-to-copy-to-client-clipoard-over-ssh
# add GPG key
wget -q https://xpra.org/gpg.asc -O- | sudo apt-key add -
# add XPRA repository
sudo add-apt-repository "deb https://xpra.org/ $(lsb_release -c -s) main"
# install XPRA package
sudo apt-get install xpra
sudo apt install xpra

# Setup docker
sudo apt install docker.io
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# Install encrypted files
gpg --yes -o ~/.ssh/config -d configs/ssh-config.gpg
