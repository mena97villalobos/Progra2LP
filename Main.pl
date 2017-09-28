%Ordenar una lista por quicksort%
pivot(_, [], [], []).
pivot(Pivot, [Head|Tail], [Head|LessOrEqualThan], GreaterThan) :- 
	Pivot >= Head, pivot(Pivot, Tail, LessOrEqualThan, GreaterThan). 
pivot(Pivot, [Head|Tail], LessOrEqualThan, [Head|GreaterThan]) :- 
	pivot(Pivot, Tail, LessOrEqualThan, GreaterThan).

quicksort([], []).
quicksort([Head|Tail], Sorted) :- 
	pivot(Head, Tail, List1, List2), 
	quicksort(List1, SortedList1), 
	quicksort(List2, SortedList2), 
	append(SortedList1, [Head|SortedList2], Sorted).

%Tamaño dde una lista%
size([H|T], Result):-
	sizeAux(T, 1, Result).

sizeAux([], Acc, Acc).
sizeAux([_|T], Acc, Res):-
	NewAcc is 1 + Acc,
    sizeAux(T, NewAcc, Res).

%Aproximar el resultado por la cantidad de vertices de la entrada%
figura(List):-
	size(List, X),
	(
	X =:= 3 -> triangulo(List);
	X =:= 4 -> write("Paralelogramo"), put(10);
	X =:= 6 -> write("Hexagono"), put(10);
	X >= 7 -> write("Los vertices no son una figura valida"), put(10)
	).

%Vailidar si 3 vertices son un triangulo%
triangulo(List):-
	quicksort(List, Sorted),
	crearLista(Sorted, Res, []),%Lista de niveles
	[H|T] = ResSorted,
	verticesValidos(H, T, 0, UpDown),
	validarLado(UpDown, Sorted, ResSorted).
	
%Crear lista de ubicacion en niveles de los vertices%
crearLista([], Acc, Acc).
crearLista([H|T], Res, Acc):-
	calcNivel(H, 1, X),
	append(Acc, [X|[]], NewAcc),
	crearLista(T, Res, NewAcc).

%Calcular el nivel de un vertice%
calcNivel(Int, Nivel, Res):-
	AuxI is ((Nivel-1)*Nivel/2)+1,
	AuxF is ((Nivel+1)*Nivel/2),
	(
	AuxI =< Int, AuxF >= Int -> Res is Nivel, true;
	Nivel < 256 -> NewLev is Nivel+1, calcNivel(Int, NewLev, Res)
	).

%Retorna true si hay dos vertices en el mismo nivel SOLO PARA TRIANGULO se usa 0 cuando es la primera revision y 1 cuando es la segunda%
verticesValidos(Hanterior, [H|T], 0, Res):-
	(
		Hanterior =:= H -> write("Base arriba"), Res is 1, true. %validarLados(Vertices, Niveles, 0), true;
		verticesValidos(H, T, 1)
	).
	
verticesValidos(Hanterior, HeadTail, 1):-
	Hanterior =:= HeadTail -> write("Base abajo"), Res is 0, true. %validarLados(Vertices, Niveles, 1), true.

validarLado(1, Vertices, Niveles):- %base arriba
	[H|[HofT|TofT]] = Vertices,
	[HN|[HofTN|TofTN]] = Niveles,
	Base is HofT - H + 1,%Igualar el numero de vertices de la base
	Lado is TofTN - HofTN + 1,%Igualar numero de vertices del lado
	BaseLev is H-(((HN-1)*HN/2)+1),
	InicioLev is ((TofTN-1)*TofTN/2)+1+(Base-1)+BaseLev,
	InicioLev =:= TofT.
	

/*Falta FIXME	
validarLados(Vertices, Niveles, 0):-
	[H|T] = Vertices,
	[HofT|_] = T,
	Base is HofT - T, %Tamaño de la base
	
	[HofNivel|TofNivel] = Niveles,
	[_|TofT] = TofNivel,
	Lado1 is TofT - HofNivel,
	
	
	Base =:= Lado -> true.
	
validarLados(Vertices, Niveles, 1):-
	[H|T] = Vertices,
	[HofT|_] = T,
	Base is HofT - T, %Tamaño de la base
	
	[X|Y] = Niveles,
	[Z|_] = TofNivel,
	Lado1 is TofT - HofNivel,
	
	
	Base =:= Lado -> true.
	
*/
