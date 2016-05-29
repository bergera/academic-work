/**
 * Andrew Berger
 * Independent Study with John Gallagher
 * Wright State University
 * Spring B Term 2016
 */

"use strict";

let N = 10000;
let iterations = 10;

const utils = require("./utils");
const IndexMinPQ = require("./indexPQ");

const algorithms = [
  require("./heapsort"),
  require("./insertion-sort"),
  require("./mergesort").topDownMergeSort,
  require("./mergesort").bottomUpMergeSort,
  require("./selection-sort"),
  require("./shellsort"),
  require("./quicksort").quickSort,
  require("./quicksort").threeWayQuickSort
];

const times = [];

const pq = new IndexMinPQ();

for (let i=0; i < algorithms.length; i++) {
  let t = utils.timedIterations(algorithms[i], N, iterations);
  times.push(t);
  pq.insert(i, t);
  console.log("");
}

console.log("###################################");
console.log("\nAlgorithms sorted by average running time (using indexed priority queue):\n");

while (!pq.isEmpty()) {
  let i = pq.delMin();
  console.log(`  ${algorithms[i].name}: ${times[i]}ms`);
}
console.log("");
