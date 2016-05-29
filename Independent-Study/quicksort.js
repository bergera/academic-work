/**
 * Andrew Berger
 * Independent Study with John Gallagher
 * Wright State University
 * Spring B Term 2016
 */

"use strict";

const utils = require("./utils");

/**
 * Partition arr for performing a quicksort.
 * @param {Number[]} arr The array to partition.
 * @param {int} lo
 * @param {int} hi
 * @see Sedgewick, Algorithms 4th ed., p291
 */
function partition(arr, lo, hi) {
  let i = lo,
      j = hi+1,
      v = arr[lo];

  while (true) {
    while (arr[++i] < v) {
      if (i === hi) {
        break;
      }
    }
    while (v < arr[--j]) {
      if (j === lo) {
        break;
      }
    }
    if (i >= j) {
      break;
    }
    utils.exchange(arr, i, j);
  }

  utils.exchange(arr, lo, j);

  return j;
}

/**
 * Sorts an array using a quicksort algorithm.
 * @param {Number[]} arr The array to sort.
 * @see Sedgewick, Algorithms 4th ed., p289
 */
function quickSort(arr) {
  arr = utils.shuffle(arr);
  _sort(arr, 0, arr.length-1);

  function _sort(arr, lo, hi) {
    if (hi <= lo) {
      return;
    }
    let j = partition(arr, lo, hi);
    _sort(arr, lo, j-1);
    _sort(arr, j+1, hi);
  }
}


/**
 * Sorts an array using a three-way quicksort algorithm.
 * @param {Number[]} arr The array to sort.
 * @see Sedgewick, Algorithms 4th ed., p299
 */
function threeWayQuickSort(arr) {
  arr = utils.shuffle(arr);
  _sort(arr, 0, arr.length-1);

  function _sort(arr, lo, hi) {
    if (hi <= lo) {
      return;
    }

    let lt = lo,
        i = lo+1,
        gt = hi,
        v = arr[lo];

    while (i <= gt) {
      if (arr[i] < v) {
        utils.exchange(arr, lt++, i++);
      } else if (arr[i] > v) {
        utils.exchange(arr, i, gt--);
      } else {
        i++;
      }
    }
    _sort(arr, lo, lt-1);
    _sort(arr, gt+1, hi);
  }
}

module.exports = {
  quickSort,
  threeWayQuickSort
}
