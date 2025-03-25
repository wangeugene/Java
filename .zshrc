# nvm start
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
# nvm end

# pnpm start
export PNPM_HOME="/Users/eugene/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export JAVA_HOME="/opt/homebrew/Cellar/openjdk@11/11.0.26/libexec/openjdk.jdk/Contents/Home"
export GROOVY_HOME=/opt/homebrew/opt/groovy/libexec
export MAVE_HOME="/Applications/IntelliJ IDEA.app/Contents/plugins/maven/lib/maven3"
export NPM_CONFIG_USERCONFIG=~/.npmrc
export PATH="$HOME/.jenv/bin:$PATH"
export PATH="/opt/homebrew/Cellar/ruby/3.4.2/bin:$PATH"
export EDITOR="emacs"

# git start
acp() {
  git fetch origin
  git merge origin/$(git rev-parse --abbrev-ref HEAD)
  git status
  
  echo "current HEAD commit hash: $(git rev-parse HEAD)"
  echo ""
   # Show Git user.name and user.email
  echo "Current Git user:"
  echo "  Name : $(git config user.name)"
  echo "  Email: $(git config user.email)"
  echo ""

  read "confirm?Continue with add, commit, push? (y/n): "
  if [[ "$confirm" == "y" ]]; then
    git add .
    git commit -m "$1"
    git push
  else
    echo "Aborted."
  fi
}
# git end

alias kp='sh ~/Projects/Java/Shell/killProcessesByPorts.sh'
alias nd='docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi $(docker images -q)'
alias dc='open -a "Google Chrome" --args --make-default-browser'


if which jenv >/dev/null; then eval "$(jenv init -)"; fi
eval "$(gh copilot alias -- zsh)"
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"