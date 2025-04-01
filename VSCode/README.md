# Tips

## Keyboard Shortcuts

Choose the default keybindings is a good idea, cuz it's the most common shortcuts in most of the editors.

### use Option key as the Meta key

Cmd + , -> search for "meta" -> check "Use Option as Meta key" in the terminal section
This will enable shortcuts like `Option + F` to move forward one word in the terminal.

## Copilot

### Tagging the files and the folders can give copilot more insights to your problems

e.g., #codebase, #<file_name>, to include the files to ask better questions
Just type # then the file name, and it will show the file name in the suggestion list.


## Test

### ts-jest 
> ts-jest[ts-compiler] (WARN) Using hybrid module kind (Node16/18/Next) is only supported in "isolatedModules: true". Please set "isolatedModules: true" in your tsconfig.json.

- Adding this in `tsconfig.json` actually brakes the smoke test cases.

