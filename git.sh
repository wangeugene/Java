# check if ssh-agent is running
if ! pgrep ssh-agent; then
  echo "ssh-agent is not running"
  eval `ssh-agent -s`
  ssh-add /Users/eugene/.ssh/id_ed25519_eugene
  ssh-add -l
fi

GIT_SSH_COMMAND="ssh -i /Users/eugene/.ssh/id_ed25519_eugene" git push origin main