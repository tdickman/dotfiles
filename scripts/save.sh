set -e
saveIfChanged () {
    decryptedFilePath=$1
    encryptedFilePath=$2
    decrypted=$(cat $decryptedFilePath)
    encrypted=$(gpg -d $encryptedFilePath)

    if [ "$encrypted" != "$decrypted" ]; then
        echo "File $decryptedFilePath changed, saving"
        gpg --yes -o configs/ssh-config.gpg -r tdickman@gmail.com -e ~/.ssh/config
    fi
}

saveIfChanged "${HOME}/.ssh/config" "configs/ssh-config.gpg"
