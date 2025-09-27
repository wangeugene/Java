"use strict";
const sayHiTo = prefixer("Hello");
const sayByeTo = prefixer("Goodbye");
console.log(sayHiTo("Dave")); //prints'HelloDave'
console.log(sayHiTo("Annie")); //prints'HelloAnnie'
console.log(sayByeTo("Dave")); //prints'GoodbyeDave'

function prefixer(prefix) {
    return function (name) {
        return `${prefix} ${name}`;
    };
}
//prefixer returns a function that adds prefix to name
//prefixer is a closure that 'closes over' the variable prefix
//the returned function 'remembers' the value of prefix
//even after prefixer has finished executing
//this is possible because the returned function maintains a reference to the outer function's variables
//so the variable prefix is still accessible when the inner function is called later
//this is a powerful feature of JavaScript that allows for data encapsulation and function factories
//in this case, we created two different functions (sayHiTo and sayByeTo) with different prefixes
//each function retains its own copy of the prefix variable
//this demonstrates how closures can be used to create specialized functions with specific behaviors
