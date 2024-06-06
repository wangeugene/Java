# remove lines matching 'export ENV_VAR="Hello World"' in ~/.zshrc file

sed -i '' '/export ENV_VAR=".*"/d' ~/.zshrc

# make this environment variable available to all new shell sessions
echo 'export ENV_VAR="Hello World"' >> ~/.zshrc
source ~/.zshrc