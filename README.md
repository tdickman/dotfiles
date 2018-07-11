Installation:

    git clone git://github.com/tdickman/dotfiles.git
    cd dotfiles
    ./install.sh
    # Add `source ~/.bash_shared.sh` to either your bash_profile or bashrc

OSX:

    brew install vim
    brew install ctags # http://www.gmarik.info/blog/2010/ctags-on-OSX/

Ubuntu:
    sudo apt install vim-gtk flake8 mypy python3-pip
    sudo -H pip3 install jedi

# Run the following for each project
ctags -R --fields=+l --languages=python --python-kinds=-iv -f ./tags $(python -c "import os, sys; print(' '.join('{}'.format(d) for d in sys.path if os.path.isdir(d)))") # https://www.fusionbox.com/blog/detail/navigating-your-django-project-with-vim-and-ctags/590/

# Git config
git config --global commit.gpgsign true  # Sign commits

# Kotlin

This project includes a few plugins to help with kotlin + vim. To use syntastic
with a kotlin project you need to to the following to enable sytastic:

https://github.com/francis36012/ktsyntastic

Add the following to build.gradle:

```
buildscript {
  repositories {
    maven {
      url "https://plugins.gradle.org/m2/"
    }
  }
  dependencies {
    classpath "gradle.plugin.com.fagyapong.ktsyntastic:ktsyntastic:0.3.1"
  }
}

apply plugin: "com.fagyapong.ktsyntastic"
```

Then run the following to generate a .ale_kotlinc_config file:

```
./gradlew kotlinAle
```

# Ubuntu general settings

```
gsettings set org.gnome.shell.app-switcher current-workspace-only true
```

# Tmux Resurrection / Vim

Start saving vim sessions for a directory by running `:Obsess`. This will cause
the session to automatically get saved on every change in a file called
Session.vim in the current directory.

Save tmux sessions by running cntrl-b cntrl-s. Restore with cntrl-b cntrl-r.
