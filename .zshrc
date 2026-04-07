export HOMEBREW_CURLRC=1 
export EDITOR="emacs"

if [ -z "$SSH_AUTH_SOCK" ]; then
    sshagent
fi

# ============================ Aliases ============================

alias ur='sh ~/Projects/Java/Shell/upload-files-to-remote-server-dir.sh'
alias kp='sh ~/Projects/Java/Shell/killProcesses.sh'
alias cr='cd /Users/euwang/Projects/Java/app/rule-updater'
alias ca='cd /Users/euwang/Projects/Java/app'
alias cj='cd ~/Projects/Java'
alias ct='/Users/euwang/Projects/Java/macOS/TeslaCamViewer'
alias zd='diff -u ~/.zshrc .zshrc | delta'
alias dc='open -a "Google Chrome" --args --make-default-browser'
alias oz='code ~/Projects/Java/.zshrc'
alias chrome='open -a "Google Chrome"'
alias sync='cd /Users/euwang/Projects/Java/app & rsync -avz --delete --exclude '.git' --exclude 'node_modules' --exclude 'certbot'  /Users/euwang/Projects/Java/app/ aws:/app'
alias p='cd ~/Projects/'
alias setupgit="sh ~/Projects/Java/Shell/setupgit.sh"
alias nd='docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi $(docker images -q)'
alias fd='fd --no-ignore'
alias urldecode='node -e "console.log(decodeURIComponent(process.argv[1]))"'
alias b64decode='node -e "console.log(Buffer.from(process.argv[1], \"base64\").toString())"'

# ============================ End of Aliases ============================


# ============================ Functions ============================
zshsync() {
  local src="$HOME/.zshrc"
  local dst=".zshrc"

  if diff -q "$src" "$dst" > /dev/null; then
    echo "✅ Already in sync"
    return
  fi

  echo "⚠️ Differences:"
  diff -u "$src" "$dst" | delta

  echo "\nSync local → home? (y/n)"
  read ans

  if [[ "$ans" == "y" ]]; then
    cp "$dst" "$src"
    echo "✅ Synced!"
    source ~/.zshrc
  else
    echo "❌ Cancelled"
  fi
}


load-dev-env(){
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  echo 'eval "$(fnm env --use-on-cd)"' >> ~/.zshrc
  # pnpm start
  export PNPM_HOME="$HOME/Library/pnpm"
  case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
  esac
  # pnpm end

  if [[ "$OSTYPE" == "darwin"* ]]; then
      source ~/.private.zshrc
      # JAVA_HOME environment variable is managed by jenv
      # export JAVA_HOME="/opt/homebrew/Cellar/openjdk@11/11.0.26/libexec/openjdk.jdk/Contents/Home"
      export GROOVY_HOME="/opt/homebrew/opt/groovy/libexec"
      export MAVE_HOME="/Applications/IntelliJ IDEA.app/Contents/plugins/maven/lib/maven3"
      # This `IDEA_HOME` fixed CLI `idea` failed to start issue
      export IDEA_HOME="/Applications/IntelliJ IDEA.app/Contents/MacOS"
      export NPM_CONFIG_USERCONFIG=~/.npmrc
      export PATH="$IDEA_HOME:$PATH"
      export PATH="$HOME/.jenv/bin:$PATH"
      # export PATH="/opt/homebrew/opt/teleport@15.4/bin:$PATH"
      # export PATH="/opt/homebrew/Cellar/ruby/3.4.2/bin:$PATH"
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
}

# First unalias zc if it exists, then define as function to accept command line arguments
unalias zc 2>/dev/null || true
function zc() {
  cd ~/Projects/Java/Typescript/zuche/ && pnpm zuche "$@"
}

a(){
  git fetch origin
  git status
  git add .
  git commit -m "$1"
  git status
  git log -1
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

acm(){
  git fetch origin
  git status
  git add .
  git commit -m "$1"
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
            # ssh-add --apple-use-keychain ~/.ssh/id_ed25519  # or your specific key path
            # ssh-add --apple-use-keychain ~/.ssh/id_rsa  # or your specific key path
            ssh-add -A > /dev/null 2>&1 # Add your key using macOS Keychain
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
      fi
    fi
}

# function az_open_latest_run()
function azolr() {
  local url=$(az pipelines runs list \
    --branch "$(git rev-parse --abbrev-ref HEAD)" \
    --top 1 \
    --query '[0].url' \
    --output tsv | sed 's|_apis/build/Builds|/_build/results?buildId|')
  open "$url"
}

pnpm-up() {
  local ver="${1:-latest}"
  corepack enable
  corepack prepare "pnpm@${ver}" --activate
  echo "✅ pnpm updated to: $(pnpm -v)"
}

make_delta_default(){
	git config --global core.pager delta
	git config --global interactive.diffFilter "delta --color-only"
	git config --global delta.navigate true
}

zshdiff() {
  local file1="${1:-$HOME/.zshrc}"
  local file2="${2:-.zshrc}"

  if diff -u "$file1" "$file2" > /dev/null; then
    echo "✅ Files are identical"
  else
    echo "⚠️ Differences found:"
    diff -u "$file1" "$file2" | delta
  fi
}

# enable Ctrl + S = forward history search 
precmd() { stty sane -ixon 2>/dev/null }

tesla-sei() {
  local repo="$HOME/Projects/dashcam"
  local script="$repo/sei_extractor.py"
  local venv_python=""

  local candidates=(
    "/opt/homebrew/bin/python3"
  )

  local candidate
  for candidate in "${candidates[@]}"; do
    if [[ -x "$candidate" ]]; then
      venv_python="$candidate"
      break
    fi
  done

  if [[ -z "$venv_python" ]]; then
    echo "❌ Could not find a Python executable for tesla-sei."
    echo "Checked:"
    printf '  %s\n' "${candidates[@]}"
    return 1
  fi

  if [[ ! -f "$script" ]]; then
    echo "❌ Could not find sei_extractor.py at: $script"
    return 1
  fi

  "$venv_python" "$script" "$@"
}

# ============================ End of Functions ===========================
# HELLO
