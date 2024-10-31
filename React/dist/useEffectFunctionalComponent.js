import React, { useState, useEffect } from 'react';
const ExampleComponent = () => {
    const [count, setCount] = useState(0);
    // This useEffect runs after every render
    useEffect(() => {
        console.log('Component rendered or updated');
    });
    // This useEffect runs only once after the initial render
    useEffect(() => {
        console.log('Component mounted');
        return () => {
            console.log('Component will unmount');
        };
    }, []);
    // This useEffect runs when the `count` state changes
    useEffect(() => {
        console.log(`Count changed to ${count}`);
    }, [count]);
    return (React.createElement("div", null,
        React.createElement("p", null,
            "Count: ",
            count),
        React.createElement("button", { onClick: () => setCount(count + 1) }, "Increment")));
};
export default ExampleComponent;
