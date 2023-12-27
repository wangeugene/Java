const event_emitter = require('events');
const emitter = new event_emitter();

emitter.on("customEvent", (message, user) => {
    console.log(`${user}: ${message}`);
})

emitter.emit("customEvent", "Hello World", "Computer");
emitter.emit("customEvent", "That's pretty cool huh?", "Alex");