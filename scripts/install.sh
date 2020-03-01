#! /bin/bash
set -e
SCRIPTPATH=`pwd`

# Install
sudo apt install encfs silversearcher-ag

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
sudo ln -sf $SCRIPTPATH/ksec.py /usr/local/bin/ksec
sudo chmod +x /usr/local/bin/ksec
ln -sf ~/.vim/vimrc ~/.vimrc
vim +PlugInstall +qall

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

# Install encrypted files
gpg --yes -o ~/.ssh/config -d configs/ssh-config.gpg

# Install hub
sudo snap install --classic hub

sudo snap install pyls

# https://unix.stackexchange.com/questions/251595/vim-losing-ability-to-copy-to-client-clipoard-over-ssh
# add GPG key
wget -q https://xpra.org/gpg.asc -O- | sudo apt-key add -
# add XPRA repository
sudo add-apt-repository "deb https://xpra.org/ $(lsb_release -c -s) main"
# install XPRA package
sudo apt-get install xpra
sudo apt install xpra
