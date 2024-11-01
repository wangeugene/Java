import React, { useState, useEffect } from 'react';

const ExampleComponent: React.FC = () => {
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

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
    </div>
  );
};

export default ExampleComponent;