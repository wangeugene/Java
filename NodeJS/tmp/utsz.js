// Run with: node request.js

const url = "https://yktfk.utsz.edu.cn/order/orderdatamodel";
const body = new URLSearchParams({
    data: "gdenH0wBjo2ogfXujkoxWav3n%2BJSDjQSU8rPzTQ3yF9ZN%2FX8%2ByMDckKPuTcVWLe3u%2BXVnSsJPuzNWXg5I%2F6FGEd3R5teDe05862ISwcoPKCBXIjVKXhbEw%3D%3D",
});

const headers = {
    "x-requested-with": "XMLHttpRequest",
    "user-agent":
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) MacWechat/3.8.7(0x13080712) UnifiedPCMacWechat(0xf26411f0) XWEB/16512 Flue",
    accept: "*/*",
    "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
    origin: "https://yktfk.utsz.edu.cn",
    "sec-fetch-site": "same-origin",
    "sec-fetch-mode": "cors",
    "sec-fetch-dest": "empty",
    referer:
        "https://yktfk.utsz.edu.cn/visitor/visitoredit?data=w2lURiv74Z5DVHqw4NYEgHiuahPyzr37DNhmR4BhT5U2dPfsiWyfAeQv6AoxpSKvQ2eseqg2dCfMwE9zdbZLOwk0C7ekSTnD6Ga1yToKj4k=",
    "accept-encoding": "gzip, deflate, br",
    "accept-language": "en-US,en;q=0.9",
    cookie: "c_should_know=on; c_promise=on; ASP.NET_SessionId=n3zjphobgdp1cfinvtg0cf3p",
    priority: "u=1, i",
};

async function main() {
    const res = await fetch(url, {
        method: "POST",
        headers,
        body,
        compress: true,
    });

    const text = await res.text(); // or res.json() if the response is JSON
    console.log("Status:", res.status);
    console.log("Response:\n", text);
}

main().catch(console.error);
