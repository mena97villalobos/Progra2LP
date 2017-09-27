% Receives sorted list of elements
% Input: [1,3,5]
% Output: Triangulo. true.

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
