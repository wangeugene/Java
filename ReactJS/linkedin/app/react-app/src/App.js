import './App.css';
import {useState, useEffect, useReducer, useRef} from "react"

// array destructuring
const [firstCity, secondCity] = [
    "Tokyo",
    "Tahoe City",
    "Bend"
]

console.log(firstCity)
console.log(secondCity)

// {library} is called props destructuring, same as props.library accessing style
function App({library}) {
    const [emotion, setEmotion] = useState("happy")
    const [secondary, setSecondary] = useState("tired")
    useEffect(() => {
        console.log(`It's ${emotion} right now`);
    }, [emotion]);
    useEffect(() => {
        console.log(`It's ${secondary} around here`);
    }, [secondary]);

    const [checked, setChecked] = useState(false);

    const [checked2, setChecked2] = useReducer((checked2) => !checked2, false);

    const txtTitle = useRef();
    const hexColor = useRef();
    const submit = (e) => {
        e.preventDefault();
    }
    return (
        <div className="App">
            <h1>Hello from {library}</h1>
            <h1>Current emotion is {emotion}</h1>
            <button onClick={() => setEmotion("sad")}>Sad</button>
            <button onClick={() => setEmotion("excited")}>Excited</button>
            <h2>Current secondary emotion is {secondary}</h2>
            <button onClick={() => setSecondary("grateful")}>Grateful</button>

            <p/>
            <input type="checkbox"
                   value={checked}
                   onChange={() => {
                       setChecked((checked) => !checked)
                   }}
            />
            <label>{checked ? "Checked" : "Not Checked"}</label>
            <p/>

            <input type="checkbox"
                   value={checked2}
                   onChange={setChecked2}/>
            <label>{checked2 ? "Checked2" : "Not Checked2"}</label>

            <p/>
            <form>
                <input
                    ref={txtTitle}
                    type="text"
                    placeholder="color title"
                />
                <input
                    ref={hexColor}
                    type="color"/>
                <button>ADD</button>
            </form>
        </div>
    );
}

export default App;
