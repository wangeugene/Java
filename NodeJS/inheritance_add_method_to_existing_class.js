class Rectangle {
    constructor(w, h) {
        this.w = w;
        this.h = h;
    }
}

// arrow function is not useful here!
Rectangle.prototype.area = function () {
    return this.w * this.h
};

class Square extends Rectangle {
    constructor(w) {
        super(w, w)
    }
}

if (JSON.stringify(Object.getOwnPropertyNames(Square.prototype)) === JSON.stringify(['constructor'])) {
    const rec = new Rectangle(3, 4);
    const sqr = new Square(3);

    console.log(rec.area());
    console.log(sqr.area());
} else {
    console.log(-1);
    console.log(-1);
}