# Tmux Basic

```zsh
tmux a # attach to the session, if it is the only one existing tmux session, if there are more than one, it will show an error
tmux a -t <session_name> # attach to the session
tmux ls # list all tmux sessions
tmux new -s <session_name> # create a new tmux session
tmux kill-session -t <session_name> # kill a tmux session
```
