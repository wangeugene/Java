# Add to ~/.zshrc
# Check if alias already exists
if grep -q "^alias sshagent=" ~/.zshrc; then
    echo "alias sshagent already exists in ~/.zshrc"
else
    echo "alias sshagent does not exist && adding alias sshagent to ~/.zshrc"
    echo "alias sshagent='~/Projects/Java/Shell/ssh_agent.sh'" >> ~/.zshrc
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macOS detected, using Apple Keychain"
    # macOS
    KEYCHAIN_FLAG="--apple-use-keychain"
    if ! pgrep -x "ssh-agent" >/dev/null; then
        eval $(ssh-agent -s)
        ssh-add --apple-use-keychain ~/.ssh/id_ed25519
        ssh-add -l
    else
        echo "ssh-agent is already running with the following PID(s):"
        pgrep -x "ssh-agent"
    fi
else
    # Linux and others
    echo "Linux detected, using default ssh-agent"
    KEYCHAIN_FLAG=""
    if ! pgrep -x "ssh-agent" >/dev/null; then
        eval $(ssh-agent -s)
        ssh-add ~/.ssh/id_ed25519
        ssh-add -l
    else
        echo "ssh-agent is already running with the following PID(s):"
        pgrep -x "ssh-agent"
    fi
fi

# MacOS specific way of adding keys to the agent
ssh -T git@github.com
