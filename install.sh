SCRIPTPATH=`pwd`

rm -rf ~/.vim
ln -s $SCRIPTPATH/vim ~/.vim
ln -s $SCRIPTPATH/tmux.conf ~/.tmux.conf
ln -s $SCRIPTPATH/bash_aliases.sh ~/.bash_aliases.sh
ln -s $SCRIPTPATH/bash_shared.sh ~/.bash_shared.sh
ln -s $SCRIPTPATH/.jshintrc ~/.jshintrc
ln -s $SCRIPTPATH/.ctags ~/.ctags
sudo ln -s $SCRIPTPATH/ksec.py /usr/local/bin/ksec
sudo chmod +x /usr/local/bin/ksec
ln -s ~/.vim/vimrc ~/.vimrc
vim +PlugInstall +qall

# Git aliases
git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.st status

# Syntastic dependencies
sudo npm install -g jshint eslint eslint-plugin-vue
