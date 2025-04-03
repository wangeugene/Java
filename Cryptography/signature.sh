ssh-keygen -Y sign -n file -f ~/.ssh/id_ed25519 - < plain.json > plain.json.sig
cat plain.json.sig