https://www.jfry.me/articles/2015/gpg-smartcard/
https://github.com/drduh/YubiKey-Guide#ssh

# Ubuntu setup

Install Dependencies:

```
sudo apt-get install gnupg2 gnupg-agent libpth20 pinentry-curses libccid pcscd scdaemon libksba8
```

Import public key

```
curl "https://keybase.io/tdickman/pgp_keys.asc?fingerprint=3d8224e300f1693682db2cf086d69ca76e6f22a7" | gpg2 --import
```

Add the following to your .gnupg/gpg-agent.conf file:

```
default-cache-ttl 600
max-cache-ttl 7200
enable-ssh-support
```

# Update bash init file

See bash_shared.sh content

# Symlink gpg to gpg2 on older versions of ubuntu

```
ln -s /usr/bin/gpg2 /usr/bin/gpg
```

# Sign git commits by default

https://help.github.com/articles/signing-commits-using-gpg/

```
git config --global commit.gpgsign true
```

# Getting ssh public key
ssh-add -L
