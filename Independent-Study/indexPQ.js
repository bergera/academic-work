/**
 * Andrew Berger
 * Independent Study with John Gallagher
 * Wright State University
 * Spring B Term 2016
 */

"use strict";

module.exports = IndexMinPQ;

/**
 * @see Sedgewick, Algorithms 4th ed., p333
 */
function IndexMinPQ() {
  this.N = 0;
  this.keys = [null];
  this.pq = [null];
  this.qp = [-1];
}

/**
 * @see http://algs4.cs.princeton.edu/24pq/IndexMinPQ.java.html
 * @param {Number} i
 * @param {Number} j
 */
IndexMinPQ.prototype.exchange = function(i, j) {
  let temp = this.pq[i];
  this.pq[i] = this.pq[j];
  this.pq[j] = temp;
  this.qp[this.pq[i]] = i;
  this.qp[this.pq[j]] = j;
}

/**
 * @see http://algs4.cs.princeton.edu/24pq/IndexMinPQ.java.html
 * @param {Number} i
 * @param {Number} j
 */
IndexMinPQ.prototype.greater = function (i, j) {
  return this.keys[this.pq[i]] > this.keys[this.pq[j]];
}

/**
 * @param {Number} k
 * @see http://algs4.cs.princeton.edu/24pq/IndexMinPQ.java.html
 */
IndexMinPQ.prototype.sink = function(k) {
  while(2*k <= this.N) {
    let j = 2*k;
    if (j < this.N && this.greater(j, j+1)) {
      j++;
    }
    if (!this.greater(k, j)) {
      break;
    }
    this.exchange(k, j);
    k = j;
  }

  return this;
}

/**
 * @param {Number} k
 * @see http://algs4.cs.princeton.edu/24pq/IndexMinPQ.java.html
 */
IndexMinPQ.prototype.swim = function(k) {
  while (k > 1 && this.greater(Math.floor(k/2), k)) {
    this.exchange(Math.floor(k/2), k);
    k = Math.floor(k/2);
  }

  return this;
}

/**
 * @param {Number} i
 * @param {Number} key
 * @see Sedgewick, Algorithms 4th ed., p333
 */
IndexMinPQ.prototype.insert = function(i, key) {
  this.N++;
  this.qp[i] = this.N;
  this.pq[this.N] = i;
  this.keys[i] = key;
  this.swim(this.N);

  return this;
}

/**
 * @param {Number} i
 * @param {Number} key
 * @see Sedgewick, Algorithms 4th ed., p334
 */
IndexMinPQ.prototype.changeKey = function(i, key) {
  this.keys[i] = key;
  this.swim(this.qp[i]);
  this.sink(this.qp[i]);

  return this;
}

/**
 * @param {Number} i
 * @see Sedgewick, Algorithms 4th ed., p333
 */
IndexMinPQ.prototype.contains = function(i) {
  return this.qp[i] !== -1;
}

/**
 * @param {Number} i
 * @see Sedgewick, Algorithms 4th ed., p334
 */
IndexMinPQ.prototype.delete = function(i) {
  let index = this.qp[i];
  this.exchange(index, N--);
  this.swim(index);
  this.sink(index);
  this.keys[i] = null;
  this.qp[i] = -1;

  return this;
}

/**
 * @see Sedgewick, Algorithms 4th ed., p333
 */
IndexMinPQ.prototype.minKey = function() {
  return this.keys[this.pq[1]];
}

/**
 * @see Sedgewick, Algorithms 4th ed., p334
 */
IndexMinPQ.prototype.minIndex = function() {
  return this.pq[1];
}

/**
 * @see Sedgewick, Algorithms 4th ed., p333
 */
IndexMinPQ.prototype.delMin = function() {
  let indexOfMin = this.pq[1];
  this.exchange(1, this.N--);
  this.sink(1);
  this.keys[this.pq[this.N+1]] = null;
  this.qp[this.pq[this.N+1]] = -1;

  return indexOfMin;
}

/**
 * @see Sedgewick, Algorithms 4th ed., p333
 */
IndexMinPQ.prototype.isEmpty = function() {
  return this.N === 0;
}

/**
 * @see Sedgewick, Algorithms 4th ed., p333
 */
IndexMinPQ.prototype.size = function() {
  return this.N;
}

/**
 * @see Sedgewick, Algorithms 4th ed.
 * @param {Number} i
 */
IndexMinPQ.prototype.keyOf = function(i) {
  return this.keys[i];
}
