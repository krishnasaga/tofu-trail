
## What is an “Origin”?

An **origin** is the combination of

- **Scheme (protocol):** `http` or `https`
- **Host (domain):** `example.com`
- **Port:** `80`, `443`, `3000`, etc.

**Formula:**
`origin = scheme + host + port`

## Same-Origin Policy (SOP)

The **same-origin policy** is a browser security rule:  
A web page can **read responses/data only from the same origin as itself**.  
It prevents a random website you open from using JavaScript to read data from other websites.

### Examples

#### Same origin (allowed by SOP)
**Webpages**
- `https://example.com/page1`
- `https://example.com/page2`

**API URLs**
- `https://example.com/api/v1/users`
- `https://example.com/api/v1/orders/123`

These match on:
- scheme: `https`
- host: `example.com`
- port: `443` (default for `https`)


### Different origin (blocked by SOP for reading)

- `http://example.com` vs `https://example.com` → different **scheme**
- `https://example.com` vs `https://api.example.com` → different **host** (subdomain counts)
- `https://example.com` vs `https://example.com:8443` → different **port**


## What SOP blocks

If you’re on `https://evil.com`, browser blocks JavaScript from **reading** responses from:
- `https://bank.com`
- `https://api.weather.example`
by default.

This mainly affects:
- `fetch()` / XHR reading responses

## What is CORS ( Cross Origin Resource Sharing )

Same-Origin Policy (SOP) exists for security: it’s the browser’s default rule that prevents one website’s JavaScript from freely reading another website’s responses. But real-world web apps aren’t built as one monolithic site anymore

-   **How do modern websites stay usable when apps and APIs live on different domains?**
-   **If your frontend is on `https://app.example.com` and your API is on `https://api.example.com`, how does the browser allow the app to actually use the API?**

That’s where **CORS helps usability**.
        
-   **CORS is the usability bridge** that lets those pieces work together safely:
    -   The API can say: **“I allow `https://app.example.com` to read my responses.”**
    -   Then the browser allows the frontend to **consume JSON**, show data, and function normally.
-   Without CORS, you’d be forced into awkward workarounds just to keep your app usable:
    
    -   Put everything on one domain even when it doesn’t scale well
    -   Proxy everything through the frontend server
    -   Avoid clean separation of frontend and backend


#### Same-Origin Request (Allowed) Scenario

- 🟢 Request is allowed as it is same origin

![](https://img.plantuml.biz/plantuml/png/VPBBQiCm44NtynM3Lp9jxD2bIqDQA6tIXmDEzn7oD5Qm9I4f3oZzzqecfarQkXhGFJDtxg2fyzpwRTU2bxubh7X7ezBAjLJ8UDlgFTKf01TUMtnpPC44NWffkF9uP_N-_2svDGPPuxrnHPxJWNUcfKpeBasGEmpg6RwO_OSlPW3H5qUJmQx0qf32FthWI4Gu61NuSB_4NAgQ3bdZGyYus-ZdfCVbopDUuBm2KDeJwbte7cBD-OvNmahZqMwLG-RYTNH_dRI0rMgrSV1ENZGioRcHUSqzJr90p7n3YbboU3F1KBADqugbtr8ae_OHNX25Law72ArUi_uWKIwIoxwcru7vx5i5Zru3JTPg6rHIDSRbuIJ-OdQCFom6SV19-Aln6CkdFdxv2h-EDw_2weBaBiI8nCyFCGscuTTy0G00)

This diagram shows a **same-origin (allowed)** request flow:

- The user opens `https://example.com` in the browser.
- The browser requests the page: `GET /index.html` from the App at `https://example.com`.
- The App responds with **HTML + JavaScript**.
- That JavaScript runs in the browser and calls:

```js
fetch("/api/data")
  .then(res => res.json())
  .then(data => console.log("API data:", data));
Because "/api/data" is a relative URL, the browser sends it to the same origin:
https://example.com (same scheme + host + port).
```
- The API responds: 200 OK + JSON.

- Since it’s same-origin, the browser allows the JS to read the response, res.json() parses it, and the data is available to the page.

- Key point: Same origin = no CORS restrictions needed, so the JS can read the JSON normally.

### Cross-Origin GET (Preflight Fails — GET never happens) Scenario

- Request fails as site not allowd by through CORS by server
- 🛑 PREFLIGHT CHECK FAILED
<img width="815" height="912" alt="image" src="https://github.com/user-attachments/assets/12ae3640-5041-461e-b993-a0e1de917702" />

#### This diagram shows a **cross-origin** request where the **CORS preflight fails**, so the real **GET is never sent**:

- The user opens `https://app.example.com` in the browser.
- The browser requests the page: `GET /index.html` from the App at `https://app.example.com`.
- The App responds with **HTML + JavaScript**.
- That JavaScript runs in the browser and calls an API on a different origin:

- This is cross-origin because: Page origin = https://app.example.com and API origin = https://api.example.com. Different host ⇒ different origin.

#### OPTIONS /data
- Origin: https://app.example.com
- Access-Control-Request-Method: GET
- Access-Control-Request-Headers: authorization
- The API responds (e.g., 204 No Content) but the CORS response headers are missing or wrong, for example:
- No Access-Control-Allow-Origin, or it doesn’t match https://app.example.com
- Access-Control-Allow-Headers does not include authorization
- Because the preflight check fails, the browser will:
- Block the request
- NOT send the real GET /data at all

#### Result in JavaScript:
- The promise rejects (often shown as TypeError: CORS preflight blocked)
- JS gets no status, no headers, no body, no JSON (because the GET never happened)

Key point: Preflight is a permission check. If the server doesn’t explicitly allow the origin/method/headers, the browser stops the request before it ever sends the actual GET.


#### Different Origin Request (Allowed) Scenario

- Fix server sends allows the site throgh CORS headers
- 🟢 PREFLIGHT CHECK PASSED

![](https://img.plantuml.biz/plantuml/png/dLHDJ-Cm4BtFhnZbr8gcHQizHGZHejLIM9g8bXiNamp4siGszeGY4FyTEssbVaNQvMhFc_VXbrmu5fQRkWAMN15UMkrSd5hvB1N-_hN0fUGICqjFbNmk6K3ah2tUEx9WF5BcqWZ5EB5wkNyMZOt1NibiN38Q2ME6z2PgKz4mrtK_Gk7GJ-n1ikasH1w1P5E0m8_n-OOsmTIGmWugM4y5W2TCMbyZgGfw6vRihGUTyVQsgyNj7pp1wpc0qaoeNprwO_5wZhPHBe4duhpiHHrgHuLW4Gtm0n1hub8N2KQUEHhuWv94GTOb-E4jD_xIodV1Kgl83qr8MCztnlelgVC8F-6p3nFAHUDeVnobGu5AgzZ9mBpUF00k2H_Nlkl6CPhD6mw1L8715-maaqrzZDbYcixcs8f_KAiU95t1FgXndfFlowLMR7KLtz5BGuxZsxLVRxTpvceJWTWs1A40Es_nu_GdpZG6E2a-M3UkAhsC_rVe2hMIwOxhN8rqg3m8hgtKluQslIh1tUS-5i0ffZTj7TFPz_p3mISGIamvoLToxLxiYR28YZx0XUz7-2Dy0G00)


Note: Browsers enforced SOP since the 1990s, so JavaScript (including early XHR ‘API calls’) could only _read_ same-origin responses. CORS later standardized (W3C Recommendation on 16 Jan 2014) the server-controlled way to allow cross-origin reads.
