quicksort([X|Xs],Ys) :-
  partition(Xs,X,Left,Right),
  quicksort(Left,Ls),
  quicksort(Right,Rs),
  append(Ls,[X|Rs],Ys).
quicksort([],[]).

partition([X|Xs],Y,[X|Ls],Rs) :-
  X <= Y, partition(Xs,Y,Ls,Rs).
partition([X|Xs],Y,Ls,[X|Rs]) :-
  X > Y, partition(Xs,Y,Ls,Rs).
partition([],Y,[],[]).

append([],Ys,Ys).
append([X|Xs],Ys,[X|Zs]) :- append(Xs,Ys,Zs).

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
	