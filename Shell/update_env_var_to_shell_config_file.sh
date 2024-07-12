
# delete lines containing ENV_VAR from the shell config file
# sed is a stream editor used to perform text transformations
# -i '' edit the file in-place, without creating a backup
# '/ENV_VAR=.*/d' is a sed expression that matches lines containing ENV_VAR= and deletes them.
sed -i '' '/ENV_VAR=.*/d' ~/.zshrc

# make this environment variable available to all new shell sessions
echo 'export ENV_VAR="Hello World"' >> ~/.zshrc
source ~/.zshrc

echo Environment Variable ENV_VAR=$ENV_VAR has been set

echo $(cat ~/.zshrc | grep 'export ENV_VAR')