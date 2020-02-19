;(deftemplate extremos (slot ext1)(slot ext2)(slot ext3)(slot ext4))
;(deftemplate turno (slot turno_de))
;(deftemplate carta (slot jugador)(slot numcarta))
;(deftemplate ncartas (slot jugador)(slot cantidad))
;(deftemplate juego (slot numero))
; Estas plantillas es solo para ver la estructura de los hechos que se van a utilizar,
; no tienen utilidad para este programa


;---FUNCION PARA REPARTIR CARTAS ALEATORIAMENTE ENTRE JUGADORES
(deffunction repartir
(?ncartas ?players ?cantidad)
(bind $?lista (create$ 0))
(printout t "INICIANDO REPARTO DE CARTAS..." crlf)
(loop-for-count (?i 1 ?ncartas) do
(bind $?lista (insert$ $?lista ?i ?i))
)
(loop-for-count (?j 1 ?players) do
;(printout t "Lista --> " $?lista " = " (length $?lista) crlf)
(loop-for-count (?i 1 ?cantidad) do
(bind ?r (random 1 (- (length $?lista) 1)))
(assert (carta ?j (nth$ ?r $?lista)))
(printout t "Jugador: " ?j " --> Carta " (nth$ ?r $?lista) crlf)
(bind $?lista (delete$ $?lista ?r ?r))
)
(printout t "---------------------" crlf)
(assert (ncartas ?j ?cantidad))
)
(printout t "COMIENZA EL JUEGO!" crlf)
)


;---SISTEMA DE REGLAS---

;***IMPORTANTE***
    ;retract -> borra un hecho de nuestra base de hechos
    ;assert  -> crea un nuevo hecho
    ;Las lineas que hay antes del simbolo "=>" tienen que ser ciertas (tienen que existir hechos en nuestra base que coincidan)
    ;para ejecutar las lineas que hay despues

(defrule R1 (declare (salience 10000))
?j <- (juego -1)   ;si el estado del juego es -1 quiere decir que no ha empezado
                   ;guarda la salida en "j"
=>
(retract ?j)       ;elimina el hecho "juego -1"
(repartir 12 2 6)  ;reparte 12 cartas entre 2 jugadores (6 por cabeza)
(assert (juego 0)) ;introduce un nuevo hecho que indica que el estado del juego es 0 que significa que se inicia con el palo 1
)


(defrule R2 (declare (salience 10000))
(ncartas ?jugador 0) ;si un jugador tiene cero cartas ha ganado la partida
=>
(printout t "El jugador " ?jugador " gana la partida!" crlf)
(halt) ;detiene el juego
)

;Arregla los extremos de los palos. Se entiende una vez se entiendan las reglas R8 R9 R10 R11
(defrule R3 (declare (salience 8000))
?h <- (extremos ?e1 7 ?e3 ?e4)
=>
(retract ?h)
(assert(extremos ?e1 6 ?e3 ?e4))
)

;Arregla los extremos de los palos. Se entiende una vez se entiendan las reglas R8 R9 R10 R11
(defrule R4 (declare (salience 8000))
?h <- (extremos ?e1 ?e2 6 ?e4)
=>
(retract ?h)
(assert(extremos ?e1 ?e2 7 ?e4))
)

;No entiendo esta regla ni como gestiona los turnos
(defrule R5 (declare (salience 8000))
?t <- (turno 2)
=>
(assert (turno 1))
(retract ?t)
)


(defrule R6 (declare (salience 7000))
?j <- (juego 0)         ;si es el inicio de la partida (juego 0 significa que inicia el primer palo y se necesita el 4 para iniciar)
?t <- (turno ?turno)    ;si es el turno de cualquier jugador
?c <- (carta ?turno 4)  ;si ese jugador tiene la carta 4
?h <- (extremos ?e1 ?e2 ?e3 ?e4) ;obtiene todos los extremos que al principio son 0
?n <- (ncartas ?turno ?nc) ;obtiene el numero de cartas del jugador que tiene el 4
=>
(printout t "El jugador " ?turno " inicia el juego con la carta 4!" crlf)
(assert (extremos 3 5 ?e3 ?e4))     ;introduce el hecho de que los extremos para el primer palo 
                                    ;son 3 y 5 por abajo y por arriba respectivamente
(assert (turno (+ 1 ?turno)))   
(assert (ncartas ?turno (- ?nc 1))) ;actualiza el numero de cartas del jugador
(assert (juego 1))
(retract ?h ?t ?c ?n ?j)            ;borra los hechos de las primeras lineas porque los sustituye por unos nuevos con assert
)

;Como R6 pero para abrir el segundo palo
(defrule R7 (declare (salience 7000))
?j <- (juego 1) 
?t <- (turno ?turno)
?c <- (carta ?turno 10)
?h <- (extremos ?e1 ?e2 ?e3 ?e4)
?n <- (ncartas ?turno ?nc)
=>
(printout t "El jugador " ?turno " abre el segundo palo con la carta 4!" crlf)
(assert (extremos ?e1 ?e2 9 11))
(assert (turno (+ 1 ?turno)))
(assert (ncartas ?turno (- ?nc 1)))
(retract ?h ?t ?c ?n ?j)
)

;Comprueba si un jugador puede poner carta en el extremo inferior del primer palo
(defrule R8 (declare (salience 5000))
?t <- (turno ?turno)
?c <- (carta ?turno ?valor) 
?h <- (extremos ?valor ?e2 ?e3 ?e4) ;si un jugador tiene una carta con un valor que se pueda poner en extremo 
                                    ;inferior del primer palo
?n <- (ncartas ?turno ?nc)
=>
(printout t "El jugador " ?turno " pone la carta " ?valor crlf)
(assert (extremos (- ?valor 1) ?e2 ?e3 ?e4)) ;resta 1 al extremo inferior ya que hemos puesto una carta en este
(assert (turno (+ 1 ?turno)))
(assert (ncartas ?turno (- ?nc 1))) ;actualiza el numero de cartas del jugador
(retract ?h ?t ?c ?n)
)

;Como R8 pero con el extremo superior
(defrule R9 (declare (salience 5000))
?t <- (turno ?turno)
?c <- (carta ?turno ?valor)
?h <- (extremos ?e1 ?valor ?e3 ?e4)
?n <- (ncartas ?turno ?nc)
=>
(printout t "El jugador " ?turno " pone la carta " ?valor crlf)
(assert (extremos ?e1 (+ ?valor 1) ?e3 ?e4))
(assert (turno (+ 1 ?turno)))
(assert (ncartas ?turno (- ?nc 1)))
(retract ?h ?t ?c ?n)
)

;Como R8 pero con el segundo palo
(defrule R10 (declare (salience 5000))
?t <- (turno ?turno)
?c <- (carta ?turno ?valor)
?h <- (extremos ?e1 ?e2 ?valor ?e4)
?n <- (ncartas ?turno ?nc)
=>
(printout t "El jugador " ?turno " pone la carta " ?valor crlf)
(assert (extremos ?e1 ?e2 (- ?valor 1) ?e4))
(assert (turno (+ 1 ?turno)))
(assert (ncartas ?turno (- ?nc 1)))
(retract ?h ?t ?c ?n)
)

;Como R10 pero con el extremo superior
(defrule R11 (declare (salience 5000))
?t <- (turno ?turno)
?c <- (carta ?turno ?valor)
?h <- (extremos ?e1 ?e2 ?e3 ?valor)
?n <- (ncartas ?turno ?nc)
=>
(printout t "El jugador " ?turno " pone la carta " ?valor crlf)
(assert (extremos ?e1 ?e2 ?e3 (+ ?valor 1)))
(assert (turno (+ 1 ?turno)))
(assert (ncartas ?turno (- ?nc 1)))
(retract ?h ?t ?c ?n)
)

;Pasa de turno. Tiene salience 0 lo que quiere decir que es la regla con menor prioridad
;entonces si el jugador no ha conseguido cumplir ninguna de las reglas anteriores
;significa que no tiene movimientos posibles y pasa el turno al siguiente jugador
(defrule R12 (declare (salience 0))
?t <- (turno ?turno)
=>
(printout t "El jugador " ?turno " pasa turno!" crlf)

(assert (turno (+ 1 ?turno)))
(retract ?t)
)


(deffacts TURNOS (turno 1))
;Comienza el jugador 1 por defecto, ojo no quiere decir que empiece realmente
(deffacts EXTREMOS (extremos 0 0 0 0))
;Tablero inicial
(deffacts INICIO (juego -1))
;Flag estado de juego: -1 = preload, 0 = ini palo 1, 1 = ini palo 2