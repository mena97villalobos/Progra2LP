
pivot(_, [], [], []).
pivot(Pivot, [Head|Tail], [Head|LessOrEqualThan], GreaterThan) :- Pivot >= Head, pivot(Pivot, Tail, LessOrEqualThan, GreaterThan). 
pivot(Pivot, [Head|Tail], LessOrEqualThan, [Head|GreaterThan]) :- pivot(Pivot, Tail, LessOrEqualThan, GreaterThan).

quicksort([], []).
quicksort([Head|Tail], Sorted) :- pivot(Head, Tail, List1, List2), quicksort(List1, SortedList1), quicksort(List2, SortedList2), append(SortedList1, [Head|SortedList2], Sorted).

/*********************/

/*Tamaño de una lista*/
size([H|T], Result):-
	sizeAux(T, 1, Result).

sizeAux([], Acc, Acc).
sizeAux([_|T], Acc, Res):-
	NewAcc is 1 + Acc,
    sizeAux(T, NewAcc, Res).

/*Ver que tipo de figura puede ser*/	
figura(List):-
	size(List, X),
	(
	X =:= 3 -> write("Triangulo");
	X =:= 4 -> write("Paralelogramo");
	X =:= 6 -> write("Hexagono")
	).

/*Sin terminar*/
bordes([]).
bordes([H|T]):-
	calc(H),
	bordes(T).
	
calc(X):-
	foreach(between(1, ))
	X.
	