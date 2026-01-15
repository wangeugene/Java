import { readConfigFromURL } from "./configURLReader.js";
import { extractProxySection } from "./proxySection.js";

const URL = "https://s1.trojanflare.one/surge/01580412-b537-4f92-90d8-b4db69c20d80";
const response = await readConfigFromURL(URL);

const proxySection = extractProxySection(response);
console.log("Extracted Proxy Section:\n", proxySection);
