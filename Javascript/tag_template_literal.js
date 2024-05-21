function sides(literals, ...expressions) {
    console.log(literals)
    console.log(expressions)
    const [area, perimeter] = expressions
    const discriminant = Math.sqrt(perimeter ** 2 - 16 * area);
    const s1 = (perimeter + discriminant) / 4;
    const s2 = (perimeter - discriminant) / 4;

    // Create an array and sort it in ascending order
    return [s1, s2].sort((a, b) => a - b);
}

// length & width validation set
let [s1, s2] = [10, 14];
console.log(s1, s2);

const [x, y] = sides`The area is: ${s1 * s2}.\nThe perimeter is: ${2 * (s1 + s2)}.`;


console.log((s1 === x) ? s1 : -1);
console.log((s2 === y) ? s2 : -1);