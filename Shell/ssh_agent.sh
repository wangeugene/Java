# Add to ~/.bashrc or ~/.bash_profile
# alias sshagent="/Users/eugene/IdeaProjects/Java/Shell/ssh_agent.sh"
if ! pgrep -x "ssh-agent" >/dev/null; then
    eval $(ssh-agent -s)
else
    echo "ssh-agent is already running with the following PID(s):"
    pgrep -x "ssh-agent"
fi
# MacOS specific way of adding keys to the agent, this will avoid the need to enter the passphrase every time
# Without --apple-use-keychain, the passphrase will be asked every time
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
ssh-add -l
