export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

export JAVA_HOME="/opt/homebrew/Cellar/openjdk@11/11.0.22"
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

# Jenv tool used to switch between Java versions
if which jenv >/dev/null; then eval "$(jenv init -)"; fi

# Enable GitHub Copilot inside z shell
eval "$(gh copilot alias -- zsh)"

# Enable shortcuts within the terminal, Ctrl + A to go to the beginning of the line, Ctrl + E to go to the end of the line
export EDITOR="emacs"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"