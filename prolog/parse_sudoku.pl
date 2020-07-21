:- module(parse_sudoku, [
	sudokus//1,
	parse_sudokus/2,
	solve_all/1,
	solve_all_from_file/1,
	solve_n/2,
	solve_n_from_file/2
]).
:- encoding(utf8).
:- use_module(library(clpfd)).
:- use_module(library(dcg/basics)).
:- use_module(library(lists)).
:- use_module(library(pio)).

% DCG predicates for parsing line-formatted sudoku puzzles into a 9×9 list of lists.
sudokus([])     --> call(eos),!.
sudokus(Ls)     --> sudoku([]), sudokus(Ls) .
sudokus([L|Ls]) --> sudoku(L),  sudokus(Ls) .

% A line is either blank, a comment beginning with '#', or a sudoku puzzle.
sudoku([]) --> `\n`,!.
sudoku([]) --> comment, `\n`,!.
sudoku(L)  --> puzzle(L), `\n`.

comment --> `#`.
comment --> `#`, string(_) .

% An 81-character sudoku puzzle (nine rows of nine cells), on a single line.
puzzle([R1,R2,R3,R4,R5,R6,R7,R8,R9]) --> row(R1), row(R2), row(R3), row(R4), row(R5), row(R6), row(R7), row(R8), row(R9) .

row([C1,C2,C3,C4,C5,C6,C7,C8,C9]) --> cell(C1), cell(C2), cell(C3), cell(C4), cell(C5), cell(C6), cell(C7), cell(C8), cell(C9) .

% Given digits are in the range 1–9; blanks are either '.', '_', '-', '0', or ' '.
cell(_) --> `.` .
cell(_) --> `_` .
cell(_) --> `-` .
cell(_) --> `0` .
cell(_) --> ` ` .
cell(C) -->
	digit(D),
	{ number_codes(C,[D]),
	  C #\= 0 } .

% Load files as a list of puzzles
parse_sudokus(Path,Puzzles) :- phrase_from_file(sudokus(Puzzles),Path),!.

/******************************************************************************/

% Convenience predicates for solving puzzles using Markus Triska's solver sudoku/1 from CLP(FD) <https://github.com/triska/clpfd/blob/master/sudoku.pl>

% Solve all puzzles in a list of puzzles
solve_all([]).
solve_all([P|Ps]) :-
	sudoku(P),
	append(P,Vs),
	labeling([ff],Vs), % append/2 + labelling/2 is faster than maplist(labeling([ff]),P)
	maplist(writeln,P),!, nl,
	solve_all(Ps) .

% Solve all puzzles from a file
solve_all_from_file(Path) :-
	parse_sudokus(Path,Ps),
	solve_all(Ps) .

% Solve selected puzzles from a list of puzzles, given by 1-indexed [n,m,…]
solve_n(_,[]).
solve_n(Ps,[N|Ns]) :-
	nth1(N,Ps,P),
	sudoku(P),
	append(P,Vs),
	labeling([ff],Vs), % append/2 + labelling/2 is faster than maplist(labeling([ff]),P)
	maplist(writeln,P),!, nl,
	solve_n(Ps,Ns) .

% Solve selected puzzles from a file, given by 1-indexed [n,m,…]
solve_n_from_file(Path,Ns) :-
	parse_sudokus(Path,Ps),
	solve_n(Ps,Ns) .

% PostScript animations solving all puzzles in a list of puzzles
show_all([]).
show_all([P|Ps]) :-
	show([ff],P),
	show_all(Ps) .

% PostScript animations solving all puzzles from a file
show_all_from_file(Path) :-
	parse_sudokus(Path,Ps),
	show_all(Ps) .

% PostScript animations solving selected puzzles from a list of puzzles, given by 1-indexed [n,m,…]
show_n(_,[]).
show_n(Ps,[N|Ns]) :-
	nth1(N,Ps,P),
	show([ff],P),
	show_n(Ps,Ns) .

% PostScript animations solving selected puzzles from a file, given by 1-indexed [n,m,…]
show_n_from_file(Path,Ns) :-
	parse_sudokus(Path,Ps),
	show_n(Ps,Ns) .
