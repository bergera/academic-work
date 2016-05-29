/**
 * Andrew Berger
 * Independent Study with John Gallagher
 * Wright State University
 * Spring B Term 2016
 */

"use strict";

const utils = require("./utils");

/**
 * @see Sedgewick, Algorithms 4th ed., p316
 */
function sink(arr, k, N) {
  while(2*k <= N) {
    let j = 2*k;
    if (j < N && arr[j-1] < arr[j]) {
      j++;
    }
    if (arr[k-1] >= arr[j-1]) {
      break;
    }
    utils.exchange(arr, k-1, j-1);
    k = j;
  }
}

/**
 * @see Sedgewick, Algorithms 4th ed., p324
 */
function heapSort(arr) {
  let N = arr.length;
  for (let k = Math.floor(N/2); k >= 1; k--) {
    sink(arr, k, N);
  }
  while (N > 1) {
    utils.exchange(arr, 0, (N--)-1 );
    sink(arr, 1, N);
  }
}

module.exports = heapSort;
