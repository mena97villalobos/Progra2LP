
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
	
/*K es el valor a buscar, NO ES EN UNA LISTA ES RECURSIVO, devuelve false siempre y para al encontrar el K o al llegar al nivel 255 ->cuando no lo encuentra*/
derecha(K) :- N is 1, derecha(N, K).
derecha(_, 0):- nl.
derecha(N, K):-
  N < 256, K > 0, N1 is N+1, Q is (N*(N+1)/2), Q \== K,
  write(Q),write('   '),
  derecha(N1, K).

izquierda(K) :- N is 1, izquierda(N, K).
izquierda(_, 0):- nl.
izquierda(N, K):-
  N < 256,  K > 0, N1 is N+1, Q is((N-1)*N/2)+1, Q \== K,
  write(Q),write('   '),
  izquierda(N1, K).
	
% Receives sorted list of elements
isShapeValid(List) :-
    length(List, X),
    (
        X =:= 3 -> write("Triangulo"), isTriangleBalanced(List);
	X =:= 4 -> write("Paralelogramo"), isParallelogramBalanced(List);
	X =:= 6 -> write("Hexagono"), isHexagonBalanced(List)
    ).

% Receives list of elements (3)
isTriangleBalanced([A|[B|[C|_]]]) :-
    B - A =:= C - B.

% Receives list of elements (4)
isParallelogramBalanced([A|[B|[C|[D|_]]]]) :-
    B - A =:= C - B,
    C - B =:= D - C.

% Receives list of elements (6)
isHexagonBalanced([A|[B|[C|[D|[E|[F|_]]]]]]) :-
    B - A =:= C - B,
    C - B =:= D - C,
    D - C =:= E - F.