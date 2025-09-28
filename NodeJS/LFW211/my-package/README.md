## init with the defaults

npm init -y

## in this package.json

name – the name of the package
version – the current version number of the package
description – a package description, this is used for meta analysis in package registries
main – the entry-point file to load when the package is loaded
scripts – namespaced shell scripts, these will be discussed later in this section
keywords – array of keywords, improves discoverability of a published package
author – the package author
license – the package license.

## commands

```zsh
npm install pino
npm ls # to list all the dependencies
npm ls --depth=999 # to list all the sub dependencies as well
npm install --save-dev standard  # to install a linter to use in the development time only
npm install --omit=dev # Install but omit devDependencies (useful for production installs)
npm run lint # To show linting errors
npm run lint -- --fix # To fix linting errors automatically
npm test # To run tests
```
