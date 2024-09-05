import {globSync} from 'glob'

const paths = ['./Shell/*', './Swift/*', './markdown/**/*.md'];

paths.forEach((pathGlob) => {
    const files = globSync(pathGlob);
    files.forEach((file) =>{
        console.log(file);
    });
});