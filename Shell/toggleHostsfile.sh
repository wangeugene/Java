# Desc: Toggles between hosts files
# File to store the toggle state
# put the following into the zshrc file
# alias toggleHostsfile='/Users/eugene/IdeaProjects/Java/Shell/toggleHostsfile.sh' 
# Initialize the state file if it doesn't exist
TOGGLE_STATE_FILE="/tmp/hosts_toggle_state"
if [ ! -f "$TOGGLE_STATE_FILE" ]; then
    echo "0" > "$TOGGLE_STATE_FILE"
fi

# Read the current state
TOGGLE_STATE=$(cat "$TOGGLE_STATE_FILE")

# Toggle logic
if [ "$TOGGLE_STATE" -eq "0" ]; then
    sudo cp /etc/hosts_empty /etc/hosts
    echo "1" > "$TOGGLE_STATE_FILE"
else
    sudo cp /etc/hosts_epc /etc/hosts
    echo "0" > "$TOGGLE_STATE_FILE"
fi

cat /etc/hosts