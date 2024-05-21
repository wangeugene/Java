// new Rectangular Object
const create_rectangle = (length, width) => {
    this.length = length;
    this.width = width;
    this.area = () => {
        return this.length * this.width;
    };
    this.perimeter = () => {
        return 2 * (this.length + this.width);
    };
    return this;
}

// another way to create an object which I think is better
function Rectangle(a, b) {
    this.length = a;
    this.width = b;
    this.area = this.length * this.width
    this.perimeter = 2 * (this.length + this.width)
}

aRectangle = create_rectangle(2, 3)
console.log(aRectangle.area());
console.log(aRectangle.perimeter());

const rec = new Rectangle(5, 6)
console.log(rec.length)
console.log(rec.width)
console.log(rec.area)
console.log(rec.perimeter)