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

getElement([X|_], X).
getElement([_|T], X) :- getElement(T, X).

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

coronacion(X, Y, X2, Y2, [peon(J, X, Y)|T], Actual) :- Actual = [torre(J, X2, Y2)|T].
coronacion(X, Y, X2, Y2, [peon(J, X, Y)|T], Actual) :- Actual = [alfil(J, X2, Y2)|T].
coronacion(X, Y, X2, Y2, [peon(J, X, Y)|T], Actual) :- Actual = [dama(J, X2, Y2)|T].
coronacion(X, Y, X2, Y2, [peon(J, X, Y)|T], Actual) :- Actual = [caballo(J, X2, Y2)|T].
coronacion(X, Y, X2, Y2, [H|T], Actual) :- coronacion(X, Y, X2, Y2, T, Actual2), Actual = [H|Actual2]. 

/* DIS: DIagonal Izquierda Superior
   DDS: Diagonal Derecha Superior
   DII: Diagonal Izquierda Inferior
   DDI: Diagonal Derecha Superior*/
                                                                          
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


mover(Jugador, Anterior, Actual) :- buscarPeon(Jugador, Anterior, Peon), moverPeon(Jugador, Peon, Anterior, Actual).
mover(Jugador, Anterior, Actual) :- buscarTorre(Jugador, Anterior, Torre), moverTorre(Jugador, Torre, 1, Anterior, Actual).
mover(Jugador, Anterior, Actual) :- buscarAlfil(Jugador, Anterior, Alfil), moverAlfil(Jugador, Alfil, 1, Anterior, Actual).
mover(Jugador, Anterior, Actual) :- buscarDama(Jugador, Anterior, Dama), moverTorre(Jugador, Dama, 1, Anterior, Actual).
mover(Jugador, Anterior, Actual) :- buscarDama(Jugador, Anterior, Dama), moverAlfil(Jugador, Dama, 1, Anterior, Actual).
mover(Jugador, Anterior, Actual) :- buscarCaballo(Jugador, Anterior, Caballo), 
                                    Movimientos = [[-2, 1], [-1, 2], [1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1]],
                                    moverPieza(Jugador, Caballo, Movimientos, Anterior, Actual).
mover(Jugador, Anterior, Actual) :- buscarRey(Jugador, Anterior, Rey), 
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

moverPieza(Jugador, [X, Y], Movimientos, Anterior, Actual) :- getElement(Movimientos, [DespX, DespY]), 
                                                              moverAux(Jugador, [X, Y], [DespX, DespY], Anterior, Actual).

moverAux(Jugador, [X, Y], [DespX, DespY], Anterior, Actual) :- X2 is X + DespX, Y2 is Y + DespY, coordenadas(X2, Y2),
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
                                                                moverDDS(Jugador, [X, Y], [X2, Y], Desp2, NuevoEstado, NuevoTablero, Actual).
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
/* moverTorre(negras, [1,1], 1, [torre(negras,1,1),peon(negras,2,2),peon(negras,2,4),rey(negras,1,4),
caballo(negras,4,6),rey(blancas,8,5),peon(blancas,7,5),dama(blancas,6,4), torre(blancas, 3, 1)], Actual).

moverAlfil(blancas, [5, 5], 1, [alfil(blancas, 5, 5), torre(negras,1,1),peon(negras,2,2),peon(negras,2,4),rey(negras,1,4),
caballo(negras,4,6),rey(blancas,8,5)], Actual).

moverPieza(negras, [4,4], [[-2, 1], [-1, 2], [1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1]], [caballo(negras, 4, 4)], Actual) 

moverPeon(negras, [2, 4], [alfil(blancas, 3, 5), torre(negras,1,1),peon(negras,7,2),peon(negras,2,4),rey(negras,1,4),
caballo(negras,4,6),rey(blancas,8,5)], Actual). */