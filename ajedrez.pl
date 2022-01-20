% CI-3661 Proyecto II: Jaque Mate, Jack
% Miembros:  
% Diego Peña 15-11095  
% Wilfredo Graterol 15-10639

:- dynamic pieza/4.

/*These are the only facts available*/
jugador(negras).
jugador(blancas).

/********************************************* FIRST PART ************************************************/

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

/********************************************* SECOND PART ************************************************/

% In an initial board it substitutes every piece then prints it
mostrar(Tablero) :- valido(Tablero), sustituirEnTablero(Tablero, ["--|--|--|--|--|--|--|--","\n",
"11", "|", "12", "|", "13", "|", "14", "|", "15", "|", "16", "|", "17", "|", "18","\n",
"--+--+--+--+--+--+--+--","\n",
"21", "|", "22", "|", "23", "|", "24", "|", "25", "|", "26", "|", "27", "|", "28","\n",
"--+--+--+--+--+--+--+--","\n",
"31", "|", "32", "|", "33", "|", "34", "|", "35", "|", "36", "|", "37", "|", "38","\n",
"--+--+--+--+--+--+--+--","\n",
"41", "|", "42", "|", "43", "|", "44", "|", "45", "|", "46", "|", "47", "|", "48","\n",
"--+--+--+--+--+--+--+--","\n",
"51", "|", "52", "|", "53", "|", "54", "|", "55", "|", "56", "|", "57", "|", "58","\n",
"--+--+--+--+--+--+--+--","\n",
"61", "|", "62", "|", "63", "|", "64", "|", "65", "|", "66", "|", "67", "|", "68","\n",
"--+--+--+--+--+--+--+--","\n",
"71", "|", "72", "|", "73", "|", "74", "|", "75", "|", "76", "|", "77", "|", "78","\n",
"--+--+--+--+--+--+--+--","\n",
"81", "|", "82", "|", "83", "|", "84", "|", "85", "|", "86", "|", "87", "|", "88","\n",
"--|--|--|--|--|--|--|--", "\n"], TableroParaImprimir), mostrarTablero(TableroParaImprimir).

% Prints the given array string presentation of a board
mostrarTablero([String | Tablero]) :- (number_string(_, String) -> write("  ") ; write(String)), mostrarTablero(Tablero).
mostrarTablero([String]) :- (number_string(_, String) -> write("  ") ; write(String)).

% Returns the string representing the player
stringPlayer(blancas, String) :- String = 'B'.
stringPlayer(negras, String) :- String = 'N'.

% Adds to a string representation of a board the pieces of the given board
sustituirEnTablero([peon(Jugador, Fila, Columna) | Tablero], ListaTablero, ListaTableroNuevo) :- sustituirEnTablero(Tablero, ListaTablero, ListaTableroNuevoAux), stringPlayer(Jugador, StringJugador), string_concat('P', StringJugador, StringPieza), Pos is Fila*10+Columna, number_string(Pos, PosStr), select(PosStr, ListaTableroNuevoAux, StringPieza, ListaTableroNuevo).
sustituirEnTablero([torre(Jugador, Fila, Columna) | Tablero], ListaTablero, ListaTableroNuevo) :- sustituirEnTablero(Tablero, ListaTablero, ListaTableroNuevoAux), stringPlayer(Jugador, StringJugador), string_concat('T', StringJugador, StringPieza), Pos is Fila*10+Columna, number_string(Pos, PosStr), select(PosStr, ListaTableroNuevoAux, StringPieza, ListaTableroNuevo).
sustituirEnTablero([caballo(Jugador, Fila, Columna) | Tablero], ListaTablero, ListaTableroNuevo) :- sustituirEnTablero(Tablero, ListaTablero, ListaTableroNuevoAux), stringPlayer(Jugador, StringJugador), string_concat('C', StringJugador, StringPieza), Pos is Fila*10+Columna, number_string(Pos, PosStr), select(PosStr, ListaTableroNuevoAux, StringPieza, ListaTableroNuevo).
sustituirEnTablero([alfil(Jugador, Fila, Columna) | Tablero], ListaTablero, ListaTableroNuevo) :- sustituirEnTablero(Tablero, ListaTablero, ListaTableroNuevoAux), stringPlayer(Jugador, StringJugador), string_concat('A', StringJugador, StringPieza), Pos is Fila*10+Columna, number_string(Pos, PosStr), select(PosStr, ListaTableroNuevoAux, StringPieza, ListaTableroNuevo).
sustituirEnTablero([dama(Jugador, Fila, Columna) | Tablero], ListaTablero, ListaTableroNuevo) :- sustituirEnTablero(Tablero, ListaTablero, ListaTableroNuevoAux), stringPlayer(Jugador, StringJugador), string_concat('D', StringJugador, StringPieza), Pos is Fila*10+Columna, number_string(Pos, PosStr), select(PosStr, ListaTableroNuevoAux, StringPieza, ListaTableroNuevo).
sustituirEnTablero([rey(Jugador, Fila, Columna) | Tablero], ListaTablero, ListaTableroNuevo) :- sustituirEnTablero(Tablero, ListaTablero, ListaTableroNuevoAux), stringPlayer(Jugador, StringJugador), string_concat('R', StringJugador, StringPieza), Pos is Fila*10+Columna, number_string(Pos, PosStr), select(PosStr, ListaTableroNuevoAux, StringPieza, ListaTableroNuevo).

sustituirEnTablero([peon(Jugador, Fila, Columna)], ListaTablero, ListaTableroNuevo) :- stringPlayer(Jugador, StringJugador), string_concat('P', StringJugador, StringPieza), Pos is Fila*10+Columna, number_string(Pos, PosStr), select(PosStr, ListaTablero, StringPieza, ListaTableroNuevo).
sustituirEnTablero([torre(Jugador, Fila, Columna)], ListaTablero, ListaTableroNuevo) :- stringPlayer(Jugador, StringJugador), string_concat('T', StringJugador, StringPieza), Pos is Fila*10+Columna, number_string(Pos, PosStr), select(PosStr, ListaTablero, StringPieza, ListaTableroNuevo).
sustituirEnTablero([caballo(Jugador, Fila, Columna)], ListaTablero, ListaTableroNuevo) :- stringPlayer(Jugador, StringJugador), string_concat('C', StringJugador, StringPieza), Pos is Fila*10+Columna, number_string(Pos, PosStr), select(PosStr, ListaTablero, StringPieza, ListaTableroNuevo).
sustituirEnTablero([alfil(Jugador, Fila, Columna)], ListaTablero, ListaTableroNuevo) :- stringPlayer(Jugador, StringJugador), string_concat('A', StringJugador, StringPieza), Pos is Fila*10+Columna, number_string(Pos, PosStr), select(PosStr, ListaTablero, StringPieza, ListaTableroNuevo).
sustituirEnTablero([dama(Jugador, Fila, Columna)], ListaTablero, ListaTableroNuevo) :- stringPlayer(Jugador, StringJugador), string_concat('D', StringJugador, StringPieza), Pos is Fila*10+Columna, number_string(Pos, PosStr), select(PosStr, ListaTablero, StringPieza, ListaTableroNuevo).
sustituirEnTablero([rey(Jugador, Fila, Columna)], ListaTablero, ListaTableroNuevo) :- stringPlayer(Jugador, StringJugador), string_concat('R', StringJugador, StringPieza), Pos is Fila*10+Columna, number_string(Pos, PosStr), select(PosStr, ListaTablero, StringPieza, ListaTableroNuevo).

/********************************************* THIRD PART ************************************************/


/*Checks the state of a given square: Empty (0), occupied by the player (2) or by the enemy (1). It unifies NuevoTablero
with Anterior in the former two cases and with Anterior without the piece in the given square in the latter*/
libre(_, _, _,[], NuevoTablero, Estado) :- NuevoTablero = [], Estado = 0.
libre(Color, X, Y, [peon(J, X2, Y2)|T], NuevoTablero, Estado) :- [X, Y]  \= [X2, Y2], libre(Color, X, Y, T, NuevoTablero2, Estado), 
                                                                 NuevoTablero = [peon(J, X2, Y2)|NuevoTablero2].
libre(Color, X, Y, [peon(J, X2, Y2)|T], NuevoTablero, Estado) :- [X, Y]  = [X2, Y2], Color \= J, Estado = 1, NuevoTablero = T.
libre(Color, X, Y, [peon(J, X2, Y2)|T], NuevoTablero, Estado) :- [X, Y]  = [X2, Y2], Color = J, Estado = 2, NuevoTablero = [peon(J, X2, Y2)|T].
libre(Color, X, Y, [torre(J, X2, Y2)|T], NuevoTablero, Estado) :- [X, Y] \= [X2, Y2], libre(Color, X, Y, T, NuevoTablero2, Estado),
                                                                  NuevoTablero = [torre(J, X2, Y2)|NuevoTablero2].
libre(Color, X, Y, [torre(J, X2, Y2)|T], NuevoTablero, Estado) :- [X, Y]  = [X2, Y2], Color \= J, Estado = 1, NuevoTablero = T.
libre(Color, X, Y, [torre(J, X2, Y2)|T], NuevoTablero, Estado) :- [X, Y]  = [X2, Y2], Color = J, Estado = 2, NuevoTablero = [torre(J, X2, Y2)|T].
libre(Color, X, Y, [caballo(J, X2, Y2)|T], NuevoTablero, Estado) :- [X, Y]  \= [X2, Y2], libre(Color, X, Y, T, NuevoTablero2, Estado),
                                                                    NuevoTablero = [caballo(J, X2, Y2)|NuevoTablero2].
libre(Color, X, Y, [caballo(J, X2, Y2)|T], NuevoTablero, Estado) :- [X, Y]  = [X2, Y2], Color \= J, Estado = 1, NuevoTablero = T.
libre(Color, X, Y, [caballo(J, X2, Y2)|T], NuevoTablero, Estado) :- [X, Y]  = [X2, Y2], Color = J, Estado = 2, NuevoTablero = [caballo(J, X2, Y2)|T].
libre(Color, X, Y, [alfil(J, X2, Y2)|T], NuevoTablero, Estado) :- [X, Y]  \= [X2, Y2], libre(Color, X, Y, T, NuevoTablero2, Estado),
                                                                  NuevoTablero = [alfil(J, X2, Y2)|NuevoTablero2].
libre(Color, X, Y, [alfil(J, X2, Y2)|T], NuevoTablero, Estado) :- [X, Y]  = [X2, Y2], Color \= J, Estado = 1, NuevoTablero = T.
libre(Color, X, Y, [alfil(J, X2, Y2)|T], NuevoTablero, Estado) :- [X, Y]  = [X2, Y2], Color = J, Estado = 2, NuevoTablero = [alfil(J, X2, Y2)|T].
libre(Color, X, Y, [dama(J, X2, Y2)|T], NuevoTablero, Estado) :- [X, Y]  \= [X2, Y2], libre(Color, X, Y, T, NuevoTablero2, Estado),
                                                                 NuevoTablero = [dama(J, X2, Y2)|NuevoTablero2].
libre(Color, X, Y, [dama(J, X2, Y2)|T], NuevoTablero, Estado) :- [X, Y]  = [X2, Y2], Color \= J, Estado = 1, NuevoTablero = T.
libre(Color, X, Y, [dama(J, X2, Y2)|T], NuevoTablero, Estado) :- [X, Y]  = [X2, Y2], Color = J, Estado = 2, NuevoTablero = [dama(J, X2, Y2)|T].
libre(Color, X, Y, [rey(J, X2, Y2)|T], NuevoTablero, Estado) :- [X, Y]  \= [X2, Y2] , libre(Color, X, Y, T, NuevoTablero2, Estado),
                                                                NuevoTablero = [rey(J, X2, Y2)|NuevoTablero2].
libre(_, X, Y, [rey(J, X2, Y2)|T], NuevoTablero, Estado) :- [X, Y] = [X2, Y2], Estado = 2, NuevoTablero = [rey(J, X2, Y2)|T].

/*Updates the board with the lastest move*/
actualizarTablero(X, Y, X2, Y2, [peon(J, X, Y)|T], Actual) :- Actual = [peon(J, X2, Y2)|T].  
actualizarTablero(X, Y, X2, Y2, [torre(J, X, Y)|T], Actual) :- Actual = [torre(J, X2, Y2)|T].
actualizarTablero(X, Y, X2, Y2, [caballo(J, X, Y)|T], Actual) :- Actual = [caballo(J, X2, Y2)|T].   
actualizarTablero(X, Y, X2, Y2, [alfil(J, X, Y)|T], Actual) :- Actual = [alfil(J, X2, Y2)|T].  
actualizarTablero(X, Y, X2, Y2, [dama(J, X, Y)|T], Actual) :- Actual = [dama(J, X2, Y2)|T].  
actualizarTablero(X, Y, X2, Y2, [rey(J, X, Y)|T], Actual) :- Actual = [rey(J, X2, Y2)|T].
actualizarTablero(X, Y, X2, Y2, [H|T], Actual) :- actualizarTablero(X, Y, X2, Y2, T, Actual2), Actual = [H|Actual2]. 

/*Crowns the pawn */
coronacion(X, Y, X2, Y2, [peon(J, X, Y)|T], Actual) :- Actual = [torre(J, X2, Y2)|T].
coronacion(X, Y, X2, Y2, [peon(J, X, Y)|T], Actual) :- Actual = [alfil(J, X2, Y2)|T].
coronacion(X, Y, X2, Y2, [peon(J, X, Y)|T], Actual) :- Actual = [dama(J, X2, Y2)|T].
coronacion(X, Y, X2, Y2, [peon(J, X, Y)|T], Actual) :- Actual = [caballo(J, X2, Y2)|T].
coronacion(X, Y, X2, Y2, [H|T], Actual) :- coronacion(X, Y, X2, Y2, T, Actual2), Actual = [H|Actual2]. 

/*Saves the position of the pieces of the board as facts before checking for a check, in order to avoid a significant number of
iterations over the board*/
estadoTablero(Tablero) :- retractall(pieza(_, _, _, _)), estadoTableroAux(Tablero).

estadoTableroAux([]).
estadoTableroAux([peon(J, X, Y)|T]) :- assert(pieza(peon, J, X, Y)), estadoTableroAux(T).
estadoTableroAux([torre(J, X, Y)|T]) :- assert(pieza(torre, J, X, Y)), estadoTableroAux(T).
estadoTableroAux([alfil(J, X, Y)|T]) :- assert(pieza(alfil, J, X, Y)), estadoTableroAux(T).
estadoTableroAux([caballo(J, X, Y)|T]) :- assert(pieza(caballo, J, X, Y)), estadoTableroAux(T).
estadoTableroAux([dama(J, X, Y)|T]) :- assert(pieza(dama, J, X, Y)), estadoTableroAux(T).
estadoTableroAux([rey(J, X, Y)|T]) :- assert(pieza(rey, J, X, Y)), estadoTableroAux(T).
                                                                          
/*Unifies [X, Y] with the coordinate's of one of the player's rooks*/
buscarTorre(Jugador, [torre(Jugador, X, Y)|_], [X, Y]).
buscarTorre(Jugador, [_|T], Torre) :- buscarTorre(Jugador, T, Torre).

/*Unifies [X, Y] with the coordinate's of one of the player's bishops*/
buscarAlfil(Jugador, [alfil(Jugador, X, Y)|_], [X, Y]).
buscarAlfil(Jugador, [_|T], Alfil) :- buscarAlfil(Jugador, T, Alfil).

buscarDama(Jugador, [dama(Jugador, X, Y)|_], [X, Y]).
buscarDama(Jugador, [_|T], Dama) :- buscarDama(Jugador, T, Dama).

buscarCaballo(Jugador, [caballo(Jugador, X, Y)|_], [X, Y]).
buscarCaballo(Jugador, [_|T], Caballo) :- buscarDama(Jugador, T, Caballo).

buscarRey(Jugador, [rey(Jugador, X, Y)|_], [X, Y]).
buscarRey(Jugador, [_|T], Rey) :- buscarRey(Jugador, T, Rey).

buscarPeon(Jugador, [peon(Jugador, X, Y)|_], [X, Y]).
buscarPeon(Jugador, [_|T], Peon) :- buscarPeon(Jugador, T, Peon).

mover(Jugador, Anterior, Actual) :- moverAux(Jugador, Anterior, Actual),not(jaque(Jugador, Actual)), retractall(pieza(_, _, _, _)).

moverAux(Jugador, Anterior, Actual) :- buscarPeon(Jugador, Anterior, Peon), moverPeon(Jugador, Peon, Anterior, Actual).
moverAux(Jugador, Anterior, Actual) :- buscarTorre(Jugador, Anterior, Torre), moverTorre(Jugador, Torre, 1, Anterior, Actual).
moverAux(Jugador, Anterior, Actual) :- buscarAlfil(Jugador, Anterior, Alfil), moverAlfil(Jugador, Alfil, 1, Anterior, Actual).
moverAux(Jugador, Anterior, Actual) :- buscarDama(Jugador, Anterior, Dama), moverTorre(Jugador, Dama, 1, Anterior, Actual).
moverAux(Jugador, Anterior, Actual) :- buscarDama(Jugador, Anterior, Dama), moverAlfil(Jugador, Dama, 1, Anterior, Actual).
moverAux(Jugador, Anterior, Actual) :- buscarCaballo(Jugador, Anterior, Caballo), 
                                       Movimientos = [[-2, 1], [-1, 2], [1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1]],
                                       moverPieza(Jugador, Caballo, Movimientos, Anterior, Actual).
moverAux(Jugador, Anterior, Actual) :- buscarRey(Jugador, Anterior, Rey), 
                                       Movimientos = [[-1, -1], [-1, 0], [-1, 1], [0, 1], [1, 1], [1, 0], [1, -1], [0, -1]],
                                       moverPieza(Jugador, Rey, Movimientos, Anterior, Actual).

/*Uses the proper predicate depending on the direction in which the rook/queen is trying to move*/
moverTorre(Jugador, [X, Y], Desp, Anterior, Actual) :- X2 is X + Desp, coordenadas(X2, Y),
                                                       libre(Jugador, X2, Y, Anterior, NuevoTablero, Estado),
                                                       moverVMa(Jugador, [X, Y], [X2, Y], Desp, Estado, NuevoTablero, Actual).
moverTorre(Jugador, [X, Y], Desp, Anterior, Actual) :- X2 is X - Desp, coordenadas(X2, Y), 
                                                       libre(Jugador, X2, Y, Anterior, NuevoTablero, Estado),
                                                       moverVMe(Jugador, [X, Y], [X2, Y], Desp, Estado, NuevoTablero, Actual).
moverTorre(Jugador, [X, Y], Desp, Anterior, Actual) :- Y2 is Y + Desp, coordenadas(X, Y2),
                                                       libre(Jugador, X, Y2, Anterior, NuevoTablero, Estado),
                                                       moverHMa(Jugador, [X, Y], [X, Y2], Desp, Estado, NuevoTablero, Actual).
moverTorre(Jugador, [X, Y], Desp, Anterior, Actual) :- Y2 is Y - Desp, coordenadas(X, Y2),
                                                       libre(Jugador, X, Y2, Anterior, NuevoTablero, Estado),
                                                       moverHMe(Jugador, [X, Y], [X, Y2], Desp, Estado, NuevoTablero, Actual).

/*Uses the proper predicate depending on the direction in which the bishop/queen is trying to move*/
moverAlfil(Jugador, [X, Y], Desp, Anterior, Actual) :- X2 is X - Desp, Y2 is Y - Desp, coordenadas(X2, Y2),
                                                       libre(Jugador, X2, Y2, Anterior, NuevoTablero, Estado),
                                                       moverDIS(Jugador, [X, Y], [X2, Y2], Desp, Estado, NuevoTablero, Actual).
moverAlfil(Jugador, [X, Y], Desp, Anterior, Actual) :- X2 is X - Desp, Y2 is Y + Desp, coordenadas(X2, Y2),
                                                       libre(Jugador, X2, Y2, Anterior, NuevoTablero, Estado),
                                                       moverDDS(Jugador, [X, Y], [X2, Y2], Desp, Estado, NuevoTablero, Actual).
moverAlfil(Jugador, [X, Y], Desp, Anterior, Actual) :- X2 is X + Desp, Y2 is Y - Desp, coordenadas(X2, Y2),
                                                       libre(Jugador, X2, Y2, Anterior, NuevoTablero, Estado),
                                                       moverDII(Jugador, [X, Y], [X2, Y2], Desp, Estado, NuevoTablero, Actual).
moverAlfil(Jugador, [X, Y], Desp, Anterior, Actual) :- X2 is X + Desp, Y2 is Y + Desp, coordenadas(X2, Y2),
                                                       libre(Jugador, X2, Y2, Anterior, NuevoTablero, Estado),
                                                       moverDDI(Jugador, [X, Y], [X2, Y2], Desp, Estado, NuevoTablero, Actual).

moverPeon(Jugador, [X, Y], Anterior, Actual) :- Jugador = blancas, X = 7, X2 is X - 2, 
                                                peonAvanza(Jugador, [X, Y], [X2, Y], 0, Anterior, Actual).
moverPeon(Jugador, [X, Y], Anterior, Actual) :- Jugador = negras, X = 2, X2 is X + 2, 
                                                peonAvanza(Jugador, [X, Y], [X2, Y], 0, Anterior, Actual).
moverPeon(Jugador, [X, Y], Anterior, Actual) :- Jugador = blancas, X2 is X - 1, 
                                                peonAvanza(Jugador, [X, Y], [X2, Y], 0, Anterior, Actual).
moverPeon(Jugador, [X, Y], Anterior, Actual) :- Jugador = negras, X2 is X + 1, 
                                                peonAvanza(Jugador, [X, Y], [X2, Y], 0, Anterior, Actual).
moverPeon(Jugador, [X, Y], Anterior, Actual) :- Jugador = blancas, X2 is X - 1, Movimientos = [-1, 1], 
                                                getElement(Movimientos, DespY), Y2 is Y + DespY,
                                                peonAvanza(Jugador, [X, Y], [X2, Y2], 1, Anterior, Actual).
moverPeon(Jugador, [X, Y], Anterior, Actual) :- Jugador = negras, X2 is X + 1, Movimientos = [-1, 1], 
                                                getElement(Movimientos, DespY), Y2 is Y + DespY, 
                                                peonAvanza(Jugador, [X, Y], [X2, Y2], 1, Anterior, Actual).


peonAvanza(Jugador, [X, Y], [X2, Y2], EstadoReq, Anterior, Actual) :- coordenadas(X2, Y2),
                                                                      libre(Jugador, X2, Y2, Anterior, NuevoTablero, Estado),
                                                                      Estado = EstadoReq, X2 > 1, X2 < 8,
                                                                      actualizarTablero(X, Y, X2, Y2, NuevoTablero, Actual).
peonAvanza(Jugador, [X, Y], [X2, Y2], EstadoReq, Anterior, Actual) :- coordenadas(X2, Y2),
                                                                      libre(Jugador, X2, Y2, Anterior, NuevoTablero, Estado),
                                                                      Estado = EstadoReq, X2 = 1, 
                                                                      coronacion(X, Y, X2, Y2, NuevoTablero, Actual).
peonAvanza(Jugador, [X, Y], [X2, Y2], EstadoReq, Anterior, Actual) :- coordenadas(X2, Y2),
                                                                      libre(Jugador, X2, Y2, Anterior, NuevoTablero, Estado),
                                                                      Estado = EstadoReq, X2 = 8, 
                                                                      coronacion(X, Y, X2, Y2, NuevoTablero, Actual).

getElement([X|_], X).
getElement([_|T], X) :- getElement(T, X).

moverPieza(Jugador, [X, Y], Movimientos, Anterior, Actual) :- getElement(Movimientos, [DespX, DespY]), 
                                                              moverPiezaAux(Jugador, [X, Y], [DespX, DespY], Anterior, Actual).

moverPiezaAux(Jugador, [X, Y], [DespX, DespY], Anterior, Actual) :- X2 is X + DespX, Y2 is Y + DespY, coordenadas(X2, Y2),
                                                                    libre(Jugador, X2, Y2, Anterior, NuevoTablero, Estado),
                                                                    Estado < 2, actualizarTablero(X, Y, X2, Y2, NuevoTablero, Actual).                                                                    


/*The following predicates allow the unification of variable "actual" with a board updated with a possible move of the
piece currently in [X, Y]. If another solution is needed, the predicate checks if the piece can keep moving in the 
same direction */

/*VMa: Vertical Más */
moverVMa(_, [X, Y], [X2, Y], _, Estado, Anterior, Actual)    :- Estado == 0, 
                                                                actualizarTablero(X, Y, X2, Y, Anterior, Actual).
moverVMa(Jugador, [X, Y], _, Desp, Estado, Anterior, Actual) :- Estado == 0,
                                                                Desp2 is Desp + 1, X2 is X + Desp2, coordenadas(X2, Y),
                                                                libre(Jugador, X2, Y, Anterior, NuevoTablero, NuevoEstado), 
                                                                moverVMa(Jugador, [X, Y], [X2, Y], Desp2, NuevoEstado, NuevoTablero, Actual).
moverVMa(_, [X, Y], [X2, Y], _, Estado, Anterior, Actual)    :- Estado == 1,
                                                                actualizarTablero(X, Y, X2, Y, Anterior, Actual).
/*VMa: Vertical Menos */
moverVMe(_, [X, Y], [X2, Y], _, Estado, Anterior, Actual)    :- Estado == 0, 
                                                                actualizarTablero(X, Y, X2, Y, Anterior, Actual).
moverVMe(Jugador, [X, Y], _, Desp, Estado, Anterior, Actual) :- Estado == 0, 
                                                                Desp2 is Desp + 1, X2 is X - Desp2, coordenadas(X2, Y), 
                                                                libre(Jugador, X2, Y, Anterior, NuevoTablero, NuevoEstado),
                                                                moverVMe(Jugador, [X, Y], [X2, Y], Desp2, NuevoEstado, NuevoTablero, Actual).                                                                             
moverVMe(_, [X, Y], [X2, Y], _, Estado, Anterior, Actual)    :- Estado == 1, 
                                                                actualizarTablero(X, Y, X2, Y, Anterior, Actual).

/*HMa: Horizontal Más */
moverHMa(_, [X, Y], [X, Y2], _, Estado, Anterior, Actual)     :- Estado == 0, 
                                                                 actualizarTablero(X, Y, X, Y2, Anterior, Actual).
moverHMa(Jugador, [X, Y], _, Desp, Estado, Anterior, Actual)  :- Estado == 0,
                                                                 Desp2 is Desp + 1, Y2 is Y + Desp2, coordenadas(X, Y2), 
                                                                 libre(Jugador, X, Y2, Anterior, NuevoTablero, NuevoEstado),
                                                                 moverHMa(Jugador, [X, Y], [X, Y2], Desp2, NuevoEstado, NuevoTablero, Actual).
moverHMa(_, [X, Y], [X, Y2], _, Estado, Anterior, Actual)     :- Estado == 1, 
                                                                 actualizarTablero(X, Y, X, Y2, Anterior, Actual).                                                            

/*HMe: Horizontal Menos */
moverHMe(_, [X, Y], [X, Y2], _, Estado, Anterior, Actual)    :- Estado == 0, 
                                                                actualizarTablero(X, Y, X, Y2, Anterior, Actual).
moverHMe(Jugador, [X, Y], _, Desp, Estado, Anterior, Actual) :- Estado == 0, 
                                                                Desp2 is Desp + 1, Y2 is Y - Desp2, coordenadas(X, Y2), 
                                                                libre(Jugador, X, Y2, Anterior, NuevoTablero, NuevoEstado),
                                                                moverHMe(Jugador, [X, Y], [X, Y2], Desp2, NuevoEstado, NuevoTablero, Actual).                                                                               
moverHMe(_, [X, Y], [X, Y2], _, Anterior, Estado, Actual)    :- Estado == 1, 
                                                                actualizarTablero(X, Y, X, Y2, Anterior, Actual).

/*DIS: DIagonal Izquierda Superior*/                                                     
moverDIS(_, [X, Y], [X2, Y2], _, Estado, Anterior, Actual)   :- Estado == 0, 
                                                                actualizarTablero(X, Y, X2, Y2, Anterior, Actual).
moverDIS(Jugador, [X, Y], _, Desp, Estado, Anterior, Actual) :- Estado == 0, 
                                                                Desp2 is Desp + 1, X2 is X - Desp2, Y2 is Y - Desp2, coordenadas(X2, Y2),
                                                                libre(Jugador, X2, Y2, Anterior, NuevoTablero, NuevoEstado),
                                                                moverDIS(Jugador, [X, Y], [X2, Y2], Desp2, NuevoEstado, NuevoTablero, Actual).                                                                                  
moverDIS(_, [X, Y], [X2, Y2], _, Estado, Anterior, Actual)   :- Estado == 1, 
                                                                actualizarTablero(X, Y, X2, Y2, Anterior, Actual).

/*DDS: DIagonal Derecha Superior*/ 
moverDDS(_, [X, Y], [X2, Y2], _, Estado, Anterior, Actual)   :- Estado == 0, 
                                                                actualizarTablero(X, Y, X2, Y2, Anterior, Actual).
moverDDS(Jugador, [X, Y], _, Desp, Estado, Anterior, Actual) :- Estado == 0, 
                                                                Desp2 is Desp + 1, X2 is X - Desp2, Y2 is Y + Desp2, coordenadas(X2, Y2), 
                                                                libre(Jugador, X2, Y2, Anterior, NuevoTablero, NuevoEstado),
                                                                moverDDS(Jugador, [X, Y], [X2, Y2], Desp2, NuevoEstado, NuevoTablero, Actual).
moverDDS(_, [X, Y], [X2, Y2], _, Estado, Anterior, Actual)   :- Estado == 1, 
                                                                actualizarTablero(X, Y, X2, Y2, Anterior, Actual).

/*DII: DIagonal Izquierda inferior*/ 
moverDII(_, [X, Y], [X2, Y2], _, Estado, Anterior, Actual)   :- Estado == 0, 
                                                                actualizarTablero(X, Y, X2, Y2, Anterior, Actual).
moverDII(Jugador, [X, Y], _, Desp, Estado, Anterior, Actual) :- Estado == 0,
                                                                Desp2 is Desp + 1, X2 is X + Desp2, Y2 is Y - Desp2, coordenadas(X2, Y2),
                                                                libre(Jugador, X2, Y2, Anterior, NuevoTablero, NuevoEstado), 
                                                                moverDII(Jugador, [X, Y], [X2, Y2], Desp2, NuevoEstado, NuevoTablero, Actual).
moverDII(_, [X, Y], [X2, Y2], _, Estado, Anterior, Actual)   :- Estado == 1, 
                                                                actualizarTablero(X, Y, X2, Y2, Anterior, Actual).

/*DDI: DIagonal Derecha inferior*/ 
moverDDI(_, [X, Y], [X2, Y2], _, Estado, Anterior, Actual)   :- Estado == 0, 
                                                                actualizarTablero(X, Y, X2, Y2, Anterior, Actual).
moverDDI(Jugador, [X, Y], _, Desp, Estado, Anterior, Actual) :- Estado == 0, 
                                                                Desp2 is Desp + 1, X2 is X + Desp2, Y2 is Y + Desp2, coordenadas(X2, Y2),
                                                                libre(Jugador, X2, Y2, Anterior, NuevoTablero, NuevoEstado),
                                                                moverDDI(Jugador, [X, Y], [X2, Y2], Desp2, NuevoEstado, NuevoTablero, Actual).
moverDDI(_, [X, Y], [X2, Y2], _, Estado, Anterior, Actual)   :- Estado == 1, 
                                                                actualizarTablero(X, Y, X2, Y2, Anterior, Actual).

jaque(Jugador, Tablero) :- estadoTablero(Tablero), pieza(rey, Jugador, X, Y), jaqueAux([X, Y], Jugador).

jaqueAux([X, Y], Jugador) :- X2 is X + 1, coordenadas(X2, Y), piezaVH([X2, Y], Jugador, 1, Estado),
                          jaqueVMa([X, Y], Jugador, 1, Estado).
jaqueAux([X, Y], Jugador) :- X2 is X - 1, coordenadas(X2, Y), piezaVH([X2, Y], Jugador, 1, Estado),
                          jaqueVMe([X, Y], Jugador, 1, Estado).
jaqueAux([X, Y], Jugador) :- Y2 is Y + 1, coordenadas(X, Y2), piezaVH([X, Y2], Jugador, 1, Estado),
                          jaqueHMa([X, Y], Jugador, 1, Estado).
jaqueAux([X, Y], Jugador) :- Y2 is Y - 1, coordenadas(X, Y2), piezaVH([X, Y2], Jugador, 1, Estado),
                          jaqueHMe([X, Y], Jugador, 1, Estado).
jaqueAux([X, Y], Jugador) :- X2 is X - 1, Y2 is Y - 1, coordenadas(X2, Y2), piezaDiagonal([X2,Y2], Jugador, 1, Estado),
                          jaqueDIS([X, Y], Jugador, 1, Estado).
jaqueAux([X, Y], Jugador) :- Jugador = blancas, X2 is X - 1, Y2 is Y - 1, coordenadas(X2, Y2), pieza(peon, negras, X2, Y2).
jaqueAux([X, Y], Jugador) :- X2 is X - 1, Y2 is Y + 1, coordenadas(X2, Y2), piezaDiagonal([X2,Y2], Jugador, 1, Estado),
                          jaqueDDS([X, Y], Jugador, 1, Estado).
jaqueAux([X, Y], Jugador) :- Jugador = blancas, X2 is X - 1, Y2 is Y + 1, coordenadas(X2, Y2), pieza(peon, negras, X2, Y2).
jaqueAux([X, Y], Jugador) :- X2 is X + 1, Y2 is Y - 1, coordenadas(X2, Y2), piezaDiagonal([X2,Y2], Jugador, 1, Estado),
                          jaqueDII([X, Y], Jugador, 1, Estado).
jaqueAux([X, Y], Jugador) :- Jugador = negras, X2 is X + 1, Y2 is Y - 1, coordenadas(X2, Y2), pieza(peon, blancas, X2, Y2).
jaqueAux([X, Y], Jugador) :- X2 is X + 1, Y2 is Y + 1, coordenadas(X2, Y2), piezaDiagonal([X2,Y2], Jugador, 1, Estado),
                          jaqueDDI([X, Y], Jugador, 1, Estado).
jaqueAux([X, Y], Jugador) :- Jugador = negras, X2 is X + 1, Y2 is Y + 1, coordenadas(X2, Y2), pieza(peon, blancas, X2, Y2).
jaqueAux([X, Y], Jugador) :- Movimientos = [[-2, 1], [-1, 2], [1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1]],
                          getElement(Movimientos, [DespX, DespY]), X2 is X + DespX, Y2 is Y + DespY, coordenadas(X2, Y2),
                          pieza(caballo, J, X2, Y2), J \= Jugador.


jaqueVMa(_, _, _, Estado)               :- Estado = jaqueado.
jaqueVMa([X, Y], Jugador, Desp, Estado) :- Estado = continuar, 
                                           Desp2 is Desp + 1, X2 is X + Desp2, coordenadas(X2, Y), 
                                           piezaVH([X2, Y], Jugador, Desp2, Estado2), jaqueVMa([X, Y], Jugador, Desp2, Estado2).

jaqueVMe(_, _, _, Estado)               :- Estado = jaqueado.
jaqueVMe([X, Y], Jugador, Desp, Estado) :- Estado = continuar, 
                                           Desp2 is Desp + 1, X2 is X - Desp2, coordenadas(X2, Y), 
                                           piezaVH([X2, Y], Jugador, Desp2, Estado2), jaqueVMe([X, Y], Jugador, Desp2, Estado2).

jaqueHMa(_, _, _, Estado)               :- Estado = jaqueado.
jaqueHMa([X, Y], Jugador, Desp, Estado) :- Estado = continuar,
                                           Desp2 is Desp + 1, Y2 is Y + Desp2, coordenadas(X, Y2), 
                                           piezaVH([X, Y2], Jugador, Desp2, Estado2), jaqueHMa([X, Y], Jugador, Desp2, Estado2).

jaqueHMe(_, _, _, Estado)               :- Estado = jaqueado.
jaqueHMe([X, Y], Jugador, Desp, Estado) :- Estado = continuar,
                                           Desp2 is Desp + 1, Y2 is Y - Desp2, coordenadas(X, Y2), 
                                           piezaVH([X, Y2], Jugador, Desp2, Estado2), jaqueHMe([X, Y], Jugador, Desp2, Estado2).

jaqueDIS(_, _, _, Estado)               :- Estado = jaqueado.
jaqueDIS([X, Y], Jugador, Desp, Estado) :- Estado = continuar, 
                                           Desp2 is Desp + 1, X2 is X - Desp2, Y2 is Y - Desp2, coordenadas(X2, Y2),
                                           piezaDiagonal([X2,Y2], Jugador, Desp2, Estado2), jaqueDIS([X, Y], Jugador, Desp2, Estado2).

jaqueDDS(_, _, _, Estado)               :- Estado = jaqueado.
jaqueDDS([X, Y], Jugador, Desp, Estado) :- Estado = continuar, 
                                           Desp2 is Desp + 1, X2 is X - Desp2, Y2 is Y + Desp2, coordenadas(X2, Y2),
                                           piezaDiagonal([X2,Y2], Jugador, Desp2, Estado2), jaqueDDS([X, Y], Jugador, Desp2, Estado2).

jaqueDII(_, _, _, Estado)               :- Estado = jaqueado.
jaqueDII([X, Y], Jugador, Desp, Estado) :- Estado = continuar, 
                                           Desp2 is Desp + 1, X2 is X + Desp2, Y2 is Y - Desp2, coordenadas(X2, Y2),
                                           piezaDiagonal([X2,Y2], Jugador, Desp2, Estado2), jaqueDII([X, Y], Jugador, Desp2, Estado2).

jaqueDDI(_, _, _, Estado)               :- Estado = jaqueado.
jaqueDDI([X, Y], Jugador, Desp, Estado) :- Estado = continuar, 
                                           Desp2 is Desp + 1, X2 is X + Desp2, Y2 is Y + Desp2, coordenadas(X2, Y2),
                                           piezaDiagonal([X2,Y2], Jugador, Desp2, Estado2), jaqueDDI([X, Y], Jugador, Desp2, Estado2).

piezaVH([X, Y], Jugador, _, Estado) :- pieza(torre, J, X, Y), J \= Jugador, Estado = jaqueado.
piezaVH([X, Y], Jugador, _, Estado) :- pieza(dama, J, X, Y), J \= Jugador, Estado = jaqueado.
piezaVH([X, Y], Jugador, Desp, Estado) :- Desp = 1, pieza(rey, J, X, Y), J \= Jugador, Estado = jaqueado.
piezaVH([X, Y], Jugador, Desp, Estado) :- Desp > 1, pieza(rey, J, X, Y), J \= Jugador, Estado = bloqueado.
piezaVH([X, Y], Jugador, _, Estado) :- pieza(peon, J, X, Y), J \= Jugador, Estado = bloqueado.
piezaVH([X, Y], Jugador, _, Estado) :- pieza(alfil, J, X, Y), J \= Jugador, Estado = bloqueado.
piezaVH([X, Y], Jugador, _, Estado) :- pieza(caballo, J, X, Y), J \= Jugador, Estado = bloqueado.
piezaVH([X, Y], Jugador, _, Estado) :- pieza(_, Jugador, X, Y), Estado = bloqueado.
piezaVH([X, Y], _, _, Estado) :- not(pieza(_, _, X, Y)), Estado = continuar.

piezaDiagonal([X, Y], Jugador, _, Estado) :- pieza(alfil, J, X, Y), J \= Jugador, Estado = jaqueado.
piezaDiagonal([X, Y], Jugador, _, Estado) :- pieza(dama, J, X, Y), J \= Jugador, Estado = jaqueado.
piezaDiagonal([X, Y], Jugador, Desp, Estado) :- Desp = 1, pieza(rey, J, X, Y), J \= Jugador, Estado = jaqueado.
piezaDiagonal([X, Y], Jugador, Desp, Estado) :- Desp > 1, pieza(rey, J, X, Y), J \= Jugador, Estado = bloqueado.
piezaDiagonal([X, Y], Jugador, _, Estado) :- pieza(peon, J, X, Y), J \= Jugador, Estado = bloqueado.
piezaDiagonal([X, Y], Jugador, _, Estado) :- pieza(torre, J, X, Y), J \= Jugador, Estado = bloqueado.
piezaDiagonal([X, Y], Jugador, _, Estado) :- pieza(caballo, J, X, Y), J \= Jugador, Estado = bloqueado.
piezaDiagonal([X, Y], Jugador, _, Estado) :- pieza(_, Jugador, X, Y), Estado = bloqueado.
piezaDiagonal([X, Y], _, _, Estado) :- not(pieza(_, _, X, Y)), Estado = continuar.

mate(Jugador, Tablero) :- not(mover(Jugador, Tablero, _)).

/********************************************* FOURTH PART ************************************************/

otroJugador(negras, X) :- X = blancas.
otroJugador(blancas, X) :- X = negras.

puedeGanar(Jugador,Actual,Final,1) :- otroJugador(Jugador, OtroJugador), mover(Jugador,Actual,Temp), mate(OtroJugador, Temp), 
                                      Final = Temp.
puedeGanar(Jugador,Actual,Final,N) :- number(N), N > 1, otroJugador(Jugador, OtroJugador), mover(Jugador, Actual, Temp), 
                                      (mate(OtroJugador, Temp), Final = Temp;
                                      mover(OtroJugador, Temp, Temp2),M is N - 1, puedeGanar(Jugador,Temp2,Final,M)).
puedeGanar(Jugador,Actual,Final,N) :- var(N), puedeGanarAux(Jugador, Actual, Final, 1).

puedeGanarAux(Jugador,Actual,Final,N) :- puedeGanar(Jugador,Actual,Final,N).
puedeGanarAux(Jugador,Actual,Final,N) :- M is N + 1, puedeGanarAux(Jugador,Actual,Final,M).
puedeGanarAux(_,_,_,N) :- N = 5899, fail. % Número máximo de movimientos en toería bajo la regla de los 50 movimientos


/********************************************* FIFTH PART ************************************************/

% Gets from the user the path of the file containing the board and then adds each row to the board, leaves the result unified in Tablero
leer(Tablero) :- write('De el nombre del archivo sin ninguna extension: \n'), read(FileNameAtom), atom_string(FileNameAtom, FileName), open(FileName, read, Str), 
                 read_string(Str, "\n", "", _, _), read_string(Str, "\n", "", _, SetRow1),  split_string(SetRow1, "|", "", List1),
                 read_string(Str, "\n", "", _, _), read_string(Str, "\n", "", _, SetRow2),  split_string(SetRow2, "|", "", List2), 
                 read_string(Str, "\n", "", _, _), read_string(Str, "\n", "", _, SetRow3),  split_string(SetRow3, "|", "", List3), 
                 read_string(Str, "\n", "", _, _), read_string(Str, "\n", "", _, SetRow4),  split_string(SetRow4, "|", "", List4), 
                 read_string(Str, "\n", "", _, _), read_string(Str, "\n", "", _, SetRow5),  split_string(SetRow5, "|", "", List5), 
                 read_string(Str, "\n", "", _, _), read_string(Str, "\n", "", _, SetRow6),  split_string(SetRow6, "|", "", List6), 
                 read_string(Str, "\n", "", _, _), read_string(Str, "\n", "", _, SetRow7),  split_string(SetRow7, "|", "", List7), 
                 read_string(Str, "\n", "", _, _), read_string(Str, "\n", "", _, SetRow8),  split_string(SetRow8, "|", "", List8),  
                 close(Str), 
                 agregarATablero(Fila1, List1, 1, 1), agregarATablero(Fila2, List2, 2, 1), agregarATablero(Fila3, List3, 3, 1),
                 agregarATablero(Fila4, List4, 4, 1), agregarATablero(Fila5, List5, 5, 1), agregarATablero(Fila6, List6, 6, 1),
                 agregarATablero(Fila7, List7, 7, 1), agregarATablero(Fila8, List8, 8, 1),
                 append(Fila1, Fila2, Fila12), append(Fila12, Fila3, Fila13), append(Fila13, Fila4, Fila14), 
                 append(Fila14, Fila5, Fila15), append(Fila15, Fila6, Fila16), append(Fila16, Fila7, Fila17),
                 append(Fila17, Fila8, Tablero).

% Unifies in the variable Tablero the information of the given row
agregarATablero(Tablero, ["  "|Lista], Fila, Columna) :- R is Fila, C is Columna, CN is C+1, agregarATablero(TableroAux, Lista, R, CN), append([], TableroAux, Tablero).
agregarATablero(Tablero, ["  "], _, _) :- append([], [], Tablero).
agregarATablero(Tablero, [" "|Lista], Fila, Columna) :- R is Fila, C is Columna, CN is C+1, agregarATablero(TableroAux, Lista, R, CN), append([], TableroAux, Tablero).
agregarATablero(Tablero, [" "], _, _) :- append([], [], Tablero).
agregarATablero(Tablero, [""|Lista], Fila, Columna) :- R is Fila, C is Columna, CN is C+1, agregarATablero(TableroAux, Lista, R, CN), append([], TableroAux, Tablero).
agregarATablero(Tablero, [""], _, _) :- append([], [], Tablero).

agregarATablero(Tablero, ["PN"|Lista], Fila, Columna) :- R is Fila, C is Columna, CN is C+1, agregarATablero(TableroAux, Lista, R, CN), append([peon(negras, R, C)], TableroAux, Tablero).
agregarATablero(Tablero, ["CN"|Lista], Fila, Columna) :- R is Fila, C is Columna, CN is C+1, agregarATablero(TableroAux, Lista, R, CN), append([caballo(negras, R, C)], TableroAux, Tablero).
agregarATablero(Tablero, ["AN"|Lista], Fila, Columna) :- R is Fila, C is Columna, CN is C+1, agregarATablero(TableroAux, Lista, R, CN), append([alfil(negras, R, C)], TableroAux, Tablero).
agregarATablero(Tablero, ["TN"|Lista], Fila, Columna) :- R is Fila, C is Columna, CN is C+1, agregarATablero(TableroAux, Lista, R, CN), append([torre(negras, R, C)], TableroAux, Tablero).
agregarATablero(Tablero, ["DN"|Lista], Fila, Columna) :- R is Fila, C is Columna, CN is C+1, agregarATablero(TableroAux, Lista, R, CN), append([dama(negras, R, C)], TableroAux, Tablero).
agregarATablero(Tablero, ["RN"|Lista], Fila, Columna) :- R is Fila, C is Columna, CN is C+1, agregarATablero(TableroAux, Lista, R, CN), append([rey(negras, R, C)], TableroAux, Tablero).

agregarATablero(Tablero, ["PN"], Fila, Columna) :- R is Fila, C is Columna, append([], [peon(negras, R, C)], Tablero).
agregarATablero(Tablero, ["CN"], Fila, Columna) :- R is Fila, C is Columna, append([], [caballo(negras, R, C)], Tablero).
agregarATablero(Tablero, ["AN"], Fila, Columna) :- R is Fila, C is Columna, append([], [alfil(negras, R, C)], Tablero).
agregarATablero(Tablero, ["TN"], Fila, Columna) :- R is Fila, C is Columna, append([], [torre(negras, R, C)], Tablero).
agregarATablero(Tablero, ["DN"], Fila, Columna) :- R is Fila, C is Columna, append([], [dama(negras, R, C)], Tablero).
agregarATablero(Tablero, ["RN"], Fila, Columna) :- R is Fila, C is Columna, append([], [rey(negras, R, C)], Tablero).

agregarATablero(Tablero, ["PB"|Lista], Fila, Columna) :- R is Fila, C is Columna, CN is C+1, agregarATablero(TableroAux, Lista, R, CN), append([peon(blancas, R, C)], TableroAux, Tablero).
agregarATablero(Tablero, ["CB"|Lista], Fila, Columna) :- R is Fila, C is Columna, CN is C+1, agregarATablero(TableroAux, Lista, R, CN), append([caballo(blancas, R, C)], TableroAux, Tablero).
agregarATablero(Tablero, ["AB"|Lista], Fila, Columna) :- R is Fila, C is Columna, CN is C+1, agregarATablero(TableroAux, Lista, R, CN), append([alfil(blancas, R, C)], TableroAux, Tablero).
agregarATablero(Tablero, ["TB"|Lista], Fila, Columna) :- R is Fila, C is Columna, CN is C+1, agregarATablero(TableroAux, Lista, R, CN), append([torre(blancas, R, C)], TableroAux, Tablero).
agregarATablero(Tablero, ["DB"|Lista], Fila, Columna) :- R is Fila, C is Columna, CN is C+1, agregarATablero(TableroAux, Lista, R, CN), append([dama(blancas, R, C)], TableroAux, Tablero).
agregarATablero(Tablero, ["RB"|Lista], Fila, Columna) :- R is Fila, C is Columna, CN is C+1, agregarATablero(TableroAux, Lista, R, CN), append([rey(blancas, R, C)], TableroAux, Tablero).

agregarATablero(Tablero, ["PB"], Fila, Columna) :- R is Fila, C is Columna, append([], [peon(blancas, R, C)], Tablero).
agregarATablero(Tablero, ["CB"], Fila, Columna) :- R is Fila, C is Columna, append([], [caballo(blancas, R, C)], Tablero).
agregarATablero(Tablero, ["AB"], Fila, Columna) :- R is Fila, C is Columna, append([], [alfil(blancas, R, C)], Tablero).
agregarATablero(Tablero, ["TB"], Fila, Columna) :- R is Fila, C is Columna, append([], [torre(blancas, R, C)], Tablero).
agregarATablero(Tablero, ["DB"], Fila, Columna) :- R is Fila, C is Columna, append([], [dama(blancas, R, C)], Tablero).
agregarATablero(Tablero, ["RB"], Fila, Columna) :- R is Fila, C is Columna, append([], [rey(blancas, R, C)], Tablero).
