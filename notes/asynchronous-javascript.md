# Asynchronous JavaScript

A Promise is how JavaScript deals with something that finishes later, like an HTTP request. The whole point is: the browser should not stop and wait (freeze) while the network is working.

Non-blocking (the main idea)
When you start an HTTP request with fetch(), JavaScript does not wait for the response. It starts the request and immediately continues running the next lines of code. The HTTP request is still in progress, but your JavaScript thread is free to keep going.

This is why the page doesn’t freeze: your code is not stuck waiting.

Here is the simplest proof. Notice the order of logs:

```javascript

console.log("1) Before fetch");

fetch("https://api.example.com/data")
  .then(() => console.log("3) Response arrived (then runs)"))
  .catch(() => console.log("3) Request failed (catch runs)"))
  .finally(() => console.log("4) Finished (finally runs)"));

console.log("2) After fetch (request is still in progress)");

```

## What happens

- **“Before fetch”** prints.
- `fetch(...)` starts the HTTP request **and immediately returns a Promise** (the request is still in progress).
- **“After fetch…”** prints right away — this proves JavaScript did **not wait** for the network.
- Later, when the network finishes:
  - if it succeeds, **`.then(...)`** runs
  - if it fails, **`.catch(...)`** runs
- After either success or failure, **`.finally(...)`** runs.

---

## What `.then`, `.catch`, and `.finally` mean

Think of them as **“attach instructions for later.”**

### `.then(...)`
- “Run this later **when the Promise succeeds**.”
- With HTTP, this means: run when a **response comes back**.
- Usually you then **read the body** (for example, JSON).

### `.catch(...)`
- “Run this later **if something goes wrong**.”
- This catches:
  - network errors (no internet, DNS failure, request blocked, etc.)
  - errors you throw yourself
  - JSON parsing errors

### `.finally(...)`
- “Run this later **no matter what**.”
- Use it for cleanup, like **stopping a loading indicator**.

---

## Complete beginner example: display data or display error

This example shows all three clearly.

```javascript
fetch("https://api.example.com/data")
  .then((response) => {
    // The server responded. But it might be 200, 404, 500, etc.
    // HTTP 404/500 still counts as "a response arrived", so we check:
    if (!response.ok) {
      // Turn HTTP error status into a real error so it goes to catch
      throw new Error("HTTP error: " + response.status);
    }

    // Read and parse the response body as JSON (this is async too)
    return response.json();
  })
  .then((data) => {
    // This runs only when JSON is fully ready
    document.body.textContent = "Data: " + JSON.stringify(data, null, 2);
  })
  .catch((error) => {
    // This runs if:
    // - network failed
    // - HTTP status was not ok and we threw an error
    // - JSON parsing failed
    document.body.textContent = "Error: " + error.message;
  })
  .finally(() => {
    // Always runs after success or error
    console.log("Request finished (success or error)");
  });
```


## The mental model (super beginner-friendly)

- `fetch()` **starts the HTTP request** and immediately gives you a **Promise** (it is *pending*).
- JavaScript **continues immediately** — it does **not wait** (this is non-blocking).

### Later, when the network finishes:

- **Success path** → `.then(...)` runs with the result  
- **Error path** → `.catch(...)` runs with the error  
- **End** → `.finally(...)` runs **always**

---

### The complete idea

Promises let you:

- start an HTTP request **now**
- keep the program running (**non-blocking**)
- run your **success code** or **error code** **later**, when the network finishes

