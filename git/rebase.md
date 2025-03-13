## update email address of the last 4 git commits

```zsh
git rebase -i HEAD~4
# edit the file using vim, replacing with this command in vim
# :%s/pick/edit/g then, :wq to save the file

# amend the oldest git commit first
git commit --amend --author="Your Name <yuzhen23@icloud.com>"

# this will open a file with vim, :wq save it

# then execute, repeatly, totaly four times
git rebase --continue

# at last, you will see git show message something like: successfully rebased xxx branch

# then override the remote branch with force
git push --force 

```
