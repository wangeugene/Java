// To read the configuration from a URL: https://s1.trojanflare.one/surge/01580412-b537-4f92-90d8-b4db69c20d80
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
