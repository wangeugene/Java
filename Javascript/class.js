class Polygon {
    constructor(sides) {
        this.sides = sides;
    }

    perimeter() {
        this.perimeter = this.sides.reduce((a, b) => a + b, 0);
        return this.perimeter;
    }
}

const triangle = new Polygon([3, 4, 5]);
console.log(triangle.perimeter());  // 12 (3 + 4 + 5)
const rectangle = new Polygon([10, 20, 10, 20]);
console.log(rectangle.perimeter());  // 60  (10 + 20 + 10 + 20)
const pentagon = new Polygon([10, 20, 30, 40, 43]);
console.log(pentagon.perimeter());  // 143  (10 + 20 + 30 + 40 + 43)
