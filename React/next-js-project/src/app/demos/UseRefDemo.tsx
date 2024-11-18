import { useRef, useState } from "react";

/**
 * A React functional component demonstrating the use of `useRef` and `useState` hooks.
 *
 * @component
 * @example
 * return (
 *   <UseRefDemo />
 * )
 * comment the line contains setCount to see the difference between count and countRef.current
 * useRef does not trigger re-render when its value changes
 * useState triggers re-render when its value changes
 */
export default function UseRefDemo() {
    const countRef = useRef<number>(0);
    const [count, setCount] = useState<number>(0);

    const handleClick = () => {
        setCount(count + 1);
        countRef.current = countRef.current + 1;
        console.log("count: ", count);
        console.log("countRef.current: ", countRef.current);
    };
    return (
        <>
            <button onClick={handleClick}> Click me to increment count </button>
            <p>Count: {count}</p>
            <p>CountRef.current: {countRef.current}</p>
        </>
    );
}
