#! /bin/bash
SCRIPTPATH=`pwd`

rm -rf ~/.vim
ln -s $SCRIPTPATH/vim ~/.vim
ln -s $SCRIPTPATH/tmux.conf ~/.tmux.conf
ln -s $SCRIPTPATH/bash_aliases.sh ~/.bash_aliases.sh
ln -s $SCRIPTPATH/bash_shared.sh ~/.bash_shared.sh
ln -s $SCRIPTPATH/.jshintrc ~/.jshintrc
ln -s $SCRIPTPATH/.ctags ~/.ctags
ln -s $SCRIPTPATH/.taskopenrc ~/.taskopenrc
sudo ln -s $SCRIPTPATH/ksec.py /usr/local/bin/ksec
sudo chmod +x /usr/local/bin/ksec
ln -s ~/.vim/vimrc ~/.vimrc
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

# Install task-open
sudo apt-get install -y libjson-perl
mkdir -p .packages/
cd .packages/
git clone https://github.com/ValiValpas/taskopen.git
cd taskopen
make PREFIX=/usr
sudo make PREFIX=/usr install
