;(deftemplate turno (slot turno_de))
;(deftemplate pieza (slot jugador)(slot numpieza1)(slot numpieza2))
;(deftemplate piezaR (slot jugador)(slot idPieza))
;(deftemplate juego (slot numero))
;(deftemplate npiezas (slot jugador)(slot cantidad))
;(deftemplate pasadas (slot seguidas))


;FUNCION PARA REPARTIR PIEZAS ENTRE 4 JUGADORES
(deffunction repartir
(?npiezas ?players ?cantidad)
(bind $?lista (create$ 0))
(printout t "INICIANDO REPARTO DE PIEZAS..." crlf)
(loop-for-count (?i 1 ?npiezas) do
(bind $?lista (insert$ $?lista ?i ?i))
)
(loop-for-count (?j 1 ?players) do
;(printout t "Lista --> " $?lista " = " (length $?lista) crlf)
(loop-for-count (?i 1 ?cantidad) do
(bind ?r (random 1 (- (length $?lista) 1)))
(assert (piezaR ?j (nth$ ?r $?lista)))
(printout t "Jugador: " ?j " --> Piezas " (nth$ ?r $?lista) crlf)
(bind $?lista (delete$ $?lista ?r ?r))
)
(printout t "---------------------" crlf)
(assert (npiezas ?j ?cantidad))
)
(printout t "COMIENZA EL JUEGO!" crlf)
)

;FUNCION PARA TRADUCIR ID EN PIEZAS


;FUNCION PARA RECUENTO DE PUNTOS


;Empezar partida y repartir piezas
(defrule R1 (declare (salience 10000))
?j <- (juego -1)
=>
(retract ?j)
(repartir 28 4 7)
(assert (juego 0))
)


(defrule R2 (declare (salience 10000))
(npiezas ?jugador 0) ;si un jugador tiene cero cartas ha ganado la partida
=>
(printout t "El jugador " ?jugador " gana la partida!" crlf)
(halt) ;detiene el juego
)

;Cuando pasan todos se acaba porque no hay movimientos se tienen que contar la puntuacion
(defrule R3 (declare (salience 10000))
(pasadas 4)
=>
;funcion recuento puntos
(halt)
)

;Gestion de turnos
(defrule R3 (declare (salience 8000))
?t <- (turno 4)
=>
(assert (turno 1))
(retract ?t)
)


;Empieza el jugador con la pieza de doble 6
(defrule R3 (declare (salience 7000))
?j <- (juego 0)
?t <- (turno ?turno)
?p <- (pieza ?turno 6 6)
?h <- (extremos ?e1 ?e2)
?n <- (npiezas ?turno ?np)
=>
(printout t "El jugador " ?turno " inicia el juego con la pieza 6,6!" crlf)
(assert (extremos 6 6))
(assert (turno (+ 1 ?turno)))
(assert (npiezas ?turno (- ?np 1)))
(assert (juego 1))
(retract ?j ?t ?p ?h ?n)
)

;se comprueba si el primer numero de cada pieza del jugador coincide
;con el primer numero de las fichas colocadas
(defrule R4 (declare (salience 5000))
?t <- (turno ?turno)
?p <- (pieza ?turno ?valor ?n2)
?h <- (extremos ?valor ?e2)
?n <- (npiezas ?turno ?np)
?s <- (pasadas ?seguidas)
=>
(printout t "El jugador " ?turno " pone la carta " ?valor "," ?n2 crlf)
(assert (extremos (?e2 ?n2)))
(assert (turno (+ 1 ?turno)))
(assert (npiezas ?turno (- ?np 1)))
(assert (pasadas 0))
(retract ?t ?p ?h ?n ?s) ;DUDA no se si hacer retract de los extremos
)


(defrule R5 (declare (salience 5000))
?t <- (turno ?turno)
?p <- (pieza ?turno ?n1 ?valor)
?h <- (extremos ?valor ?e2)
?n <- (npiezas ?turno ?np)
?s <- (pasadas ?seguidas)
=>
(printout t "El jugador " ?turno " pone la carta " ?n1 "," ?valor crlf)
(assert (extremos (?n1 ?e2)))
(assert (turno (+ 1 ?turno)))
(assert (npiezas ?turno (- ?np 1)))
(assert (pasadas 0))
(retract ?t ?p ?h ?n ?s) ;DUDA no se si hacer retract de los extremos
)


(defrule R6 (declare (salience 5000))
?t <- (turno ?turno)
?p <- (pieza ?turno ?valor ?n2)
?h <- (extremos ?e1 ?valor)
?n <- (npiezas ?turno ?np)
?s <- (pasadas ?seguidas)
=>
(printout t "El jugador " ?turno " pone la carta " ?valor "," ?n2 crlf)
(assert (extremos (?e1 ?n2)))
(assert (turno (+ 1 ?turno)))
(assert (npiezas ?turno (- ?np 1)))
(assert (pasadas 0))
(retract ?t ?p ?h ?n ?s) ;DUDA no se si hacer retract de los extremos
)


(defrule R7 (declare (salience 5000))
?t <- (turno ?turno)
?p <- (pieza ?turno ?n1 ?valor)
?h <- (extremos ?e1 ?valor)
?n <- (npiezas ?turno ?np)
?s <- (pasadas ?seguidas)
=>
(printout t "El jugador " ?turno " pone la carta " ?n1 "," ?valor crlf)
(assert (extremos (?n1 ?e1)))
(assert (turno (+ 1 ?turno)))
(assert (npiezas ?turno (- ?np 1)))
(assert (pasadas 0))
(retract ?t ?p ?h ?n ?s) ;DUDA no se si hacer retract de los extremos
)

;Pasa turno porque no ha podido hacer movimientos
(defrule R8 (declare (salience 0))
?t <- (turno ?turno)
?s <- (pasadas ?seguidas)
=>
(printout t "El jugador " ?turno " pasa turno!" crlf)
(assert (turno (+ 1 ?turno)))
(assert (pasadas (+ 1 ?seguidas)))
(retract ?t ?s)
)
