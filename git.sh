# check if ssh-agent is running
if ! pgrep ssh-agent;
then
  echo "ssh-agent is not running"
  "eval $(ssh-agent -s)"
  ssh-add /Users/eugene/.ssh/id_ed25519_eugene
  ssh-add -l
else
  echo "ssh-agent is already running"
fi

git push
