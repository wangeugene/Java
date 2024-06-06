// HOME is predefined environment variable and accessible in this file
console.log(process.env.HOME)
// ENV_VAR is defined in ~/.zshrc file and not accessible in this file and show print out undefined
console.log(process.env.ENV_VAR)