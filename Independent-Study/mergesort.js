/**
 * Andrew Berger
 * Independent Study with John Gallagher
 * Wright State University
 * Spring B Term 2016
 */

"use strict";

const utils = require("./utils");

// To improve memory utilization regarding `aux`, an immediately-invoked closure is used.
const mergeSort = (function () {
  let aux;

  /**
   * Merges arr[lo..mid] with arr[mid+1..hi]
   * @param {Number[]} arr The array to sort.
   * @param {int} lo
   * @param {int} mid 
   * @param {int} hi
   * @see Sedgewick, Algorithms 4th ed., p271
   */
  function merge(arr, lo, mid, hi) {
    let i = lo,
        j = mid+1;

    for (let k = lo; k <= hi; k++) {
      aux[k] = arr[k];
    }

    for (let k = lo; k <= hi; k++) {
      if (i > mid) {
        arr[k] = aux[j++];
      } else if (j > hi) {
        arr[k] = aux[i++];
      } else if (aux[j] < aux[i]) {
        arr[k] = aux[j++];
      } else {
        arr[k] = aux[i++];
      }
    }
  }

  /**
   * Sorts an array of Numbers using a top-down merge sort algorithm.
   * @param {Number[]} arr The array to sort.
   * @see Sedgewick, Algorithms 4th ed., p273
   */
  function topDownMergeSort(arr) {
    aux = new Array(arr.length);
    _sort(arr, 0, arr.length-1);
    aux = null;

    function _sort(arr, lo, hi) {
      if (hi <= lo) { return; }

      let mid = lo + Math.floor((hi - lo) / 2);

      _sort(arr, lo, mid);
      _sort(arr, mid+1, hi);

      merge(arr, lo, mid, hi);
    }
  }

  /**
   * Sorts an array of Numbers using a bottom-up merge sort algorithm.
   * @param {Number[]} arr The array to sort.
   * @see Sedgewick, Algorithms 4th ed., p278
   */
  function bottomUpMergeSort(arr) {
    let n = arr.length;
    aux = new Array(arr.length);

    for (let sz = 1; sz < n; sz = sz+sz) {
      for (let lo = 0; lo < n - sz; lo += sz+sz) {
        merge(arr, lo, lo+sz-1, Math.min(lo+sz+sz-1, n-1));
      }
    }

    aux = null;
  }

  return {
    topDownMergeSort,
    bottomUpMergeSort
  }

})();

module.exports = mergeSort;
