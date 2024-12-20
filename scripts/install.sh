#! /bin/bash
set -e
SCRIPTPATH=`pwd`

# Install <LeftMouse>
# pyenv install 3.12
# pyenv virtualenv 3.12 neovim3
# ~/.pyenv/versions/neovim3/bin/python -m pip install pynvim python-dotenv requests prompt-toolkit tiktoken

# Install
sudo add-apt-repository ppa:jonathonf/vim
sudo apt install -y encfs silversearcher-ag vim-gtk3
pipx install python-language-server

mkdir -p ~/.tmp
rm -rf ~/.vim
ln -sf $SCRIPTPATH/vim ~/.vim
ln -sf $SCRIPTPATH/nvim ~/.config/nvim
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

# GPG
sudo apt-get install -y gnupg2 gnupg-agent libpth20 pinentry-curses libccid pcscd scdaemon libksba8
curl "https://raw.githubusercontent.com/tdickman/dotfiles/master/gpg/tom-public-key.asc" | gpg2 --import
printf 'default-cache-ttl 600\nmax-cache-ttl 7200\nenable-ssh-support\n' > ~/.gnupg/gpg-agent.conf

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

# Syntastic dependencies
sudo apt install -y npm
sudo npm install -g jshint eslint eslint-plugin-vue

# Pass
sudo apt install -y pass

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
sudo apt install -y xpra

# Setup docker
sudo apt install -y docker.io
sudo groupadd docker || true
sudo usermod -aG docker $USER

# Install encrypted files
gpg --yes -o ~/.ssh/config -d configs/ssh-config.gpg

# Neovim
sudo apt install -y ripgrep
wget -O /tmp/nvim-linux64.deb https://github.com/neovim/neovim/releases/download/v0.7.0/nvim-linux64.deb
sudo dpkg -i /tmp/nvim-linux64.deb
# git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
nvim +'hi NormalFloat guibg=#1e222a' +PackerSync

# Install fonts for editor
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DroidSansMono.zip
unzip DroidSansMono.zip -d ~/.fonts
fc-cache -fv
# Now change font in terminal
