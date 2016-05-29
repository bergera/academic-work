/**
 * Andrew Berger
 * Independent Study with John Gallagher
 * Wright State University
 * Spring B Term 2016
 */

"use strict";

const utils = require("./utils");

/**
 * Sorts an array of Numbers using Shell sort algorithm.
 * @param {Number[]} arr The array to sort.
 * @see Sedgewick, Algorithms 4th ed., p249
 */
function shellSort(arr) {
  let n = arr.length;
  let h = 1;

  // all Numbers in JavaScript are double-precision floating point values,
  // so must be rounded down to clear the fractional part
  while (h < Math.floor(n / 3)) {
    h = 3 * h + 1;
  }

  while (h >= 1) {
    for (let i = h; i < n; i++) {
      for (let j = i; j >= h && arr[j] < arr[j-h]; j -= h) {
        utils.exchange(arr, j, j-h);
      }
    }
    h = Math.floor(h / 3);
  }
}

module.exports = shellSort;
