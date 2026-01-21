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

async function callEdit(fileName) {
    if (!currentDomain) {
        setStatus("No domain detected.", true);
        return;
    }

    setStatus(`Updating ${fileName} rule...`);

    const url =
        `${BASE_URL}/edit/gfw?` +
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
            return;
        }

        const text = await res.text();
        setStatus(`Success: ${text || "ok"}`);
    } catch (err) {
        setStatus(`Request failed: ${err.message}`, true);
    }
}

async function callDelete() {
    if (!currentDomain) {
        setStatus("No domain detected.", true);
        return;
    }

    setStatus("Deleting rule...");

    const url =
        `${BASE_URL}/edit/gfw?` +
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
            return;
        }

        const text = await res.text();
        setStatus(`Success: ${text || "deleted"}`);
    } catch (err) {
        setStatus(`Request failed: ${err.message}`, true);
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

    document.getElementById("btn-proxy").addEventListener("click", () => callEdit("gfw.list"));

    document.getElementById("btn-delete").addEventListener("click", () => callDelete());

    document.getElementById("btn-open-config").addEventListener("click", openConfig);
});
