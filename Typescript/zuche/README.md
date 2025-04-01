## Dev environment

### Secrets Management

Using dotenv requires adding `"moduleResolution": "node",` to the `tsconfig.json` file, or else VSCode will not be able to find the module, why?

### TypeScript configuration

It's fucking weird to have "import ... from xxx.js" in these .ts files when these configurations
are set to "NodeNext", if I omit the ".js" extension from the imports of these ".ts" files, it will throw an error when compiling!

```json
{
    "compilerOptions": {
        "module": "NodeNext",
        "moduleResolution": "nodenext",
        "target": "ESNext"
    }
}
```

## Docker

```zsh
docker build -t zuche:1.0 . //can run multiple times, overwriting the old image, 1.0 is the tag
docker image ls
```

```zsh
docker run --env-file .env --name zuche_container zuche:1.0 // can't run multiple times,use `runDocker.sh`
docker ps
```

## Tmux

### Run in the background

```zsh
cd Java/Typescript/zuche
tmux list-sessions
tmux new-session -s zuche
tmux send-keys -t zuche './runDocker.sh' C-m
```

### Close Tmux Sessions

```zsh
#To close a Tmux session, you can use the following commands:
tmux list-sessions
tmux kill-session -t zuche
```

### Terminate All Tmux Sessions

```zsh
# To terminate all Tmux sessions, you can use the following command:
# This will stop the Tmux server and terminate all active sessions.
# This will terminate the `zuche` session.
tmux kill-server
```
