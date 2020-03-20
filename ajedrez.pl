/*These are the only facts available*/
jugador(negras).
jugador(blancas).

/********************* FIRST PART ************************/

/*Determines if the coordinates of a square are valid*/
coordenadas(X, Y) :- 1 =< X, X =< 8, 1 =< Y, Y =< 8.

/*Determines if a piece is either black or white and if the coordinates are valid*/
peon(Jugador, Fila, Columna) :- jugador(Jugador), coordenadas(Fila, Columna).
torre(Jugador, Fila, Columna) :- jugador(Jugador), coordenadas(Fila, Columna).
caballo(Jugador, Fila, Columna) :- jugador(Jugador), coordenadas(Fila, Columna).
alfil(Jugador, Fila, Columna) :- jugador(Jugador), coordenadas(Fila, Columna).
dama(Jugador, Fila, Columna) :- jugador(Jugador), coordenadas(Fila, Columna).
rey(Jugador, Fila, Columna) :- jugador(Jugador), coordenadas(Fila, Columna).

/*Inserts the coordinates we have already read on a list*/
insertarCoord(Elemento, Lista, [Elemento | Lista]).

/*Checks if an element is a member of a lisr*/
member(X,[X|_]).
member(X,[_|List]) :- member(X,List).

/*Given a list of pieces, determines if every piece is a valid piece, and that there is only one piece in per square*/
validarPosiciones([], _).
validarPosiciones([peon(J, X, Y)|T], Ocupadas) :- peon(J, X, Y), not(member([X, Y], Ocupadas)), insertarCoord([X, Y], Ocupadas, Ocupadas2),validarPosiciones(T, Ocupadas2).
validarPosiciones([torre(J, X, Y)|T], Ocupadas) :- torre(J, X, Y), not(member([X, Y], Ocupadas)), insertarCoord([X, Y], Ocupadas, Ocupadas2), validarPosiciones(T, Ocupadas2).
validarPosiciones([caballo(J, X, Y)|T], Ocupadas) :- caballo(J, X, Y), not(member([X, Y], Ocupadas)), insertarCoord([X, Y], Ocupadas, Ocupadas2), validarPosiciones(T, Ocupadas2).
validarPosiciones([alfil(J, X, Y)|T], Ocupadas) :- alfil(J, X, Y), not(member([X, Y], Ocupadas)), insertarCoord([X, Y], Ocupadas, Ocupadas2), validarPosiciones(T, Ocupadas2).
validarPosiciones([dama(J, X, Y)|T], Ocupadas) :- dama(J, X, Y), not(member([X, Y], Ocupadas)), insertarCoord([X, Y], Ocupadas, Ocupadas2), validarPosiciones(T, Ocupadas2).
validarPosiciones([rey(J, X, Y)|T], Ocupadas) :- rey(J, X, Y), not(member([X, Y], Ocupadas)), insertarCoord([X, Y], Ocupadas, Ocupadas2), validarPosiciones(T, Ocupadas2).

/*Given a player and a list of pieces, it determines that the number of pieces for each type is valid*/
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

/*This rules is a wrappper for the rule above. It will probably be eliminated in future versions*/
numeroPiezas(Tablero, Color) :- numPiezas(Tablero, Color, 0, 0, 0, 0, 0, 0).

/*Given a representation of the chess board's state in the form of a list of pieces*/
valido(Tablero) :- validarPosiciones(Tablero, []), numeroPiezas(Tablero, blancas), numeroPiezas(Tablero, negras).

/********************* THIRD PART (I SKIPPED THE SECOND, I HATE PRINTING STUFF THAT WAY)************************/

/*Unifies [X, Y] with the coordinate's of one of the player's rooks*/
buscarTorre(Jugador, [torre(Jugador, X, Y)|_], [X, Y]).
buscarTorre(Jugador, [_|T], Torre) :- buscarTorre(Jugador, T, Torre).

mover(Jugador,Anterior,Actual) :- buscarTorre(Jugador, Anterior, Torre), moverTorre(Jugador, Torre, 1, Anterior, Actual).