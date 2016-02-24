# Assignment

Write a Racket program to read the file, http://www.cs.duke.edu/~ola/ap/linuxwords. You may download the file to your local computer prior to running your Racket program. Your program doesn't need to read the file over the network.

[3 points] You Racket program must output all six letter words that do not contain the letters, `a, e, i, o`. In other words, the only vowels are `u` or `y`. The case of the letter should not matter. `U` is interchangeable with `u`. The words must all be on the same line delimited by commas with no quotation marks.

Sample correct output:

```
Part 1: List of six letter words in linuxwords that don't contain a e i o.

bluffs, blunts, blurry, blurts, brunch, brushy, bubbly, bumbry, bursts, bursty, chubby, chucks, chunks, chunky, church, churns, clucks, clumps, clumsy, clutch, cruddy, crumbs, crummy, crunch, crusts, crutch, cuddly, cupful, curtly, curtsy, cygnus, cyprus, drunks, duluth, dumbly, dumpty, fluffy, flurry, fungus, grubby, grunts, grusky, humbly, humbug, humpty, hungry, justly, lumpur, luxury, mchugh, murmur, murphy, numbly, nymphs, phylum, plucks, plucky, plumbs, rhythm, rumply, rumpus, schulz, sculpt, scurry, scurvy, shrubs, shrugs, shrunk, skulks, skulls, skunks, slumps, slurry, smutty, snuffs, snugly, sprung, spurns, spurts, struck, strung, struts, stubby, stuffs, stuffy, stumps, stunts, sturdy, stylus, subtly, suburb, sulfur, sultry, sundry, supply, syrupy, thrush, thrust, thumbs, thusly, trucks, trumps, trunks, trusts, trusty, truths, tumult, tyburn, unduly, unjust, unplug, unruly, upturn
```
 
[2 points] Your Racket program must output a count of total number of letter `u` found in the entire file regardless of word length. The case of the letter should not matter. `U` is interchangeable with `u`.

Sample correct output:

```
Part 2: number of letter u in linuxwords

11713
```
