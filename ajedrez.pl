jugador(negras).
jugador(blancas).

hola(X) :- X == 1.

coordenadas(X, Y) :- 1 =< X, X =< 8, 1 =< Y, Y =< 8.

peon(Jugador, Fila, Columna) :- jugador(Jugador), coordenadas(Fila, Columna).
torre(Jugador, Fila, Columna) :- jugador(Jugador), coordenadas(Fila, Columna).
caballo(Jugador, Fila, Columna) :- jugador(Jugador), coordenadas(Fila, Columna).
alfil(Jugador, Fila, Columna) :- jugador(Jugador), coordenadas(Fila, Columna).
dama(Jugador, Fila, Columna) :- jugador(Jugador), coordenadas(Fila, Columna).
rey(Jugador, Fila, Columna) :- jugador(Jugador), coordenadas(Fila, Columna).

insertarCoord(Elemento, Lista, [Elemento | Lista]).

member(X,[X|_]).
member(X,[_|List]) :- member(X,List).

validarPosiciones([], _).
validarPosiciones([peon(J, X, Y)|T], Ocupadas) :- peon(J, X, Y), not(member([X, Y], Ocupadas)), insertarCoord([X, Y], Ocupadas, Ocupadas2),validarPosiciones(T, Ocupadas2).
validarPosiciones([torre(J, X, Y)|T], Ocupadas) :- torre(J, X, Y), not(member([X, Y], Ocupadas)), insertarCoord([X, Y], Ocupadas, Ocupadas2), validarPosiciones(T, Ocupadas2).
validarPosiciones([caballo(J, X, Y)|T], Ocupadas) :- caballo(J, X, Y), not(member([X, Y], Ocupadas)), insertarCoord([X, Y], Ocupadas, Ocupadas2), validarPosiciones(T, Ocupadas2).
validarPosiciones([alfil(J, X, Y)|T], Ocupadas) :- alfil(J, X, Y), not(member([X, Y], Ocupadas)), insertarCoord([X, Y], Ocupadas, Ocupadas2), validarPosiciones(T, Ocupadas2).
validarPosiciones([dama(J, X, Y)|T], Ocupadas) :- dama(J, X, Y), not(member([X, Y], Ocupadas)), insertarCoord([X, Y], Ocupadas, Ocupadas2), validarPosiciones(T, Ocupadas2).
validarPosiciones([rey(J, X, Y)|T], Ocupadas) :- rey(J, X, Y), not(member([X, Y], Ocupadas)), insertarCoord([X, Y], Ocupadas, Ocupadas2), validarPosiciones(T, Ocupadas2).

numPiezas([], _, Peones, Torres, Caballos, Alfiles, Damas, Rey) :- Peones =< 8, Max is 10 - Peones, Torres =< Max, Caballos =< Max, Alfiles =< Max, Damas =< 9 - Peones,  Rey == 1.
numPiezas([peon(Color, _, _)|T], Color, P, To, C, A, D, R) :- P2 is P + 1, numPiezas(T, Color, P2, To, C, A, D, R).
numPiezas([peon(Otro, _, _)|T], Color, P, To, C, A, D, R) :- Otro \= Color, numPiezas(T,Color, P, To, C, A, D, R).
numPiezas([torre(Color, _, _)|T], Color, P, To, C, A, D, R) :- To2 is To + 1, numPiezas(T, Color, P, To2, C, A, D, R).
numPiezas([torre(Otro, _, _)|T], Color, P, To, C, A, D, R) :- Otro \= Color, numPiezas(T,Color, P, To, C, A, D, R).
numPiezas([caballo(Color, _, _)|T], Color, P, To, C, A, D, R) :- C2 is C + 1, numPiezas(T, Color, P, To, C2, A, D, R).
numPiezas([caballo(Otro, _, _)|T], Color, P, To, C, A, D, R) :- Otro \= Color, numPiezas(T,Color, P, To, C, A, D, R).
numPiezas([alfil(Color, _, _)|T], Color, P, To, C, A, D, R) :- A2 is A + 1, numPiezas(T, Color, P, To, C, A2, D, R).
numPiezas([alfil(Otro, _, _)|T], Color, P, To, C, A, D, R) :- Otro \= Color, numPiezas(T,Color, P, To, C, A, D, R).
numPiezas([dama(Color, _, _)|T], Color, P, To, C, A, D, R) :- D2 is D + 1, numPiezas(T, Color, P, To, C, A, D2, R).
numPiezas([dama(Otro, _, _)|T], Color, P, To, C, A, D, R) :- Otro \= Color, numPiezas(T,Color, P, To, C, A, D, R).
numPiezas([rey(Color, _, _)|T], Color, P, To, C, A, D, R) :- R2 is R + 1, numPiezas(T, Color, P, To, C, A, D, R2).
numPiezas([rey(Otro, _, _)|T], Color, P, To, C, A, D, R) :- Otro \= Color, numPiezas(T,Color, P, To, C, A, D, R).

numeroPiezas(Tablero, Color) :- numPiezas(Tablero, Color, 0, 0, 0, 0, 0, 0).

valido(Tablero) :- validarPosiciones(Tablero, []), numeroPiezas(Tablero, blancas), numeroPiezas(Tablero, negras).