SCRIPTPATH=`pwd`

ln -s $SCRIPTPATH/vim ~/.vim
ln -s $SCRIPTPATH/tmux.conf ~/.tmux.conf
ln -s $SCRIPTPATH/bash_aliases ~/.bash_aliases
ln -s ~/.vim/vimrc ~/.vimrc
vim +PlugInstall +qall
