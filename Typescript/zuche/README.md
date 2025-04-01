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
docker build -t zuche:1.0 .
docker image ls
```

```zsh
docker run --name zuche_container zuche:1.0
docker ps
```
