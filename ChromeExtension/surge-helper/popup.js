const BASE_URL = "https://wangeugene.cc";

let currentDomain = null;

function setStatus(message, isError = false) {
    const el = document.getElementById("status");
    el.textContent = message;
    el.style.color = isError ? "red" : "green";
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
        } catch (err) {
            setStatus("Invalid URL.", true);
        }
    });
}

function storageKeyForDomain(domain) {
    return `proxy_enabled:${domain}`;
}

async function getProxyEnabled(domain) {
    return new Promise((resolve) => {
        chrome.storage.local.get([storageKeyForDomain(domain)], (result) => {
            resolve(Boolean(result[storageKeyForDomain(domain)]));
        });
    });
}

async function setProxyEnabled(domain, enabled) {
    return new Promise((resolve) => {
        chrome.storage.local.set({ [storageKeyForDomain(domain)]: Boolean(enabled) }, () => resolve());
    });
}

async function syncToggleFromStorage() {
    if (!currentDomain) return;
    const toggle = document.getElementById("toggle-proxy");
    if (!toggle) return;

    toggle.disabled = true;
    try {
        const enabled = await getProxyEnabled(currentDomain);
        toggle.checked = enabled;
    } finally {
        toggle.disabled = false;
    }
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

// Wire up event listeners
document.addEventListener("DOMContentLoaded", () => {
    initDomain();

    // Once the domain is loaded, sync the switch state from local storage.
    // (initDomain uses a callback-based API, so we poll briefly for currentDomain.)
    const syncTimer = setInterval(async () => {
        if (!currentDomain) return;
        clearInterval(syncTimer);
        await syncToggleFromStorage();
    }, 50);

    const toggle = document.getElementById("toggle-proxy");
    toggle.addEventListener("change", async () => {
        // Guard: if we don't have a domain yet, revert.
        if (!currentDomain) {
            toggle.checked = false;
            setStatus("No domain detected.", true);
            return;
        }

        const desiredState = toggle.checked;

        // Disable while the request is in flight
        toggle.disabled = true;

        // Optimistic UI is fine, but revert on failure.
        let ok = false;
        if (desiredState) {
            ok = await addDomainName("gfw.list");
        } else {
            ok = await deleteDomainName();
        }

        if (ok) {
            await setProxyEnabled(currentDomain, desiredState);
        } else {
            // Revert toggle to the last known good state
            const last = await getProxyEnabled(currentDomain);
            toggle.checked = last;
        }

        toggle.disabled = false;
    });

    document.getElementById("btn-open-config").addEventListener("click", openConfig);
});
