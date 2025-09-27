// app.js
const assert = require("assert");

// build the prototype chain: leopard -> lynx -> cat
const leopardProto = Object.create(null, {
    hiss: {
        value: function () {
            console.log(`${this.name} the cat: hiss`);
        },
    },
});

const lynxProto = Object.create(leopardProto, {
    purr: {
        value: function () {
            console.log(`${this.name} the cat: purr`);
        },
    },
});

const catProto = Object.create(lynxProto, {
    meow: {
        value: function () {
            console.log(`${this.name} the cat: meow`);
        },
    },
});

// TODO from the lab: instantiate a cat
const felix = Object.create(catProto, {
    name: { value: "Felix", writable: true },
});

felix.meow(); // prints Felix the cat: meow
felix.purr(); // prints Felix the cat: purr
felix.hiss(); // prints Felix the cat: hiss

// prototype checks, do not remove
const felixProto = Object.getPrototypeOf(felix);
const felixProtoProto = Object.getPrototypeOf(felixProto);
const felixProtoProtoProto = Object.getPrototypeOf(felixProtoProto);

assert(Object.getOwnPropertyNames(felixProto).length, 1);
assert(Object.getOwnPropertyNames(felixProtoProto).length, 1);
assert(Object.getOwnPropertyNames(felixProtoProtoProto).length, 1);
assert(typeof felixProto.meow, "function");
assert(typeof felixProtoProto.purr, "function");
assert(typeof felixProtoProtoProto.hiss, "function");
console.log("prototype checks passed!");
