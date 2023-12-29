$$ is a shortcut for document.querySelectorAll on the console of Edge and Chrome

```edge console
const images = $$('img'); // select all <img> nodes
for (let image in images) {
console.log(images[image].src)
}
```