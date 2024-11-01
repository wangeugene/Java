// node function_is_value.js
function sayHi() {
    // (1) create
    console.log("Hello");
}

let func = sayHi; // (2) copy

func(); // Hello     // (3) run the copy (it works)!
sayHi(); // Hello    //     this still works too (why wouldn't it)
