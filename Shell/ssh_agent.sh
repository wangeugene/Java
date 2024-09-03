# shellcheck disable=SC2046
eval `ssh-agent -s`
# MacOS specific way of adding keys to the agent, this will avoid the need to enter the passphrase every time
# Without --apple-use-keychain, the passphrase will be asked every time
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
ssh-add -l
