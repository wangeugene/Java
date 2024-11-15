/*
The console.log("Count at the component level : ", count); 
statement in your React component logs twice 
because React’s Strict Mode, enabled in development mode, 
intentionally calls certain lifecycle methods and functions twice. 
This helps developers identify unexpected side effects and other issues in their code.
*/

import { useEffect, useState } from "react";

export default function UseStatusDemo() {
    const [count, setCount] = useState(0);
    console.log("Count at the component level : ", count); // This will log the updated value of count

    useEffect(() => {
        console.log("Count at  useEffect mounted : ", count); // This will log the updated
        return () => {
            console.log("Count at useEffect unmounted : ", count); // This will log the updated value of count
        };
    }, [count]);
    return (
        <>
            <button onClick={() => setCount(count + 1)}>Click me to increment count</button>
            <p>Count: {count}</p>
        </>
    );
}
