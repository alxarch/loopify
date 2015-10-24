# loopify
Loop over a function


## Usage

```js
loopify = require("loopify");
var n = 0;
var action = function () {
	n++;
	console.log("Iteration " + n);
	if (n > 4) {
		// Throw null to stop looping without rejecting
		throw null;
	}
}
// Prints
// > Iteration 1
// > Iteration 2
// > Iteration 3
// > Iteration 4
// > Done!
loopify(action).then(function () {
	console.log("Done!");
});

// Add a sleep period of 50ms between callbacks
loopify(50, action).then(function () {
	console.log("Done!");
});

action = function () {
	n++;
	console.log("Iteration " + n);
	if (n > 4) {
		// Throw en error to reject the loopify promise.
		throw new Error("One loop too many.");
	}
}

// Prints
// > Iteration 1
// > Iteration 2
// > Iteration 3
// > Iteration 4
// > One loop too many.
loopify(action).catch(function (err) {
	console.error(err.message);
});



```
