export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
export JAVA_HOME="/opt/homebrew/Cellar/openjdk@11/11.0.26/libexec/openjdk.jdk/Contents/Home"
export GROOVY_HOME=/opt/homebrew/opt/groovy/libexec
export MAVE_HOME="/Applications/IntelliJ IDEA.app/Contents/plugins/maven/lib/maven3"
export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin"
export PATH="$PATH:/Applications/IntelliJ IDEA.app/Contents/MacOS"
export PATH="$PATH:/Applications/IntelliJ IDEA.app/Contents/plugins/maven/lib/maven3/bin"
export PATH=$HOME/bin:$PATH
# pnpm
export PNPM_HOME="/Users/eugene/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export EDITOR="emacs"

alias kp='sh ~/Projects/Java/Shell/killProcessesByPorts.sh'
alias nd='docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi $(docker images -q)'
alias dc='open -a "Google Chrome" --args --make-default-browser'


if which jenv >/dev/null; then eval "$(jenv init -)"; fi
eval "$(gh copilot alias -- zsh)"
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"