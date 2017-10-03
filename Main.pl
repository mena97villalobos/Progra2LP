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

%%%%%%%%%%%%%Main%%%%%%%%%%%%%%%%%%%	
is_figureT(_,[]).

is_figure(R, [H|T]):-
	is_figureH(R, H);
	is_figureT(R, T).
	
is_figureT(R, [H|T]):-
	is_figureH(R, H);
	is_figureT(R, T).
	
is_figureH(R, H):-
	length(H, Size),
	(
	Size =:= 3 -> triangulo(H), stringTriangulo(H, R);
	Size =:= 4 -> (paralelogramo(H); rombo(H)), stringParalelogramo(H, R);
	Size =:= 6 -> hexagono(H), stringHexagono(H, R);
	default(H, R)%FIXME fallo al instanciar R%
	).
	
%%%%%%%%%%%%%%Crear los strings para cada resultado%%%%%%%%%%%%%%%%%%%	
stringTriangulo(List, R):-
	atomic_list_concat(List, ' ', Atom), 
	A = 'Los vertices: ', 
	B = ' son los de un triangulo', 
	string_concat(A, Atom, S1), 
	string_concat(S1, B, R).

stringParalelogramo(List, R):-
	atomic_list_concat(List, ' ', Atom), 
	A = 'Los vertices: ', 
	B = ' son los de un paralelogramo', 
	string_concat(A, Atom, S1), 
	string_concat(S1, B, R).
	
stringHexagono(List, R):-
	hexagono(List),
	atomic_list_concat(List, ' ', Atom), 
	A = 'Los vertices: ', 
	B = ' son los de un hexagono', 
	string_concat(A, Atom, S1), 
	string_concat(S1, B, R).
	
default(List, R):-
	atomic_list_concat(List, ' ', Atom), 
	A = 'Los vertices: ', 
	B = ' no son una figura valida', 
	string_concat(A, Atom, S1), 
	string_concat(S1, B, R).

%%%%%%%%%%%%%%%%%%%%%%%%triangulo%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
triangulo(List):-
	quicksort(List, Sorted),
	crearListaNiveles(Sorted, Res, []),%Lista de niveles
	[H|T] = Res,
	verticesValidos(H, T, 0, UpDown),
	validarLado(UpDown, Sorted, Res).
	
%Crear lista de ubicacion en niveles de los vertices%
crearListaNiveles([], Acc, Acc).
crearListaNiveles([H|T], Res, Acc):-
	calcNivel(H, 1, X),
	append(Acc, [X|[]], NewAcc),
	crearListaNiveles(T, Res, NewAcc).

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
		Hanterior =:= H -> Res is 1, true;
		verticesValidos(H, T, 1, Res)
	).	
verticesValidos(Hanterior, HeadTail, 1, Res):-
	Hanterior =:= HeadTail -> Res is 0, true.

%Validacion del tamaño de los lados para el triangulo
validarLado(1, Vertices, Niveles):- %base arriba
	[H|[HofT|[TofT|_]]] = Vertices,
	[HN|[HofTN|[TofTN|_]]] = Niveles,
	Base is HofT - H + 1,%Igualar el numero de vertices de la base
	Lado is TofTN - HofTN + 1,%Igualar numero de vertices del lado
	BaseLev is H-(((HN-1)*HN/2)+1),%offset desde el borde del triangulo infinito
	InicioLev is ((TofTN-1)*TofTN/2)+1+(Base-1)+BaseLev,%Conseguir el vertice teorico para el triangulo actual
	=(Base,Lado),%Validar que la base y el lado sean del mismo tamaño
	=(InicioLev,TofT).%Validar el vertice teorico con el vertice dado
	
validarLado(0, Vertices, Niveles):- %base abajo
	[H|[HofT|[TofT|_]]] = Vertices,
	[HN|[HofTN|[TofTN|_]]] = Niveles,
	Base is TofT - HofT + 1,%Igualar el numero de vertices de la base
	Lado is TofTN - HN + 1,%Igualar numero de vertices del lado
	BaseLev is ((HN-1)*HN/2)+1 + HofT-(((HofTN-1)*HofTN/2)+1),%offset desde el borde del triangulo infinito
	=(Base,Lado),%Validar que la base y el lado sean del mismo tamaño
	=(H,BaseLev).%Validar el vertice teorico con el vertice dado
	
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Paralelogramo%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
paralelogramo(List):-
	quicksort(List, Sorted),
	crearListaNiveles(Sorted, Res, []),%Lista de niveles
	[H|T] = Res,
	nivelParalelogramo(H, T),
	ladosParalelogramo(Res, Sorted, IzqDer),
	casosParalelogramo(IzqDer, Sorted).

%Verifica que los vertices esten distribuidos en 2 niveles 
nivelParalelogramo(H, [H2|T]):-
	H =:= H2,
	[H3|[H4|_]] = T,
	H3 =:= H4.

ladosParalelogramo(Niveles, Vertices, Res):-
	[Ver1|[Ver2|[Ver3|Ver4]]] = Vertices,
	[Lev1|[_|[Lev3|_]]] = Niveles,
	Side1 is Ver2 - Ver1,
	Side1 =:= Ver4 - Ver3,
	Side1 =:= Lev3 - Lev1,
	AuxI1 is ((Lev1-1)*Lev1/2)+1,
	AuxI2 is ((Lev3-3)*Lev3/2)+1,
	(
	AuxI1 =:= Ver1 -> Res is 0; %Inclicado a la izquierda como [11,13,24,26]
	Ver1 - AuxI1 < Ver3 - AuxI2 -> Res is 0; %Inclicado a la izquierda como [11,13,24,26]
	Ver1 - AuxI1 =:= Ver3 - AuxI2 -> Res is 1 %Inclinado a la derecha como [23, 24, 38, 40]
	).
	
casosParalelogramo(0, Vertices):-
	[Ver1|[Ver2|[Ver3|[Ver4|_]]]] = Vertices,
	triangulo([Ver1, Ver2, Ver3]),
	triangulo([Ver2, Ver3, Ver4]).

casosParalelogramo(1, Vertices):-
	[Ver1|[Ver2|[Ver3|[Ver4|_]]]] = Vertices,
	triangulo([Ver1, Ver3, Ver4]),
	triangulo([Ver1, Ver4, Ver2]).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%Hexagono%%%%%%%%%%%%%%%%%%%%%%%%%
hexagono(List):-
	quicksort(List, Sorted),
	crearListaNiveles(Sorted, Res, []),%Lista de niveles
	nivelesHexagono(Res),
	validarHexagono(Sorted).
	
nivelesHexagono(Niveles):-
	[N1|[N2|[N3|[N4|[N5|[N6|_]]]]]] = Niveles,
	N1 =:= N2,
	N3 =:= N4,
	N5 =:= N6.

validarHexagono(Vertices):-
	[V1|[V2|[V3|[V4|[V5|[V6|_]]]]]] = Vertices,
	Medio is (V4+V3)/2,
	triangulo([V1,V2,Medio]),
	triangulo([V2,Medio,V4]),
	triangulo([Medio,V4,V6]),
	triangulo([Medio,V5,V6]),
	triangulo([V3,Medio,V5]),
	triangulo([V1,V3,Medio]).
	
	
%%%%%%%%%%%%%%%%%%%%%Rombo(Caso de paralelogramo)%%%%%%%%%%%%%%%%
rombo(List):-
	quicksort(List, Sorted),
	crearListaNiveles(Sorted, Res, []),%Lista de niveles
	[N1, N2, N3, N4] = Res,
	[V1,V2,V3,V4] = Sorted,
	Aux is N2-N1,
	N2 =:= N3,
	Aux =:= N4-N2,
	V3-V2 =:= Aux,
	triangulo([V1,V2,V3]),
	triangulo([V2,V3,V4]).
