SCRIPTPATH=`pwd`

ln -s $SCRIPTPATH/vim ~/.vim
ln -s $SCRIPTPATH/tmux.conf ~/.tmux.conf
ln -s ~/.vim/vimrc ~/.vimrc
vim +PlugInstall +qall
