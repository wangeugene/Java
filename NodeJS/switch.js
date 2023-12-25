// write a switch statement
let score = 31;
switch (score) {
    case 1:
        console.log('A')
        break
    case 31:
        console.log('B')
        break
    default:
        console.log('FUCK')
        break
}

// switch boolean the first case which evaluates to be true.
let letter = 'FUCK'
let c = 'l'
const A = new Set(['a', 'e', 'i', 'o', 'u'])
const B = new Set(['b', 'c', 'd', 'f', 'g'])
const C = new Set(['h', 'j', 'k', 'l', 'm'])
const D = new Set(['n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'y', 'z'])
switch (true) {
    case A.has(c):
        letter = 'A'
        break;
    case B.has(c):
        letter = 'B'
        break;
    case C.has(c):
        letter = 'C'
        break;
    case D.has(c):
        letter = 'D'
        break;
    default:
        letter = 'X'
        break;
}
console.log(letter)