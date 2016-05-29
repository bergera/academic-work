# Independent Study - JavaScript
## Purpose
This report is the final product of an independent study in current and proposed JavaScript language features and techniques. It covers the current ECMAScript 5 (ES5) standard and the proposed ECMAScript 6 (ES6) standard. Node.js version 6 now implements 93% of ES6 language features.

The sorting algorithms implemented here are used as a demonstration of current and progressing JavaScript language features and techniques. They are largely taken from Algorithms 4th ed. by Sedgewick and Wayne (Addison-Wesley), modified as needed to function properly in JavaScript. They are written assuming a Node.js runtime environment.

JavaScript reference texts used were David Flanagan's JavaScript: The Definitive Guide (O'Reilly), the Mozilla Developer Network website (https://developer.mozilla.org), and other online resources.

## Running Demonstration Code
The sorting algorithms included were tested using (Node v6.0.0)[https://nodejs.org/]. They can be run:

```
$ node main.js
```

The size of the randomly generated arrays sorted and the number of iterations are hard-coded and can be modified at

```JavaScript
// ...

let N = 10000;
let iterations = 10;

// ...
```

# JavaScript ES5 and Its Challenges
## Closures
JavaScript's functional paradigm provides the use of the wonderful structure of closures. Most of the time closures are a pleasure, with functions bringing with them a snapshot of the universe at the time the are declared. Variables and objects captured by a closure outlast the scopes in which they were originally declared.

```JavaScript
let a = 0;
function foo() {
  let b = 1;

  return function bar() {
    a += b;
    return a;
  }
}

bar = foo();
foo = null;
bar(); // => 1
bar(); // => 2
bar(); // => 3
```

### For Loop "Gotcha"
One of the most common "gotchas" with closures is with attaching callbacks to HTML DOM (Document Object Model) nodes inside loops.

Given the following HTML:

```HTML
<div id="foo">
  <div>0</div>
  <div>1</div>
  <div>2</div>
</div>
```

One would expect the following JavaScript to cause each child div inside `<div id="foo">` alert its index when clicked:

```JavaScript
foo = document.getElementById("foo");
for (var i=0; i < foo.children.length; i++) {
  foo.children[i].addEventListener("click", function() {
    alert(i);
  });
}
```

What actually happens is that all three alert "2" instead of their actual index, because the `alert(i)` in the function passed as the handler for the "click" event references the same `i` variable in each iteration of the loop.

### Memory Leaks
An interesting and hard-to-detect memory leak is possible under some conditions when using closures. Described [here](http://info.meteor.com/blog/an-interesting-kind-of-javascript-memory-leak), leaky code takes the form:

```JavaScript
var theThing = null;
var replaceThing = function () {
  var originalThing = theThing;
  var unused = function () {
    if (originalThing)
      console.log("hi");
  };
  theThing = {
    longStr: new Array(1000000).join('*'),
    someMethod: function () {
      console.log(someMessage);
    }
  };
};
setInterval(replaceThing, 1000);
```

Where `theThing.longStr` gets leaked each time `replaceThing` is invoked because `unused` captures a reference to it via `originalThing`. Even though `unused` is (unsurprisingly) never used, it is in turn captured by the function `someMethod` on the new object which replaces `theThing`.

>Chrome's V8 JavaScript engine is apparently smart enough to keep variables out of the lexical environment if they aren't used by _any_ closures...
>But as soon as a variable is used by _any_ closure, it ends up in the lexical environment shared by _all_ closures in that scope.

### Variable Hoisting
See the section "Issues With var - Hoisting" for a description of another subtle and difficult-to-detect issue with closures when combined with the "hoisting" behavior of the `var` keyword.

## The Event Loop
JavaScript is single-threaded and executes in asynchronously. In the browser and in Node.js, much is accomplished by way of callbacks and deferred execution. This can be easily seen when looking at how `setTimeout()` and `process.nextTick()` work.

In client-side (browser) JavaScript, `setTimeout` is usually called with the first argument being a callback function and the second being a delay in milliseconds. One would expect the following code to create a popup alert after 1000 ms:

```JavaScript
if (true) {
  setTimeout(function() {
    alert("time!");
  }, 1000);

  for (let i=0; i<1000000; i++){
    // busy wait
  }
}
```

In reality, the above code won't create the alert for quite a long time. This is because the 1000ms delay passed to `setTimeout()` is not a hard guarantee, but a minimum delay. While user code executes in a single thread, system APIs including an event queue are handled outside this single thread of execution. `setTimeout` executes the function passed to after a time at least as long as the delay given has passed AND the usercode stack is empty AND all events queued before the `setTimeout` callback have been handled. Therefore, invoking `setTimeout(callback, 0)` doesn't mean "invoke callback() after 0ms", but rather "invoke callback() as soon as the stack is empty AND all other queued events have been processed".

Practically speaking, this is an issue when trying to achieve low-latency response times in user-interaction handlers such as for click and scroll events. It can be difficult to know exactly when and in what order such events are processed. Writing event-loop-unaware handlers which block execution can cause web pages to seem sluggish and unresponsive.

In server-side (Node) JavaScript, the single-threaded event loop problem takes on a different shape. Commonly a single process thread will both receive and handle HTTP requests. Incoming HTTP requests will be queued in Node's event queue but cannot be processed until the thread is free. Things are often fast enough this isn't an issue, but things like deep recursion or I/O can block the thread for some time. Rather than recursing directly by calling the recursive function from within itself, the function can be passed as a callback to `process.nextTick(callback)` to achieve behavior similar to (but more efficient than) `setTimeout(callback, 0)`. This allows, for example, waiting HTTP requests to be dealt with in reasonable time.

```JavaScript
function fibonacci(n) {
  if(n <= 2) {
      return 1;
  } else {
      return process.nextTick(fibonacci, n - 1) + process.nextTick(fibonacci, n - 2);
  }
}
```

## Strict Mode
As of ES5, JavaScript can be interepreted in either a "non-strict" (default) or "strict" mode. All the demonstration files included with this report invoke strict mode for a few important reasons discussed below.

It is invoked by placing the following at the top of a file or function block:

```JavaScript
"use strict";

// ...
```

```JavaScript
function () {
  'use strict';
  // ...
}
```

The strict mode is used here because it offers several improvements to the stability and sanity of JavaScript (which is rather insane at times). Among those improvements, the following are perhaps two most useful:

### Protection against accidental global variable definitions
JavaScript's `var` keyword, which is deprecated in ES6 in favor of `let` and `const`, is used to declare variables. However, in non-strict mode omitting `var` before writing to a variable results in that variable being declared in the global scope. Strict mode raises an error if `var` is omitted.

```JavaScript
/* NON-STRICT MODE*/

function foo() {
  bar = "baz"; // for var, becomes global
}

foo();

bar; // => "baz"
window.bar; // => "baz"

```
```JavaScript
/* STRICT MODE */

'use strict';

function foo() {
  bar = "baz";
}

foo(); // => throws ReferenceError
```

### Function invocation and the "this" variable
All functions in JavaScript have access to a special variable called `this` which references the "current context" of the function when called. In non-strict mode, if this value would not otherwise be set, or is set to `null` or `undefined`, it is set to the global context. In strict mode, it is `undefined` unless otherwise set with `bind()`, `call()` or `apply()`.

This provides enhanced security because functions no longer have access through `this` to important global data structures like `window` in client-side JavaScript or `process` in Node.js.

```JavaScript
/* NON-STRICT MODE */

function foo(val) {
  this.bar = val; // defines a global variable
}

foo();
bar; // => "baz"

foo.call(null, "qux");
bar; // => "qux"

foo.apply(undefined, ["foo"]);
bar; // => "foo"

otherFoo = foo.bind(null);
otherFoo("abc");
bar; // => "abc"
```

```JavaScript
/* STRICT MODE */

function foo(val) {
  "use strict";
  this.bar = val;
}

foo(); // throws TypeError

foo.call(null, "qux"); // throws TypeError

foo.apply(undefined, ["foo"]); // throws TypeError

otherFoo = foo.bind(null);
otherFoo("abc"); // throws TypeError
```

## Issues with `var`
The `var` variable declaration keyword has a few important shortcomings.

One problem, accidental globals, is described (and remedied) above under Strict Mode. While strict mode solves this problem, it is not always practical to use strict mode, especially if dealing with legacy code.

### Mutability
Of importance to the functional programmaing paradigm is the concept of immutability. JavaScript objects and object properties are mutable by default, and variables declared with `var` are mutable in that they can be changed from referencing one object to referencing another separate object. This is a no-no when it comes to writing "pure" functions which avoid side effects.

```JavaScript
function replace(array) {
  array = ["not the original"];
}

var foo = [0, 1, 2];

replace(foo); // foo now points to a different array
foo; // => ["not the original"]
```

### Lexical Scoping
`var` provides lexical scoping rather than block scoping, and can also be used to declare the same variable more than once. These two behaviors lead to behavior which is not readily apparent:

```JavaScript
// declaring more than once, what's the behavior?
var a = "foo";
var a = "bar";
a; // => "bar"

if (true) {
  var a = "true!"; // same variable as above
  doSomething(a);
}
```

### Hoisting
Another issue is that of "hoisting", where a variable is effectively declared at the top of its scope regardless of where it appears in the source code.

```JavaScript
a = 5;
var a;

// becomes:

var a;
a = 5;
```

This is especially a problem when combined with closures, because even strict mode declared globally or on the outer function does not alleviate the issue:

```JavaScript
function foo() {
  function bar() {
    i = 0; // uses the same i as the for loop!
  }

  // i looks like it's declared here, but it really gets "hoisted" to the top of foo()
  for (var i = 0; i < 5; i++) {
    bar(); // causes infinite loop!
    console.log(i);
  }
}

foo(); // prints 0 infinitely
```

## Issues with Numbers
All numbers in JavaScript are represented as double-precision floating point numbers. This carries all the typical problems associated with floating point arithmetic.

# ES6 Improvements over ES5

## `let` and `const`
ES6 deprecates `var` in favor of two new variable declaration keywords, `let` and `const`.

### `let`
The `let` keyword can be thought of as the "block scope" keyword, because it provides true block-scoped variables (as opposed to lexically scoped with `var`). This solves the hoisting problem and the multiple-declaration problem, providing more readable/logical code.

```JavaScript
// hoisting
function foo() {
  baz = 5; // non-strict mode, with var this would fly
  let baz = 0;

  if (true) {
    let baz = 10;
  }

  return baz;
}

foo(); // throws ReferenceError

// block scoping
let baz = 0;

if (true) {
  let baz = 10;
}

baz; // => 0

// multiple declaration
let boo = "sdkfjs";
let boo = "somethingelse"; // => throws TypeError
```

This also solves the for-loop problem from before.

```JavaScript
function foo() {
  function bar() {
    i = 0;
  }

  // use let keyword
  for (let i = 0; i < 5; i++) {
    bar();
    console.log(i);
  }
}

foo(); // throws ReferenceError
```

### `const`
`const` can be thought of as the "constant reference" keyword, which creates a read-only reference variable. If the content of the variable is an object, its properties can be changed but the object itself cannot be overwritten.

```JavaScript
const foo = 5;
foo = 10; // doesn't change foo
foo; // => 5

const bar = {a: 0};
bar = {b: "sdfkjgs"}; // can't change bar
bar.a = 100; // can change bar.a
bar; // => {a: 100}
```

```JavaScript
function replace(array) {
  array = ["not the original array"];
}

const foo = [0, 1, 2];

replace(foo); // doesn't change foo

foo; // => [0, 1, 2]
```
