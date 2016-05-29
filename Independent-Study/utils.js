/**
 * Andrew Berger
 * Independent Study with John Gallagher
 * Wright State University
 * Spring B Term 2016
 */

"use strict";

/**
 * Returns true if obj has a function named compareTo .
 * @param {Object} obj
 * @returns {Boolean}
 */
function assertComparable(obj) {
  return "function" === typeof obj.compareTo;
}

/**
 * Swaps arr[i] and arr[j] in-place.
 * @param {Array} arr
 * @param {Number} i
 * @param {Number} j
 */
function exchange(arr, i, j) {
  let temp = arr[i];
  arr[i] = arr[j];
  arr[j] = temp;
}

/**
 * @param {Array} array
 * @see http://stackoverflow.com/questions/2450954/how-to-randomize-shuffle-a-javascript-array
 * @returns {Array}
 */
function shuffle(array) {
  let currentIndex = array.length,
    temporaryValue,
    randomIndex;

  // While there remain elements to shuffle...
  while (0 !== currentIndex) {

    // Pick a remaining element...
    randomIndex = Math.floor(Math.random() * currentIndex);
    currentIndex -= 1;

    // And swap it with the current element.
    temporaryValue = array[currentIndex];
    array[currentIndex] = array[randomIndex];
    array[randomIndex] = temporaryValue;
  }

  return array;
}

/**
 * @param {Array} arr
 * @returns {Boolean} false if any element is greater than the following element, true otherwise.
 */
function isSorted(arr) {
  if (arr.length < 2) {
    return true;
  }

  let i = 0;
  while (i <= arr.length) {
    if (arr[i] > arr[++i]) {
      return false;
    }
  }

  return true;
}

/**
 * Generates an array of random integers in [Number.MIN_SAFE_INTEGER, Number.MAX_SAFE_INTEGER]
 * @param {Number} length
 * @returns {Array}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random
 */
function randomArray(length) {
  let arr = [];
  let scalar = Number.MAX_SAFE_INTEGER - Number.MIN_SAFE_INTEGER + 1;

  for (let i=0; i<length; i++) {
    arr.push(Math.floor(Math.random() * scalar) + Number.MIN_SAFE_INTEGER);
  }

  return arr
}

/**
 * @param {Function} fn
 * @returns {Number} The running time of fn in milliseconds.
 */
function time(fn) {
  let start = Date.now();
  fn();
  return Date.now() - start
}

/**
 * @param {Function} fn
 * @param {Number} N
 * @returns {Number} running time in ms of fn to sort a random array of N numbers, -1 otherwise
 */
function test(fn, N) {
  let arr = randomArray(N);
  let t = time(fn.bind(null, arr));
  return (isSorted(arr)) ? t : -1;
}

/**
 * @param {Function} fn An array-sorting function which takes an array of Numbers as an argument.
 * @param {Number} N The size of the array tested (generated with randomArray(N)).
 * @param {Number} iterations The number of iterations to run, with a new random array each time.
 * @returns {Number} The average running time of fn in milliseconds.
 */
function timedIterations(fn, N, iterations) {
  N = N || 10000;
  iterations = iterations || 10;
  let times = [];

  console.log(`Using ${fn.name}, N=${N}, iterations=${iterations}...`);
  for (let i=1; i<=iterations; i++) {
    let t = test(fn, N);
    let sorted = t > -1 ? "success" : "fail";
    times.push(t);
    console.log(`Iteration ${i}: ${t}ms (${sorted})`);
  }

  let average = times.reduce((prev, curr) => prev + curr) / iterations;
  console.log(`Average: ${average}ms`);

  return average;
}

module.exports = {
  assertComparable,
  exchange,
  shuffle,
  isSorted,
  randomArray,
  time,
  test,
  timedIterations
}
