# Javascript inside HTML

- browsers parse HTML line by line, this is the default behavior
- using keyword `defer` to defer the loading of Javascript, until HTML is fully parsed `<script src="JS/script.js" defer></script>`
- using keyword `async` to make loading of Javascript asynchronously from HTML parsing procedure `<script src="JS/script.js" async></script>`

## Javascript modules

- each .js file is a module
- object in one file be exported to be used in another file using `export default` keyword
- the importing .js file should use `import other_module_object from 'some_dir/module_1.js` to import