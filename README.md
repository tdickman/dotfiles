Installation:

    git clone git://github.com/tdickman/dotfiles.git
    cd dotfiles
    ./install.sh
    # Add `source ~/.bash_shared.sh` to either your bash_profile or bashrc

OSX:

    brew install vim
    brew install ctags # http://www.gmarik.info/blog/2010/ctags-on-OSX/

# Run the following for each project
ctags -R --fields=+l --languages=python --python-kinds=-iv -f ./tags $(python -c "import os, sys; print(' '.join('{}'.format(d) for d in sys.path if os.path.isdir(d)))") # https://www.fusionbox.com/blog/detail/navigating-your-django-project-with-vim-and-ctags/590/
