# Use this script to push to a git repository using a specific ssh key (my personal github account instead of my work account)
# check if ssh-agent is running
if ! pgrep ssh-agent;
then
  echo "ssh-agent is not running"
else
  echo "ssh-agent is already running"
fi

cd ~/Projects/Java
echo "Checking the Project root directory .git/config file for user.email and user.name"
cat .git/config
git config --local --replace-all user.email "yuzhen23@icloud.com"
git config --local --replace-all user.name "Eugene Wang"

# add the key to the agent first, or else the git push will fail with a permission denied error
# first execute the following command to add the key to the agent interactively ( cause you need to enter the passphrase)
# ssh-add /Users/eugene/.ssh/id_ed25519_eugene
# GIT_SSH_COMMAND="ssh -i /Users/eugene/.ssh/id_ed25519_eugene" git push origin main
# git rm --cached src/app.log  you might need to reset git's cached list of ignored files with