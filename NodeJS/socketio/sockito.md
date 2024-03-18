# Steps

- create an empty dir `mkdir project_root`
- create an empty javascript file `touch server.js`
- create a package.json file `npm init -y`
- install express `npm install express -s` to write to package.json
- install socket.io `npm install socket.io -s` to write to package.json
- install nodemon globally to enable hot swap `npm install -g nodemon`
- add one line to server.js to start the server `app.listen(3000)`
- start the server with `nodemon .\server.js`
- access the url: `http://localhost:3000/`
- should get welcome with 'Cannot GET /' response text

- use `app.use(express.static(_dirname))` to serve static content under the same directory as server.js e.g. index.html

## JS & CSS libs download from CDN, cached in the libs folder, because it's too slow to download from CDN

```.html
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
<script src="https://code.jquery.com/jquery-3.7.1.slim.min.js" crossorigin="anonymous"></script>
```