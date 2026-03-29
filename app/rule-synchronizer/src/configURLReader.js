// To read the configuration from a URL: https://s1.trojanflare.one/surge/mocked_id
// Using the Node.js 24 built-in fetch API

export async function readConfigFromURL(url) {
    try {
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error(`Failed to fetch config: ${response.statusText}`);
        }
        const configText = await response.text();
        return configText;
    } catch (error) {
        console.error("Error reading config from URL:", error);
        throw error;
    }
}
