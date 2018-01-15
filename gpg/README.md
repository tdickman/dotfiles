https://www.jfry.me/articles/2015/gpg-smartcard/
https://github.com/drduh/YubiKey-Guide#ssh

# Ubuntu setup

Install Dependencies:

```
sudo apt-get install gnupg2 gnupg-agent libpth20 pinentry-curses libccid pcscd scdaemon libksba8
```

Import public key

```
curl "https://raw.githubusercontent.com/tdickman/dotfiles/master/gpg/tom-public-key.asc" | gpg2 --import
```

Add the following to your .gnupg/gpg-agent.conf file:

```
default-cache-ttl 600
max-cache-ttl 7200
enable-ssh-support
```

# Update bash init file

See bash_shared.sh content. You may have to kill gpg-agent to get it to restart and use the new settings:

```
killall gpg-agent
```

# Symlink gpg to gpg2 on older versions of ubuntu

```
ln -s /usr/bin/gpg2 /usr/bin/gpg
```

# Set your key to be trusted

```
gpg -K
gpg --edit-key <KEY_ID>
gpg> trust
gpg --card-status
```

# Sign git commits by default

https://help.github.com/articles/signing-commits-using-gpg/

```
git config --global commit.gpgsign true
```

# Getting ssh public key
ssh-add -L

# Changing yubikey device (swapping to backup)

```
rm -rf ~/.gnupg/private-keys-v1.d
killall gpg-agent
gpg2 --card-status
# Trust new key as shown above
```
