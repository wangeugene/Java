export HOMEBREW_CURLRC=1 
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm start
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macOS detected"
    source ~/.private.zshrc
    export JAVA_HOME="/opt/homebrew/Cellar/openjdk@11/11.0.26/libexec/openjdk.jdk/Contents/Home"
    export GROOVY_HOME="/opt/homebrew/opt/groovy/libexec"
    export MAVE_HOME="/Applications/IntelliJ IDEA.app/Contents/plugins/maven/lib/maven3"
    export NPM_CONFIG_USERCONFIG=~/.npmrc
    export PATH="$HOME/.jenv/bin:$PATH"
    export PATH="/opt/homebrew/opt/teleport@15.4/bin:$PATH"
    export PATH="/opt/homebrew/Cellar/ruby/3.4.2/bin:$PATH"
    alias dc='open -a "Google Chrome" --args --make-default-browser'
    alias chrome='open -a "Google Chrome"'
    eval "$(gh copilot alias -- zsh)"
    eval "$(jenv init -)"

    fpath=(/Users/euwang/.docker/completions $fpath)
    autoload -Uz compinit
    compinit
    eval "$(zoxide init zsh)"
    # Optional but awesome: enable fzf keybindings and fuzzy search
    # (fzf has a post-install step)
    # brew install zoxide fzf
    # $(brew --prefix)/opt/fzf/install

else
    echo "Linux detected"
fi

export EDITOR="emacs"
alias kp='sh ~/Projects/Java/Shell/killProcesses.sh'
alias zshsync='cp -v ~/Projects/Java/.zshrc ~/.zshrc && echo "✅ .zshrc copied to home directory" && source ~/.zshrc || echo "❌ Error syncing .zshrc"'
alias cj='cd ~/Projects/Java'
alias setupgit="sh ~/Projects/Java/Shell/setupgit.sh"
alias nd='docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi $(docker images -q)'
alias fd='fd --no-ignore'
alias urldecode='node -e "console.log(decodeURIComponent(process.argv[1]))"'
alias b64decode='node -e "console.log(Buffer.from(process.argv[1], \"base64\").toString())"'

# First unalias zc if it exists, then define as function to accept command line arguments
unalias zc 2>/dev/null || true
function zc() {
  cd ~/Projects/Java/Typescript/zuche/ && pnpm zuche "$@"
}

ac(){
  git fetch origin
  git status
  git add .
  git commit -m "test: quick commit & push"
  git push
  git status
  git log -1
}

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

function sshagent(){
      if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macOS detected, using Apple Keychain"
        KEYCHAIN_FLAG="--apple-use-keychain"
        echo "Killing existing ssh-agent and starting a new one to force reload the key"
        kp ssh-agent
        if ! pgrep -x "ssh-agent" >/dev/null; then
            eval "$(ssh-agent -s)"
            ssh-add --apple-use-keychain ~/.ssh/id_ed25519  # or your specific key path
            ssh-add --apple-use-keychain ~/.ssh/id_rsa  # or your specific key path
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
          echo "killing existing ssh-agent and starting a new one to force reload the key"
          pkill ssh-agent
          eval $(ssh-agent -s)
          ssh-add ~/.ssh/id_ed25519
          ssh-add -l
      fi
    fi
}

if [ -z "$SSH_AUTH_SOCK" ]; then
    sshagent
fi