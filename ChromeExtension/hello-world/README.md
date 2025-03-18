# Getting Started With Google Chrome Extensions (Hello World)

This example demonstrates how to create a simple "Hello World" Chrome Extension.
For more details, visit the [official tutorial](https://developer.chrome.com/docs/extensions/get-started/tutorial/hello-world).

## Running This Extension

1. Clone this repository.
2. Load this directory in Chrome as an [unpacked extension](https://developer.chrome.com/docs/extensions/mv3/getstarted/development-basics/#load-unpacked).
3. Click the extension icon in the Chrome toolbar, then select the "Hello Extensions" extension. A popup will appear displaying the text "Hello Extensions".

## Working equivalent of the extension

```nodejs
fetch("https://m.zuche.com/api/gw.do?uri=/action/carrctapi/order/hitchList/v1", {
  "headers": {
    "accept": "application/json, text/plain, */*",
    "accept-language": "en",
    "content-type": "application/x-www-form-urlencoded",
    "sec-fetch-dest": "empty",
    "sec-fetch-mode": "cors",
    "sec-fetch-site": "same-origin",
    "cookie": "lctuid=4509213c792233e1c4917b22539515fa; CAR_UID=7ff48ce4-6a13-4bf5-ac0f-62ba846d784e1742208766650; LOGIN_MOBILE=; ENCRYPT_MEMBER_ID=; intranet-sessionid=677ccee5-50ab-4696-8f71-58974b7076c8",
    "Referer": "https://m.zuche.com/",
    "Referrer-Policy": "strict-origin-when-cross-origin"
  },
  "body": "data=%7B%22pickupCityId%22%3A%2215%22%2C%22returnCityId%22%3A%22%22%2C%22useCarTime%22%3A%22%22%2C%22pageNo%22%3A2%2C%22pageSize%22%3A10%2C%22source%22%3A2%7D",
  "method": "POST"
});
```

```zsh
curl 'https://m.zuche.com/api/gw.do?uri=/action/carrctapi/order/hitchList/v1' \
  -H 'Accept: application/json, text/plain, */*' \
  -H 'Accept-Language: en' \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -b 'lctuid=4509213c792233e1c4917b22539515fa; CAR_UID=7ff48ce4-6a13-4bf5-ac0f-62ba846d784e1742208766650; LOGIN_MOBILE=; ENCRYPT_MEMBER_ID=; intranet-sessionid=677ccee5-50ab-4696-8f71-58974b7076c8' \
  -H 'Origin: https://m.zuche.com' \
  -H 'Referer: https://m.zuche.com/' \
  -H 'Sec-Fetch-Dest: empty' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1' \
  --data-raw 'data=%7B%22pickupCityId%22%3A%2215%22%2C%22returnCityId%22%3A%22%22%2C%22useCarTime%22%3A%22%22%2C%22pageNo%22%3A2%2C%22pageSize%22%3A10%2C%22source%22%3A2%7D' | jq
```