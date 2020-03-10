;(deftemplate turno (slot turno_de))
;(deftemplate extremos (slot ext1)(slot ext2))
;(deftemplate pieza (slot jugador)(slot numpieza1)(slot numpieza2)(slot puntos))
;(deftemplate juego (slot numero))
;(deftemplate npiezas (slot jugador)(slot cantidad))
;(deftemplate pasadas (slot seguidas))
;(deftemplate puntos (slot jugador)(slot puntosT))

(defglobal ?*puntos* = 0)
;FUNCION PARA REPARTIR PIEZAS ENTRE 4 JUGADORES
(deffunction repartir
(?npiezas ?players ?cantidad)
(bind $?lista (create$ 0))
(bind ?*puntos* 0)
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
 (bind ?*puntos* (+ ?*puntos* (+ 6 (- (nth$ ?r $?lista) 22))))
 (assert (pieza ?j 6 (- (nth$ ?r $?lista) 22)(+ 6 (- (nth$ ?r $?lista) 22))))
 (printout t "Jugador: " ?j " --> Piezas [6," (- (nth$ ?r $?lista) 22) "]" crlf)
 else
 (if (and (< (nth$ ?r $?lista) 22)(>= (nth$ ?r $?lista) 16)) 
  then
  (bind ?*puntos* (+ ?*puntos* (+ 5 (- (nth$ ?r $?lista) 16))))
  (assert (pieza ?j 5 (- (nth$ ?r $?lista) 16)(+ 5 (- (nth$ ?r $?lista) 16))))
  (printout t "Jugador: " ?j " --> Piezas [5," (- (nth$ ?r $?lista) 16) "]" crlf)
  else
  (if (and (< (nth$ ?r $?lista) 16)(>= (nth$ ?r $?lista) 11)) 
   then
   (bind ?*puntos* (+ ?*puntos* (+ 4 (- (nth$ ?r $?lista) 11))))
   (assert (pieza ?j 4 (- (nth$ ?r $?lista) 11)(+ 4 (- (nth$ ?r $?lista) 11))))
   (printout t "Jugador: " ?j " --> Piezas [4," (- (nth$ ?r $?lista) 11) "]" crlf)
   else
   (if (and (< (nth$ ?r $?lista) 11)(>= (nth$ ?r $?lista) 7)) 
    then
    (bind ?*puntos* (+ ?*puntos* (+ 3 (- (nth$ ?r $?lista) 7))))
    (assert (pieza ?j 3 (- (nth$ ?r $?lista) 7)(+ 3 (- (nth$ ?r $?lista) 7))))
    (printout t "Jugador: " ?j " --> Piezas [3," (- (nth$ ?r $?lista) 7) "]" crlf)
    else
    (if (and (< (nth$ ?r $?lista) 7)(>= (nth$ ?r $?lista) 4)) 
     then
     (bind ?*puntos* (+ ?*puntos* (+ 2 (- (nth$ ?r $?lista) 4))))
     (assert (pieza ?j 2 (- (nth$ ?r $?lista) 4)(+ 2 (- (nth$ ?r $?lista) 4))))
     (printout t "Jugador: " ?j " --> Piezas [2," (- (nth$ ?r $?lista) 4) "]" crlf)
     else
     (if (or (eq (nth$ ?r $?lista) 3)(eq (nth$ ?r $?lista) 2)) 
      then
      (bind ?*puntos* (+ ?*puntos* (+ 1 (- (nth$ ?r $?lista) 2))))
      (assert (pieza ?j 1 (- (nth$ ?r $?lista) 2)(+ 1 (- (nth$ ?r $?lista) 2))))
      (printout t "Jugador: " ?j " --> Piezas [1," (- (nth$ ?r $?lista) 2) "]" crlf)
      else
       (bind ?*puntos* (+ ?*puntos* (+ 0 (- (nth$ ?r $?lista) 1))))
       (assert (pieza ?j 0 (- (nth$ ?r $?lista) 1)(+ 0 (- (nth$ ?r $?lista) 1))))
       (printout t "Jugador: " ?j " --> Piezas [0," (- (nth$ ?r $?lista) 1) "]" crlf)
))))))
(bind $?lista (delete$ $?lista ?r ?r))
)
(printout t "Jugador: " ?j " --> Puntos: " ?*puntos* crlf)
(assert (puntos ?j ?*puntos*))
(printout t "---------------------" crlf)
(assert (npiezas ?j ?cantidad))
(bind ?*puntos* 0)
)
(printout t "COMIENZA EL JUEGO!" crlf)
)

;FUNCION PARA COMPARAR PUNTOS ENTRE 4 JUGADORES
(deffunction comparar
(?puntos1 ?puntos2 ?puntos3 ?puntos4)
(if (and (and (< ?puntos1 ?puntos2)(< ?puntos1 ?puntos3))(< ?puntos1 ?puntos4))
 then
 (printout t "El ganador es el Jugador: 1 --> Puntos:" ?puntos1 crlf)
 else
 (if (and (and (< ?puntos2 ?puntos1)(< ?puntos2 ?puntos3))(< ?puntos2 ?puntos4))
  then
  (printout t "El ganador es el Jugador: 2 --> Puntos:" ?puntos2 crlf)
  else
  (if (and (and (< ?puntos3 ?puntos2)(< ?puntos3 ?puntos1))(< ?puntos3 ?puntos4))
   then
   (printout t "El ganador es el Jugador: 3 --> Puntos:" ?puntos3 crlf)
   else
   (if (and (and (< ?puntos4 ?puntos2)(< ?puntos4 ?puntos1))(< ?puntos4 ?puntos1))
    then
    (printout t "El ganador es el Jugador: 4 --> Puntos:" ?puntos4 crlf)
   )
  )
 )
)
)

;Empezar partida y repartir piezas
(defrule R1 (declare (salience 10000))
?j <- (juego -1)
=>
(retract ?j)
(repartir 28 4 7)
(assert (juego 0))
)


(defrule R2 (declare (salience 8000))
(npiezas ?jugador 0) ;si un jugador tiene cero fichas ha ganado la partida
=>
(printout t "El jugador " ?jugador " gana la partida!" crlf)
(halt) ;detiene el juego
)

;Cuando pasan todos se acaba porque no hay movimientos se tienen que contar la puntuacion
(defrule R3 (declare (salience 8000))
(pasadas 4)
?a <- (puntos 1 ?puntos1)
?b <- (puntos 2 ?puntos2)
?c <- (puntos 3 ?puntos3)
?d <- (puntos 4 ?puntos4)
=>
(printout t "No hay movimientos, se va a contar la puntuación" crlf)
(comparar ?puntos1 ?puntos2 ?puntos3 ?puntos4)
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
?p <- (pieza ?turno 6 6 ?puntos)
?h <- (extremos ?e1 ?e2)
?n <- (npiezas ?turno ?np)
?q <- (puntos ?turno ?puntosT)
=>
(printout t "El jugador " ?turno " inicia el juego con la pieza [6,6]!" crlf)

(retract ?h ?t ?p ?n ?j ?q)
(assert (extremos 6 6))
(assert (turno (+ 1 ?turno)))
(assert (npiezas ?turno (- ?np 1)))
(assert (juego 1))
(assert (puntos ?turno (- ?puntosT ?puntos)))

)

;se comprueba si el primer numero de cada pieza del jugador coincide
;con el primer numero de las fichas colocadas
(defrule R6 (declare (salience 5000))
?j <- (juego 1)
?t <- (turno ?turno)
?p <- (pieza ?turno ?valor ?n2 ?puntos)
?h <- (extremos ?valor ?e2)
?q <- (puntos ?turno ?puntosT)
?n <- (npiezas ?turno ?np)
?s <- (pasadas ?seguidas)
=>    
(printout t "El jugador " ?turno " pone la pieza [" ?n2 "," ?valor "]" crlf)

(retract ?j ?t ?p ?h ?n ?s ?q)
(assert (extremos ?n2 ?e2))
(assert (turno (+ 1 ?turno)))
(assert (npiezas ?turno (- ?np 1)))
(assert (puntos ?turno (- ?puntosT ?puntos)))
(assert (juego 1))
(assert (pasadas 0))
)


(defrule R7 (declare (salience 5000))
?j <- (juego 1)
?t <- (turno ?turno)
?p <- (pieza ?turno ?n1 ?valor ?puntos)
?h <- (extremos ?valor ?e2)
?q <- (puntos ?turno ?puntosT)
?n <- (npiezas ?turno ?np)
?s <- (pasadas ?seguidas)
=>
(printout t "El jugador " ?turno " pone la pieza [" ?n1 "," ?valor "]" crlf)

(retract ?j ?t ?p ?h ?n ?s ?q)
(assert (extremos ?n1 ?e2))
(assert (turno (+ 1 ?turno)))
(assert (npiezas ?turno (- ?np 1)))
(assert (puntos ?turno (- ?puntosT ?puntos)))
(assert (juego 1))
(assert (pasadas 0))
)


(defrule R8 (declare (salience 5000))
?j <- (juego 1)
?t <- (turno ?turno)
?p <- (pieza ?turno ?valor ?n2 ?puntos)
?h <- (extremos ?e1 ?valor)
?q <- (puntos ?turno ?puntosT)
?n <- (npiezas ?turno ?np)
?s <- (pasadas ?seguidas)
=>
(printout t "El jugador " ?turno " pone la pieza [" ?valor "," ?n2 "]" crlf)

(retract ?j ?t ?p ?h ?n ?s ?q)
(assert (extremos ?e1 ?n2))
(assert (turno (+ 1 ?turno)))
(assert (npiezas ?turno (- ?np 1)))
(assert (puntos ?turno (- ?puntosT ?puntos)))
(assert (juego 1))
(assert (pasadas 0))
)


(defrule R9 (declare (salience 5000))
?j <- (juego 1)
?t <- (turno ?turno)
?p <- (pieza ?turno ?n1 ?valor ?puntos)
?h <- (extremos ?e1 ?valor)
?q <- (puntos ?turno ?puntosT)
?n <- (npiezas ?turno ?np)
?s <- (pasadas ?seguidas)
=>
(printout t "El jugador " ?turno " pone la pieza [" ?valor "," ?n1 "]" crlf)

(retract ?j ?t ?p ?h ?n ?s ?q)
(assert (extremos ?e1 ?n1))
(assert (turno (+ 1 ?turno)))
(assert (npiezas ?turno (- ?np 1)))
(assert (puntos ?turno (- ?puntosT ?puntos)))
(assert (juego 1))
(assert (pasadas 0))
)

;Pasa turno porque no ha podido hacer movimientos
(defrule R10 (declare (salience 1000))
?t <- (turno ?turno)
?s <- (pasadas ?seguidas)
=>
(printout t "El jugador " ?turno " pasa turno!" crlf)

(retract ?t ?s)
(assert (turno (+ 1 ?turno)))
(assert (pasadas (+ 1 ?seguidas)))
)

(deffacts TURNOS (turno 1))
;Comienza el jugador 1 por defecto, ojo no quiere decir que empiece realmente
(deffacts EXTREMOS (extremos -1 -1))
;Tablero inicial
(deffacts INICIO (juego -1))
;Flag estado de juego: -1 = preload, 0 = ini 
(deffacts PASADAS (pasadas 0))
;Comienza el numero de rondas que un jugador ha pasado a 0 por defecto
