import { useRef } from "react";
import Counter, { CounterRef } from "./imperativeHandler/Counter";

/**
 * ImperativeHandlerDemo is a React functional component that demonstrates the use of imperative handlers.
 * It renders a `Counter` component and a button that allows the parent component to reset the counter.
 *
 * The `Counter` component is accessed via a ref (`counterRef`), and the button's `onClick` handler
 * calls the `reset` method on the `Counter` component using this ref.
 *
 * @component
 * @example
 * return (
 *   <ImperativeHandlerDemo />
 * )
 */
export default function ImperativeHandlerDemo() {
    const counterRef = useRef<CounterRef>(null);
    return (
        <>
            <Counter ref={counterRef} />
            <br></br>
            <button onClick={() => counterRef.current?.reset()}>Reset from the Parent Component</button>
        </>
    );
}
