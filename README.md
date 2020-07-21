# parse_sudoku

*DCG predicates for parsing line-formatted sudoku puzzles into a 9×9 list of lists.*

## Synopsis

```prolog
:- use_module(library(parse_sudoku)).
:- consult("./sudoku").
solve_puzzle1_from_file :-
	phrase_from_file(sudokus(Puzzles),`./path/to/input`),!,
	Puzzles = [P1|_],
	sudoku(P1),
	maplist(labeling([ff]),P1),
	maplist(writeln,P1),!.

?- solve_all_from_file(`./path/to/input`).

?- solve_n_from_file(`./path/to/input`,[6,12]).
```
## Description

Module [CLP(FD)](https://github.com/triska/clpfd) has an elegant [example](https://github.com/triska/clpfd/blob/master/sudoku.pl) for solving sudoku puzzles. (Variants of it crop up a lot in Prolog tutorials and articles across the web.) It models a sudoku grid as a 9×9 list of lists, with digits for givens and anonymous variables for blanks:

```prolog
P = [[1,_,_,8,_,4,_,_,_],
     [_,2,_,_,_,_,4,5,6],
     [_,_,3,2,_,5,_,_,_],
     [_,_,_,4,_,_,8,_,5],
     [7,8,9,_,5,_,_,_,_],
     [_,_,_,_,_,6,2,_,3],
     [8,_,1,_,_,_,7,_,_],
     [_,_,_,1,2,3,_,8,_],
     [2,_,5,_,_,_,_,_,9]].
```
This is a very sensible model, and there are [other solvers](https://github.com/mmalita/PrologPuzzles/blob/master/sudoku.pro) that use it too.

Meanwhile, text files of sudoku puzzles in machine-readable form (e.g. [here](http://magictour.free.fr/sudoku.htm) or [here](http://norvig.com/hardest.txt)) typically use a line-based format with one puzzle per 81-column line, and '.', '0', or '-' for blanks:

```
1..8.4....2....456..32.5......4..8.5789.5.........62.38.1...7.....123.8.2.5.....9
```

This module contains DCG predicates to read in files with such a format and map them to the 9×9 list-of-lists structure. It also contains convenience predicates for solving all or selected puzzles from such files using the CLP(FD) solver if you have it loaded. (You can easily adapt these to use another solver instead.)

- Apply `sudokus//1` to a file or stream to get a list of puzzles:
`phrase_from_file(sudokus(-Puzzles), +File)`
- Use the convenience predicate `solve_all/1` on such a list to solve them using the CLP(FD) implementation if loaded, or `solve_all_from_file/1` to solve directly from a file:
`solve_all(+List_of_Puzzles)`
`solve_all_from_file(+File)`
- Use the convenience predicate `solve_n/2` on a list of puzzles to solve only those puzzles given in the list of indices `[n,m,…]` using the CLP(FD) implementation if loaded, or `solve_n_from_file/2` to solve directly from a file:
`solve_n(+List_of_Indices)`
`solve_n_from_file(+File, +List_of_Indices)`

That's it. That's the module.
