import { forwardRef, Ref, useImperativeHandle, useState } from "react";

export type CounterRef = {
    reset: () => void;
};
function Counter(props: any, ref: Ref<CounterRef>) {
    const [count, setCount] = useState(0);
    const increment = () => setCount(count + 1);
    const decrement = () => setCount(count - 1);
    const reset = () => setCount(27);

    useImperativeHandle(ref, () => ({
        reset,
    }));

    return (
        <>
            <p>Count: {count}</p>
            <button onClick={increment}>increment</button>
            <br />
            <button onClick={decrement}>decrement</button>
        </>
    );
}

export default forwardRef(Counter);
