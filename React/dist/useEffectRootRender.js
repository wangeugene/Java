import App from './useEffectRoot.js';
const container = document.getElementById('root');
const root = createRoot(container);
root.render(React.createElement(React.StrictMode, null,
    React.createElement(App, null)));
