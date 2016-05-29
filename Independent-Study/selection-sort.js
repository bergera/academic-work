/**
 * Andrew Berger
 * Independent Study with John Gallagher
 * Wright State University
 * Spring B Term 2016
 */

"use strict";

const utils = require("./utils");

/**
 * Sorts an array of Numbers using a selection sort algorithm.
 * @param {Number[]} arr The array to sort.
 * @see Sedgewick, Algorithms 4th ed., p249
 */
function selectionSort(arr) {
  let n = arr.length;

  for (let i = 0; i < n; i++) {
    let min = i;

    for (let j = i+1; j < n; j++) {
      // exhange a[i] with the smallest entry in a[i+1..n)
      if (arr[j] < arr[min]) {
        min = j;
      }
    }
    utils.exchange(arr, i, min);
  }
}

module.exports = selectionSort;
