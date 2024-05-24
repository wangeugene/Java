push using one of two key pairs to avoid using against the wrong GitHub account

```zsh
GIT_SSH_COMMAND="ssh -i /Users/eugene/.ssh/id_ed25519_eugene" git push origin main
```