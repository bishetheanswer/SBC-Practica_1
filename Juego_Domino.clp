;(deftemplate turno (slot turno_de))
;(deftemplate pieza (slot jugador)(slot numpieza1)(slot numpieza2))
;(deftemplate juego (slot numero))
;(deftemplate npiezas (slot jugador)(slot cantidad))


;Empezar partida y repartir piezas
(defrule R1 (declare (salience 10000))
?j <- (juego -1)
=>
(retract ?j)
;meter funcion para repartir
(assert (juego 0))
)


;Gestion de turnos
(defrule R2 (declare (salience 8000))
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
=>
(printout t "El jugador " ?turno " pone la carta " ?valor "," ?n2 crlf)
(assert (extremos (?valor ?n2)))
(assert (turno (+ 1 ?turno)))
(assert (npiezas ?turno (- ?np 1)))
(retract ?t ?p ?h ?n) ;DUDA no se si hacer retract de los extremos
)


(defrule R5 (declare (salience 5000))
?t <- (turno ?turno)
?p <- (pieza ?turno ?n1 ?valor)
?h <- (extremos ?valor ?e2)
?n <- (npiezas ?turno ?np)
=>
(printout t "El jugador " ?turno " pone la carta " ?n1 "," ?valor crlf)
(assert (extremos (?n1 ?valor)))
(assert (turno (+ 1 ?turno)))
(assert (npiezas ?turno (- ?np 1)))
(retract ?t ?p ?h ?n)
)


(defrule R6 (declare (salience 5000))
?t <- (turno ?turno)
?p <- (pieza ?turno ?valor ?n2)
?h <- (extremos ?e1 ?valor)
?n <- (npiezas ?turno ?np)
=>
(printout t "El jugador " ?turno " pone la carta " ?valor "," ?n2 crlf)
(assert (extremos (?valor ?n2)))
(assert (turno (+ 1 ?turno)))
(assert (npiezas ?turno (- ?np 1)))
(retract ?t ?p ?h ?n)
)


(defrule R7 (declare (salience 5000))
?t <- (turno ?turno)
?p <- (pieza ?turno ?n1 ?valor)
?h <- (extremos ?e1 ?valor)
?n <- (npiezas ?turno ?np)
=>
(printout t "El jugador " ?turno " pone la carta " ?n1 "," ?valor crlf)
(assert (extremos (?n1 ?valor)))
(assert (turno (+ 1 ?turno)))
(assert (npiezas ?turno (- ?np 1)))
(retract ?t ?p ?h ?n)
)