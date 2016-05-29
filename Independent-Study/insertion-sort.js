/**
 * Andrew Berger
 * Independent Study with John Gallagher
 * Wright State University
 * Spring B Term 2016
 */

"use strict";

const utils = require("./utils");

/**
 * Sorts an array of Numbers using an insertion sort algorithm.
 * @param {Number[]} arr The array to sort.
 * @see Sedgewick, Algorithms 4th ed., p251
 */
function insertionSort(arr) {
  let n = arr.length;

  for (let i = 1; i < n; i++) {
    for (let j = i; j > 0 && (arr[j] < arr[j-1]); j--) {
      utils.exchange(arr, j, j-1);
    }
  }
}

module.exports = insertionSort;
