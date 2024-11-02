import ExampleComponent from './useEffectFunctionalComponent.js';
const App = () => {
    return (React.createElement("div", null,
        React.createElement("h1", null, "Welcome to My App"),
        React.createElement(ExampleComponent, null)));
};
export default App;
