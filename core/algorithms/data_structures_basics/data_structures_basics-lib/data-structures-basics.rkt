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
;;     como asignaciones trabajan sobre la misma instancia; las inserciones (`insert_head`,
;;     `insert_tail`, `push`, `enqueue`) devuelven el nodo insertado: la especificación fija
;;     su efecto sobre el tamaño, no su resultado.
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
;; Implementación (paso 5): los cuatro `init`, los accesores de `Node`, las siete
;; operaciones de `LinkedList`, las cinco de `Stack` y las cinco de `Queue` siguen el
;; pseudocódigo de la especificación. `get_head`, `pop`, `peek` y `dequeue` devuelven el
;; **valor** (o `#f` si la estructura está vacía) y `delete` devuelve éxito o fallo.

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
  (let ((head (linked_list-head linked_list)))
    (if head (node-value head) #f)))

;; Inserta al principio de la lista (`insert_head`).
(define (linked_list_insert_head linked_list value)
  (let ((new-node (node_init value)))
    (set-node-next! new-node (linked_list-head linked_list))
    (set-linked_list-head! linked_list new-node)
    (when (not (linked_list-tail linked_list))
      (set-linked_list-tail! linked_list new-node))
    (set-linked_list-count! linked_list (+ 1 (linked_list-count linked_list)))
    new-node))

;; Inserta al final de la lista (`insert_tail`).
(define (linked_list_insert_tail linked_list value)
  (let ((new-node (node_init value)))
    (if (linked_list-tail linked_list)
        (set-node-next! (linked_list-tail linked_list) new-node)
        (set-linked_list-head! linked_list new-node))
    (set-linked_list-tail! linked_list new-node)
    (set-linked_list-count! linked_list (+ 1 (linked_list-count linked_list)))
    new-node))

;; Elimina la primera aparición: #t si estaba, #f si no (`delete`).
;; Recorre desde la cabeza en O(n) conservando el nodo anterior, y al borrar el último
;; nodo deja la cola en el anterior, que es lo que el pseudocódigo hace con `tail`.
(define (linked_list_delete linked_list value)
  (let loop ((previous #f) (current (linked_list-head linked_list)))
    (cond
      ((not current) #f)
      ((= (node-value current) value)
       (if previous
           (set-node-next! previous (node-next current))
           (set-linked_list-head! linked_list (node-next current)))
       (when (eq? (linked_list-tail linked_list) current)
         (set-linked_list-tail! linked_list previous))
       (set-linked_list-count! linked_list (- (linked_list-count linked_list) 1))
       #t)
      (else (loop current (node-next current))))))

;; Cierto exactamente cuando no hay nodos (`is_empty`).
(define (linked_list_is_empty linked_list)
  (not (linked_list-head linked_list)))

;; Número de nodos (`size`).
(define (linked_list_size linked_list)
  (linked_list-count linked_list))

;; ---------------------------------------------------------------------------
;; Stack — LIFO independiente: no envuelve LinkedList
;; ---------------------------------------------------------------------------

(define (stack_init)
  (stack #f 0))

;; Apila sobre el tope (`push`).
(define (stack_push stack value)
  (let ((new-node (node_init value)))
    (set-node-next! new-node (stack-top stack))
    (set-stack-top! stack new-node)
    (set-stack-count! stack (+ 1 (stack-count stack)))
    new-node))

;; Extrae el tope y devuelve su valor, o #f con la pila vacía (`pop`).
(define (stack_pop stack)
  (let ((top (stack-top stack)))
    (when top
      (set-stack-top! stack (node-next top))
      (set-stack-count! stack (- (stack-count stack) 1)))
    (if top (node-value top) #f)))

;; Observa el valor del tope sin extraerlo, o #f con la pila vacía (`peek`).
(define (stack_peek stack)
  (let ((top (stack-top stack)))
    (if top (node-value top) #f)))

(define (stack_is_empty stack)
  (not (stack-top stack)))

(define (stack_size stack)
  (stack-count stack))

;; ---------------------------------------------------------------------------
;; Queue — FIFO independiente: no envuelve LinkedList
;; ---------------------------------------------------------------------------

(define (queue_init)
  (queue #f #f 0))

;; Añade por el final (`enqueue`). Los punteros del contrato son `front` y `rear`.
(define (queue_enqueue queue value)
  (let ((new-node (node_init value)))
    (if (queue-rear queue)
        (set-node-next! (queue-rear queue) new-node)
        (set-queue-front! queue new-node))
    (set-queue-rear! queue new-node)
    (set-queue-count! queue (+ 1 (queue-count queue)))
    new-node))

;; Extrae el frente y devuelve su valor, o #f con la cola vacía (`dequeue`).
;; Al vaciarse, el `rear` vuelve a ausente junto con el `front`.
(define (queue_dequeue queue)
  (let ((front (queue-front queue)))
    (when front
      (set-queue-front! queue (node-next front))
      (when (not (queue-front queue))
        (set-queue-rear! queue #f))
      (set-queue-count! queue (- (queue-count queue) 1)))
    (if front (node-value front) #f)))

;; Observa el valor del frente sin extraerlo, o #f con la cola vacía (`peek`).
(define (queue_peek queue)
  (let ((front (queue-front queue)))
    (if front (node-value front) #f)))

(define (queue_is_empty queue)
  (not (queue-front queue)))

(define (queue_size queue)
  (queue-count queue))
