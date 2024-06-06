# shellcheck disable=SC2046
eval `ssh-agent -s`
ssh-add /Users/eugene/.ssh/id_ed25519
ssh-add -l
