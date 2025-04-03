ssh-keygen -Y verify -n file -I euwang@MBP.local -f ~/.ssh/allowed_signers -s plain.json.sig < plain.json
if [ $? -eq 0 ]; then
    echo "Verification succeeded."
else
    echo "Verification failed."
fi