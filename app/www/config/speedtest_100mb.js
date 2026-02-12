/**
 * Surge (macOS) General Script
 * 100MB throughput test per policy (chunked download)
 *
 * How it works:
 * - For each policy, download CHUNK_BYTES repeatedly until TOTAL_BYTES reached
 * - Measure total elapsed time, compute MB/s and Mbps
 *
 * Tips:
 * - Run when network is otherwise idle for best accuracy
 * - Consider turning off MITM for speed.cloudflare.com to avoid overhead
 * 
 * How to run:
 * 
 surge-cli script evaluate \
~/Projects/Java/app/www/config/speedtest_100mb.js \
generic 120 > result.json && cat result.json | jq
 */

const POLICIES = [
    "HongKong-IPLC-HK-1-Rate:1",
    "HongKong-IPLC-HK-2-Rate:1",
    "HongKong-IPLC-HK-3-Rate:1",
    "HongKong-IPLC-HK-4-Rate:1",
    "HongKong-IPLC-HK-5-Rate:1",
    "HongKong-IPLC-HK-6-Rate:1",
    "Japan-FW-JP1-Rate:1",
    "Japan-FW-JP2-Rate:1",
    "UnitedStates-FW-US1-Rate:1",
    "UnitedStates-FW-US2-Rate:1",
    "UnitedStates-FW-US3-Rate:1",
    "Japan-FW-JP3-Rate:1",
    "Japan-FW-JP4-Rate:1",
    "Japan-FW-JP5-Rate:1",
    "Singapore-FW-SG1-Rate:1",
    "Singapore-FW-SG2-Rate:1",
    "Singapore-FW-SG3-Rate:1",
    "Singapore-FW-SG4-Rate:1",
    "Taiwan-FW-TW1-Rate:1",
    "Taiwan-FW-TW2-Rate:1",
    "Taiwan-FW-TW3-Rate:1",
    "Taiwan-FW-TW4-Rate:1",
    "Taiwan-FW-TW5-Rate:1",
    "HongKong-FW-HK1-Rate:1",
    "HongKong-FW-HK2-Rate:1",
    "HongKong-FW-HK3-Rate:1",
    "HongKong-FW-HK4-Rate:1",
    "HongKong-FW-HK5-Rate:1",
    "HongKong-FW-HK6-Rate:1",
    "Japan-IPLC-JP1-Rate:1",
    "Japan-IPLC-JP2-Rate:1",
    "Japan-IPLC-JP3-Rate:1",
    "Japan-IPLC-JP4-Rate:1",
    "Japan-IPLC-JP5-Rate:1",
    "UnitedStates-IPLC-US1-Rate:1",
    "Osaka-OS-1-Rate:1",
    "Osaka-OS-2-Rate:1",
    "UnitedStates-IPLC-US2-Rate:1",
    "UnitedStates-IPLC-US3-Rate:1",
    "UnitedStates-IPLC-US4-Rate:1",
    "UnitedStates-IPLC-US5-Rate:1",
    "Singapore-IPLC-SG1-Rate:1",
    "Singapore-IPLC-SG2-Rate:1",
    "Taiwan-IPLC-TW1-Rate:1",
    "Taiwan-IPLC-TW2-Rate:1",
    "Taiwan-IPLC-TW3-Rate:1",
];

// Total test size: 10 MiB (more precise than 100,000,000 bytes)
const TOTAL_BYTES = 10 * 1024 * 1024;

// Chunk size: 1 MiB (safe for memory); 10 chunks => 100 MiB
const CHUNK_BYTES = 1 * 1024 * 1024;

// =============================
// Test Endpoint Configuration
// =============================
// Recommended: Cloudflare speed test endpoint (supports exact byte sizes)
// Docs/usage pattern: https://speed.cloudflare.com/__down?bytes=<N>
//
// Notes:
// - Using `bytes` makes "chunk" actually mean "chunk".
// - Add a cache-bust param so each request is fresh.
// - This endpoint returns arbitrary data for benchmarking.
const BASE_TEST_URL = "https://speed.cloudflare.com";

function makeUrl(bytes) {
    const b = Math.max(1, Math.floor(bytes || 1));
    const cacheBust = Date.now().toString(36) + Math.random().toString(36).slice(2);
    return `${BASE_TEST_URL}/__down?bytes=${b}&_=${cacheBust}`;
}

// Per-request timeout (ms)
const TIMEOUT_MS = 30_000;

// Progress reporting (throttled to avoid notification spam)
const PROGRESS_NOTIFY_INTERVAL_MS = 2_000; // 2s
let _lastProgressNotifyMs = 0;

function safeNotify(title, message) {
    try {
        $notification.post("Surge SpeedTest (100MiB)", title, message);
    } catch (_) {
        // In some execution environments (e.g., CLI evaluate), notifications may be unavailable.
    }
}

function reportProgress({ totalPolicies, policyIndex, policy, chunk, chunks, downloadedBytes, totalBytes }) {
    const now = Date.now();
    const policyPct = totalBytes > 0 ? (downloadedBytes / totalBytes) * 100 : 0;
    const overallPct =
        totalPolicies > 0
            ? ((policyIndex + Math.min(downloadedBytes / (totalBytes || 1), 1)) / totalPolicies) * 100
            : 0;

    const line = `Testing ${policyIndex + 1}/${totalPolicies}: ${policy} | Chunk ${chunk}/${chunks} | ${policyPct.toFixed(
        1,
    )}% (overall ${overallPct.toFixed(1)}%)`;

    // Always log progress for visibility in script logs
    console.log(line);

    // Throttle notifications (optional, can be noisy)
    if (now - _lastProgressNotifyMs >= PROGRESS_NOTIFY_INTERVAL_MS) {
        _lastProgressNotifyMs = now;
        safeNotify(`Running ${policyIndex + 1}/${totalPolicies}`, line);
    }
}

// A tiny warmup request (helps reduce first-connection bias)
const WARMUP_BYTES = 128 * 1024; // 128 KiB

function httpGet({ url, policy, timeoutMs }) {
    return new Promise((resolve, reject) => {
        $httpClient.get(
            {
                url,
                policy, // IMPORTANT: route this request via a specific policy
                timeout: timeoutMs / 1000, // Surge uses seconds
                headers: {
                    "Cache-Control": "no-cache, no-store, must-revalidate",
                    Pragma: "no-cache",
                    Expires: "0",
                    // Keep-Alive hint (not guaranteed, but harmless)
                    Connection: "keep-alive",
                    // Avoid content-encoding differences affecting byte accounting
                    "Accept-Encoding": "identity",
                    Accept: "application/octet-stream,*/*",
                    "User-Agent": "SurgeSpeedTest/1.0",
                },
            },
            (err, resp, data) => {
                if (err) return reject(err);
                // data is a string/buffer-like; we don't need to keep it
                const len =
                    resp && resp.headers && (resp.headers["Content-Length"] || resp.headers["content-length"])
                        ? parseInt(resp.headers["Content-Length"] || resp.headers["content-length"], 10)
                        : data
                          ? data.length
                          : 0;

                resolve({ status: resp?.status, bytes: Number.isFinite(len) ? len : 0 });
            },
        );
    });
}

function nowMs() {
    return Date.now();
}

function fmt(n, digits = 2) {
    return Number(n).toFixed(digits);
}

async function testPing(policy, ctx) {
    /**
     * Ping test: measure latency to verify connectivity
     * Uses a minimal request (1 byte) to establish baseline
     */
    try {
        const t0 = nowMs();
        await httpGet({ url: makeUrl(1), policy, timeoutMs: TIMEOUT_MS });
        const t1 = nowMs();
        const latency = t1 - t0;
        safeNotify(`${policy} - Ping`, `Latency: ${latency}ms`);
        return { policy, latency, connected: true };
    } catch (e) {
        safeNotify(`${policy} - Ping Failed`, String(e));
        return { policy, latency: null, connected: false, error: String(e) };
    }
}

async function testPolicy(policy, ctx) {
    // Ping test first (connectivity check)
    const pingResult = await testPing(policy, ctx);
    if (!pingResult.connected) {
        throw new Error(`Connectivity test failed: ${pingResult.error}`);
    }

    // Warmup (best-effort)
    try {
        await httpGet({ url: makeUrl(WARMUP_BYTES), policy, timeoutMs: TIMEOUT_MS });
    } catch (_) {
        // ignore warmup failures; real test may still work
    }

    // Progress: start
    if (ctx && typeof ctx.onProgress === "function") {
        ctx.onProgress({
            totalPolicies: ctx.totalPolicies,
            policyIndex: ctx.policyIndex,
            policy,
            chunk: 0,
            chunks: Math.ceil(TOTAL_BYTES / CHUNK_BYTES),
            downloadedBytes: 0,
            totalBytes: TOTAL_BYTES,
        });
    }

    const chunks = Math.ceil(TOTAL_BYTES / CHUNK_BYTES);
    let downloaded = 0;

    const t0 = nowMs();
    for (let i = 0; i < chunks; i++) {
        const want = Math.min(CHUNK_BYTES, TOTAL_BYTES - downloaded);
        const res = await httpGet({ url: makeUrl(want), policy, timeoutMs: TIMEOUT_MS });

        // If server doesn't report length reliably, fallback to "want"
        const got = res.bytes > 0 ? res.bytes : want;
        downloaded += got;

        if (ctx && typeof ctx.onProgress === "function") {
            ctx.onProgress({
                totalPolicies: ctx.totalPolicies,
                policyIndex: ctx.policyIndex,
                policy,
                chunk: i + 1,
                chunks,
                downloadedBytes: downloaded,
                totalBytes: TOTAL_BYTES,
            });
        }
    }
    const t1 = nowMs();

    const seconds = (t1 - t0) / 1000;
    const mb = downloaded / (1024 * 1024);
    const mbps = mb / seconds; // MiB/s
    const mbitps = (downloaded * 8) / seconds / 1_000_000; // Mbps (decimal)

    return {
        policy,
        seconds,
        downloadedBytes: downloaded,
        mb,
        mbps,
        mbitps,
    };
}

async function main() {
    const results = [];
    const failures = [];
    _lastProgressNotifyMs = 0; // reset throttling per run
    const totalPolicies = POLICIES.length;

    for (let policyIndex = 0; policyIndex < POLICIES.length; policyIndex++) {
        const p = POLICIES[policyIndex];
        try {
            const r = await testPolicy(p, {
                policyIndex,
                totalPolicies,
                onProgress: reportProgress,
            });
            results.push(r);
        } catch (e) {
            failures.push({ policy: p, error: String(e) });
        }
    }

    results.sort((a, b) => b.mbps - a.mbps);

    const lines = results.map((r, idx) => {
        return `${idx + 1}. ${r.policy}  ${fmt(r.mbps)} MiB/s  (${fmt(r.mbitps)} Mbps)  time=${fmt(r.seconds)}s`;
    });

    if (failures.length) {
        lines.push("");
        lines.push("Failed:");
        for (const f of failures) lines.push(`- ${f.policy}: ${f.error}`);
    }

    const summary = results.length
        ? {
              fastest: results[0].policy,
              fastestMiBs: Number(fmt(results[0].mbps)),
              fastestMbps: Number(fmt(results[0].mbitps)),
          }
        : null;

    const output = {
        timestamp: new Date().toISOString(),
        totalPolicies,
        tested: results.length,
        failed: failures.length,
        summary,
        results: results.map((r, idx) => ({
            rank: idx + 1,
            policy: r.policy,
            seconds: Number(fmt(r.seconds)),
            downloadedMiB: Number(fmt(r.mb)),
            speedMiBs: Number(fmt(r.mbps)),
            speedMbps: Number(fmt(r.mbitps)),
        })),
        failures,
    };

    const title = summary ? `Fastest: ${summary.fastest} (${summary.fastestMiBs} MiB/s)` : "Speed test failed";

    // Keep notification for human readability
    $notification.post("Surge SpeedTest (100MiB)", title, "JSON result available in script output");

    // Return structured JSON result
    console.log(JSON.stringify(output, null, 2));
    $done(output);
    // $done(output);
}

main().catch((e) => {
    $notification.post("Surge SpeedTest (100MiB)", "Fatal error", String(e));
    $done({ error: String(e) });
});
