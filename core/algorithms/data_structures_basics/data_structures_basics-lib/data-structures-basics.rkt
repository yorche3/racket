#lang racket/base

;; data_structures_basics — Node, LinkedList, Stack y Queue sobre un nodo compartido.
;;
;; Especificación: 06_Data_Structures_Basics
;;
;; Contrato Racket: cuatro structs y una función por operación del contrato, con los
;; nombres en snake_case del módulo homologado (`numbers/`, `naive_sort/`).
;;
;; Adecuaciones:
;;   - `init` es una función por estructura —`node_init`, `linked_list_init`, `stack_init`,
;;     `queue_init`— que devuelve la instancia ya inicializada: el `struct` de Racket no
;;     admite campos con valor por defecto, así que el constructor no puede ser el `init`
;;     del contrato sin pedir los enlaces ausentes.
;;   - Los structs son `#:mutable`, así que las operaciones que el pseudocódigo escribe
;;     como asignaciones trabajan sobre la misma instancia; las que no comunican resultado
;;     (`insert_head`, `insert_tail`, `push`, `enqueue`) devuelven `(void)`.
;;   - El indicador natural de fallo es **`#f`**: la ausencia del enlace de un `Node` y las
;;     lecturas que pueden fallar (`get_head`, `pop`, `peek`, `dequeue`). No es un entero,
;;     así que los valores de prueba (enteros positivos) no colisionan con él, y es lo que
;;     Racket devuelve en sus propias búsquedas (`assoc`, `member`).
;;   - `delete` devuelve un booleano (éxito o fallo) y `is_empty`, un booleano. `size`
;;     devuelve el número de nodos, que es 0 con la estructura vacía.
;;
;; El contrato vive en `data_structures_basics-lib/data-structures-basics.rkt`: el nombre
;; del módulo con guiones, que es la convención de nombres de Racket.
;;
;; Esqueleto del contrato (paso 4b): los constructores —el `init` del contrato— y los
;; accesores de `Node` ya funcionan, que es lo que necesita la suite del 4c para construir
;; sus escenarios; el algoritmo de las operaciones de las tres estructuras es del paso 5,
;; así que mientras no lo haya cada operación devuelve su indicador.

;; El `Node` es la única celda enlazada del módulo: `LinkedList`, `Stack` y `Queue` usan
;; este mismo struct y gestionan sus propios punteros.
(struct node (value next) #:mutable #:transparent)
(struct linked_list (head tail count) #:mutable #:transparent)
(struct stack (top count) #:mutable #:transparent)
(struct queue (front rear count) #:mutable #:transparent)

(provide node_init node_get_value node_get_next node_set_next
         linked_list_init linked_list_get_head linked_list_insert_head linked_list_insert_tail
         linked_list_delete linked_list_is_empty linked_list_size
         stack_init stack_push stack_pop stack_peek stack_is_empty stack_size
         queue_init queue_enqueue queue_dequeue queue_peek queue_is_empty queue_size)

;; ---------------------------------------------------------------------------
;; Node — celda compartida: su init y sus accesores son parte del contrato
;; ---------------------------------------------------------------------------

(define (node_init value)
  (node value #f))

(define (node_get_value node)
  (node-value node))

(define (node_get_next node)
  (node-next node))

;; Enlaza otro nodo y devuelve el propio nodo (`set_next`).
(define (node_set_next node next)
  (set-node-next! node next)
  node)

;; ---------------------------------------------------------------------------
;; LinkedList
;; ---------------------------------------------------------------------------

(define (linked_list_init)
  (linked_list #f #f 0))

;; Valor de la cabeza, o #f con la lista vacía (`get_head`).
(define (linked_list_get_head linked_list)
  #f)

;; Inserta al principio de la lista (`insert_head`).
(define (linked_list_insert_head linked_list value)
  (void))

;; Inserta al final de la lista (`insert_tail`).
(define (linked_list_insert_tail linked_list value)
  (void))

;; Elimina la primera aparición: #t si estaba, #f si no (`delete`).
(define (linked_list_delete linked_list value)
  #f)

;; Cierto exactamente cuando no hay nodos (`is_empty`).
(define (linked_list_is_empty linked_list)
  #f)

;; Número de nodos (`size`).
(define (linked_list_size linked_list)
  0)

;; ---------------------------------------------------------------------------
;; Stack — LIFO independiente: no envuelve LinkedList
;; ---------------------------------------------------------------------------

(define (stack_init)
  (stack #f 0))

;; Apila sobre el tope (`push`).
(define (stack_push stack value)
  (void))

;; Extrae el tope, o #f con la pila vacía (`pop`).
(define (stack_pop stack)
  #f)

;; Observa el tope sin extraerlo, o #f con la pila vacía (`peek`).
(define (stack_peek stack)
  #f)

(define (stack_is_empty stack)
  #f)

(define (stack_size stack)
  0)

;; ---------------------------------------------------------------------------
;; Queue — FIFO independiente: no envuelve LinkedList
;; ---------------------------------------------------------------------------

(define (queue_init)
  (queue #f #f 0))

;; Añade por el final (`enqueue`).
(define (queue_enqueue queue value)
  (void))

;; Extrae el frente, o #f con la cola vacía (`dequeue`).
(define (queue_dequeue queue)
  #f)

;; Observa el frente sin extraerlo, o #f con la cola vacía (`peek`).
(define (queue_peek queue)
  #f)

(define (queue_is_empty queue)
  #f)

(define (queue_size queue)
  0)
