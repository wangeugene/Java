const BASE_URL = "https://wangeugene.cc";
const SURGE_LOCAL_URL = "https://localhost:9000";

let currentDomain = null;

function setStatus(message, isError = false) {
    const el = document.getElementById("status");
    el.textContent = message;
    el.style.color = isError ? "red" : "green";
}

async function surgeProfileReload() {
    try {
        const url = `${SURGE_LOCAL_URL}/v1/profiles/reload`;

        const res = await fetch(url, {
            method: "POST",
            headers: {
                "X-Key": "euwang",
            },
        });

        if (!res.ok) {
            const text = await res.text();
            setStatus(`Error reloading Surge profile: ${res.status} ${text}`, true);
        } else {
            setStatus("Surge profile reloaded successfully.");
        }
    } catch (err) {
        setStatus(`Request failed: ${err.message}`, true);
    }
}

async function initToggleStatus(currentDomain) {
    const toggle = document.getElementById("toggle-proxy");
    try {
        const url =
            `${BASE_URL}/gfw/exists?` +
            new URLSearchParams({
                domainName: currentDomain,
            });

        const res = await fetch(url, {
            method: "GET",
        });

        if (!res.ok) {
            const text = await res.text();
            setStatus(`Error: ${res.status} ${text}`, true);
            toggle.checked = false;
        } else {
            const json = await res.json();
            toggle.checked = json["exists"] === true;
            setStatus(`Success: this ${currentDomain} is ` + (json["exists"] ? "proxied" : "not proxied"));
        }
    } catch (err) {
        setStatus(`Request failed: ${err.message}`, true);
    }
}

// Get active tab URL and extract hostname
function initDomain() {
    chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
        const tab = tabs[0];
        if (!tab || !tab.url) {
            setStatus("No active tab URL found.", true);
            return;
        }

        try {
            const url = new URL(tab.url);
            let hostname = url.hostname;

            // Optional: strip leading www.
            if (hostname.startsWith("www.")) {
                hostname = hostname.slice(4);
            }

            currentDomain = hostname;
            document.getElementById("domain").textContent = currentDomain;
            setStatus("");
            initToggleStatus(currentDomain);
        } catch (err) {
            setStatus("Invalid URL.", true);
        }
    });
}

function storageKeyForDomain(domain) {
    return `proxy_enabled:${domain}`;
}

async function addDomainName(fileName) {
    if (!currentDomain) {
        setStatus("No domain detected.", true);
        return false;
    }

    setStatus(`Updating ${fileName} rule...`);

    const url =
        `${BASE_URL}/gfw?` +
        new URLSearchParams({
            domainName: currentDomain,
        });

    try {
        const res = await fetch(url, {
            method: "POST",
        });

        if (!res.ok) {
            const text = await res.text();
            setStatus(`Error: ${res.status} ${text}`, true);
            return false;
        }

        const text = await res.text();
        setStatus(`Success: ${text || "ok"}`);
        return true;
    } catch (err) {
        setStatus(`Request failed: ${err.message}`, true);
        return false;
    }
}

async function deleteDomainName() {
    if (!currentDomain) {
        setStatus("No domain detected.", true);
        return false;
    }

    setStatus("Deleting rule...");

    const url =
        `${BASE_URL}/gfw?` +
        new URLSearchParams({
            domainName: currentDomain,
        });

    try {
        const res = await fetch(url, {
            method: "DELETE",
        });

        if (!res.ok) {
            const text = await res.text();
            setStatus(`Error: ${res.status} ${text}`, true);
            return false;
        }

        const text = await res.text();
        setStatus(`Success: ${text || "deleted"}`);
        return true;
    } catch (err) {
        setStatus(`Request failed: ${err.message}`, true);
        return false;
    }
}

function openConfig() {
    chrome.tabs.create({
        url: `${BASE_URL}/config/gfw.list`,
    });
}

document.addEventListener("DOMContentLoaded", () => {
    initDomain();

    const toggle = document.getElementById("toggle-proxy");
    toggle.addEventListener("change", async () => {
        if (!currentDomain) {
            toggle.checked = false;
            setStatus("No domain detected.", true);
            return;
        }

        toggle.disabled = true;

        try {
            const userWantsEnabled = toggle.checked;

            // Step 1) Send mutation request
            const ok = userWantsEnabled ? await addDomainName("gfw.list") : await deleteDomainName();

            if (!ok) {
                setStatus("Update failed; syncing from server...", true);
            }

            // Step 2) Always query server and set the toggle based on /gfw/exists
            await initToggleStatus(currentDomain);
        } finally {
            toggle.disabled = false;
        }
        await surgeProfileReload();
    });

    document.getElementById("btn-open-config").addEventListener("click", openConfig);
});
