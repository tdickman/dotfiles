SCRIPTPATH=`pwd`

rm -rf ~/.vim
ln -s $SCRIPTPATH/vim ~/.vim
ln -s $SCRIPTPATH/tmux.conf ~/.tmux.conf
ln -s $SCRIPTPATH/bash_aliases.sh ~/.bash_aliases.sh
ln -s $SCRIPTPATH/bash_shared.sh ~/.bash_shared.sh
sudo ln -s $SCRIPTPATH/pykub.py /usr/local/bin/pykub
sudo chmod +x /usr/local/bin/pykub
ln -s ~/.vim/vimrc ~/.vimrc
vim +PlugInstall +qall
