#! /bin/bash
set -e
SCRIPTPATH=`pwd`

# Install <LeftMouse>
# pyenv install 3.12
# pyenv virtualenv 3.12 neovim3
# ~/.pyenv/versions/neovim3/bin/python -m pip install pynvim python-dotenv requests prompt-toolkit tiktoken

# Install
sudo apt install -y encfs

# Install neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod u+x nvim-linux-x86_64.appimage

mkdir -p ~/.tmp
rm -rf ~/.vim
# ln -sf $SCRIPTPATH/vim ~/.vim
ln -sf $SCRIPTPATH/nvim ~/.config/nvim
ln -sf $SCRIPTPATH/tmux.conf ~/.tmux.conf
ln -sf $SCRIPTPATH/bash_aliases.sh ~/.bash_aliases.sh
ln -sf $SCRIPTPATH/bash_shared.sh ~/.bash_shared.sh
ln -sf $SCRIPTPATH/.jshintrc ~/.jshintrc
ln -sf $SCRIPTPATH/.ctags ~/.ctags
ln -sf $SCRIPTPATH/.taskopenrc ~/.taskopenrc
ln -sf $SCRIPTPATH/.taskrc ~/.taskrc
ln -sf /run/user/$UID/gnupg ~/.gnupg-run
# ln -sf ~/.vim/vimrc ~/.vimrc

# GPG
sudo apt-get install -y gnupg2 gnupg-agent libpth20 pinentry-curses libccid pcscd scdaemon libksba8
curl "https://raw.githubusercontent.com/tdickman/dotfiles/master/gpg/tom-public-key.asc" | gpg2 --import
printf 'default-cache-ttl 600\nmax-cache-ttl 7200\nenable-ssh-support\npinentry-program /usr/bin/pinentry-tty\nallow-loopback-pinentry' > ~/.gnupg/gpg-agent.conf

# Nvim
# sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
#            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim +PlugInstall +qall

pipx install black

# Git aliases
git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.st status
git config --global user.email "git@tomdickman.com"
git config --global user.name "Tom Dickman"
git config --global core.excludesfile ~/dotfiles/global_gitignore

# Pass
sudo apt install -y pass

# Tmux resurrect / continuum
git -C tmux-resurrect pull || git clone https://github.com/tmux-plugins/tmux-resurrect
git -C tmux-continuum pull || git clone https://github.com/tmux-plugins/tmux-continuum

# Install kube context statusbar
wget -O kube.tmux https://raw.githubusercontent.com/jonmosco/kube-tmux/master/kube.tmux

cd $SCRIPTPATH

# https://unix.stackexchange.com/questions/251595/vim-losing-ability-to-copy-to-client-clipoard-over-ssh
cd /tmp
git clone https://github.com/Xpra-org/xpra
cd xpra
./setup.py install-repo
sudo apt install -y xpra

# Install encrypted files
# gpg --yes -o ~/.ssh/config -d configs/ssh-config.gpg

# Install fonts for editor
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DroidSansMono.zip
unzip DroidSansMono.zip -d ~/.fonts
fc-cache -fv
# Now change font in terminal
