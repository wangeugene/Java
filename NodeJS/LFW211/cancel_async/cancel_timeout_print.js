import { setTimeout } from "timers/promises";

const ac = new AbortController();
const { signal } = ac;
const timeout = setTimeout(1000, "will NOT be logged", { signal });

setImmediate(() => {
    ac.abort();
});

try {
    console.log(await timeout);
} catch (err) {
    // ignore abort errors:
    if (err.code !== "ABORT_ERR") throw err;
}
// Nothing will be logged

// This now behaves as the typical timeout example, nothing is logged out because the timer is canceled before it can complete. The AbortController constructor is a global, so we instantiate it and assign it to the ac constant. An AbortController instance has an AbortSignal instance on its signal property. We pass this via the options argument to timers/promises setTimeout, internally the API will listen for an abort event on the signal instance and then cancel the operation if it is triggered. We trigger the abort event on the signal instance by calling the abort method on the AbortController instance, this causes the asynchronous operation to be canceled and the promise is fulfilled by rejecting with an AbortError. An AbortError has a code property with the value 'ABORT_ERR', so we wrap the await timeout in a try/catch and rethrow any errors that are not AbortError objects, effectively ignoring the AbortError.

// Many parts of the Node core API accept a signal option, including fs, net, http, events, child_process, readline and stream. In the next chapter, there's an additional AbortController example where it's used to cancel promisified events.
