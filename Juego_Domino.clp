;(deftemplate turno (slot turno_de))
;(deftemplate extremos (slot ext1)(slot ext2))
;(deftemplate pieza (slot jugador)(slot numpieza1)(slot numpieza2))
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
(printout t "Lista --> " $?lista " = " (length $?lista) crlf)
(loop-for-count (?i 1 ?cantidad) do
(bind ?r (random 1 (- (length $?lista) 1)))
(if (>= (nth$ ?r $?lista) 22) 
 then
 (assert (pieza ?j 6 (- (nth$ ?r $?lista) 22)))
 (printout t "Jugador: " ?j " --> Piezas [6," (- (nth$ ?r $?lista) 22) "]" crlf)
 else
 (if (and (< (nth$ ?r $?lista) 22)(>= (nth$ ?r $?lista) 16)) 
  then
  (assert (pieza ?j 5 (- (nth$ ?r $?lista) 16)))
  (printout t "Jugador: " ?j " --> Piezas [5," (- (nth$ ?r $?lista) 16) "]" crlf)
  else
  (if (and (< (nth$ ?r $?lista) 16)(>= (nth$ ?r $?lista) 11)) 
   then
   (assert (pieza ?j 4 (- (nth$ ?r $?lista) 11)))
   (printout t "Jugador: " ?j " --> Piezas [4," (- (nth$ ?r $?lista) 11) "]" crlf)
   else
   (if (and (< (nth$ ?r $?lista) 11)(>= (nth$ ?r $?lista) 7)) 
    then
    (assert (pieza ?j 3 (- (nth$ ?r $?lista) 7)))
    (printout t "Jugador: " ?j " --> Piezas [3," (- (nth$ ?r $?lista) 7) "]" crlf)
    else
    (if (and (< (nth$ ?r $?lista) 7)(>= (nth$ ?r $?lista) 4)) 
     then
     (assert (pieza ?j 2 (- (nth$ ?r $?lista) 4)))
     (printout t "Jugador: " ?j " --> Piezas [2," (- (nth$ ?r $?lista) 4) "]" crlf)
     else
     (if (or (eq (nth$ ?r $?lista) 3)(eq (nth$ ?r $?lista) 2)) 
      then
      (assert (pieza ?j 1 (- (nth$ ?r $?lista) 2)))
      (printout t "Jugador: " ?j " --> Piezas [1," (- (nth$ ?r $?lista) 2) "]" crlf)
      else
       (assert (pieza ?j 0 (- (nth$ ?r $?lista) 1)))
       (printout t "Jugador: " ?j " --> Piezas [0," (- (nth$ ?r $?lista) 1) "]" crlf)
))))))
(bind $?lista (delete$ $?lista ?r ?r))
)
(printout t "---------------------" crlf)
(assert (npiezas ?j ?cantidad))
)
(printout t "COMIENZA EL JUEGO!" crlf)
)


;Empezar partida y repartir piezas
(defrule R1 (declare (salience 10000))
?j <- (juego -1)
=>
(retract ?j)
(repartir 28 4 7)
(assert (juego 0))
)


(defrule R2 (declare (salience 9000))
(npiezas ?jugador 0) ;si un jugador tiene cero cartas ha ganado la partida
=>
(printout t "El jugador " ?jugador " gana la partida!" crlf)
(halt) ;detiene el juego
)

;Cuando pasan todos se acaba porque no hay movimientos se tienen que contar la puntuacion
(defrule R3 (declare (salience 9000))
(pasadas 4)
=>
;funcion recuento puntos
(halt)
)

;Gestion de turnos
(defrule R4 (declare (salience 8000))
?t <- (turno 5)
=>
(assert (turno 1))
(retract ?t)
)


;Empieza el jugador con la pieza de doble 6
(defrule R5 (declare (salience 7000))
?j <- (juego 0)
?t <- (turno ?turno)
?p <- (pieza ?turno 6 6)
?h <- (extremos ?e1 ?e2)
?n <- (npiezas ?turno ?np)
=>
(printout t "El jugador " ?turno " inicia el juego con la pieza [6,6]!" crlf)
(assert (extremos 6 6))
(assert (turno (+ 1 ?turno)))
(assert (npiezas ?turno (- ?np 1)))
(assert (juego 1))
(retract ?j ?t ?p ?h ?n)
)

;se comprueba si el primer numero de cada pieza del jugador coincide
;con el primer numero de las fichas colocadas
(defrule R6 (declare (salience 5000))
?t <- (turno ?turno)
?p <- (pieza ?turno ?valor ?n2)
?h <- (extremos ?valor ?e2)
?n <- (npiezas ?turno ?np)
?s <- (pasadas ?seguidas)
=>    
(printout t "El jugador " ?turno " pone la pieza [" ?valor "," ?n2 "]" crlf)
(assert (extremos ?n2 ?e2))
(assert (turno (+ 1 ?turno)))
(assert (npiezas ?turno (- ?np 1)))
(assert (pasadas 0))
(retract ?t ?p ?h ?n ?s)
)


(defrule R7 (declare (salience 5000))
?t <- (turno ?turno)
?p <- (pieza ?turno ?n1 ?valor)
?h <- (extremos ?valor ?e2)
?n <- (npiezas ?turno ?np)
?s <- (pasadas ?seguidas)
=>
(printout t "El jugador " ?turno " pone la pieza [" ?n1 "," ?valor "]" crlf)
(assert (extremos ?n1 ?e2))
(assert (turno (+ 1 ?turno)))
(assert (npiezas ?turno (- ?np 1)))
(assert (pasadas 0))
(retract ?t ?p ?h ?n ?s)
)


(defrule R8 (declare (salience 5000))
?t <- (turno ?turno)
?p <- (pieza ?turno ?valor ?n2)
?h <- (extremos ?e1 ?valor)
?n <- (npiezas ?turno ?np)
?s <- (pasadas ?seguidas)
=>
(printout t "El jugador " ?turno " pone la pieza [" ?valor "," ?n2 "]" crlf)
(assert (extremos ?e1 ?n2))
(assert (turno (+ 1 ?turno)))
(assert (npiezas ?turno (- ?np 1)))
(assert (pasadas 0))
(retract ?t ?p ?h ?n ?s)
)


(defrule R9 (declare (salience 5000))
?t <- (turno ?turno)
?p <- (pieza ?turno ?n1 ?valor)
?h <- (extremos ?e1 ?valor)
?n <- (npiezas ?turno ?np)
?s <- (pasadas ?seguidas)
=>
(printout t "El jugador " ?turno " pone la pieza [" ?n1 "," ?valor "]" crlf)
(assert (extremos ?e1 ?n1))
(assert (turno (+ 1 ?turno)))
(assert (npiezas ?turno (- ?np 1)))
(assert (pasadas 0))
(retract ?t ?p ?h ?n ?s)
)

;Pasa turno porque no ha podido hacer movimientos
(defrule R10 (declare (salience 1000))
?t <- (turno ?turno)
?s <- (pasadas ?seguidas)
=>
(printout t "El jugador " ?turno " pasa turno!" crlf)
(assert (turno (+ 1 ?turno)))
(assert (pasadas (+ 1 ?seguidas)))
(retract ?t ?s)
)

(deffacts TURNOS (turno 1))
;Comienza el jugador 1 por defecto, ojo no quiere decir que empiece realmente
(deffacts EXTREMOS (extremos 6 6))
;Tablero inicial
(deffacts INICIO (juego -1))
;Flag estado de juego: -1 = preload, 0 = ini 
(deffacts PASADAS (pasadas 0))
;Comienza el numero de rondas que un jugador ha pasado a 0 por defecto
