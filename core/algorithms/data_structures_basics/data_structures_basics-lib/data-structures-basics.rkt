#lang racket/base

;; data_structures_basics — Node, LinkedList, Stack y Queue sobre un nodo compartido.
;;
;; Especificación: 06_Data_Structures_Basics
;;
;; Contrato Racket: cuatro structs y una función por operación del contrato, con los
;; identificadores en **kebab-case** (`linked-list-insert-head`, `stack-pop`), que es la
;; convención de nombres de Racket. La especificación nombra las operaciones en snake_case
;; (`insert_head`, `pop`): ese nombre se conserva en la prosa de este archivo y en los
;; mensajes de la suite, no en los identificadores.
;;
;; Adecuaciones:
;;   - `init` es una función por estructura —`node-init`, `linked-list-init`, `stack-init`,
;;     `queue-init`— que devuelve la instancia ya inicializada: el `struct` de Racket no
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
;; El contrato vive en `data_structures_basics-lib/data-structures-basics.rkt`: nombre de
;; archivo con guiones, que es la convención de nombres de Racket.
;;
;; Implementación (paso 5): los cuatro `init`, los accesores de `Node`, las siete
;; operaciones de `LinkedList`, las cinco de `Stack` y las cinco de `Queue` siguen el
;; pseudocódigo de la especificación. `get_head`, `pop`, `peek` y `dequeue` devuelven el
;; **valor** (o `#f` si la estructura está vacía) y `delete` devuelve éxito o fallo.

;; El `Node` es la única celda enlazada del módulo: `LinkedList`, `Stack` y `Queue` usan
;; este mismo struct y gestionan sus propios punteros.
(struct node (value next) #:mutable #:transparent)
(struct linked-list (head tail count) #:mutable #:transparent)
(struct stack (top count) #:mutable #:transparent)
(struct queue (front rear count) #:mutable #:transparent)

(provide node-init node-get-value node-get-next node-set-next
         linked-list-init linked-list-get-head linked-list-insert-head linked-list-insert-tail
         linked-list-delete linked-list-is-empty linked-list-size
         stack-init stack-push stack-pop stack-peek stack-is-empty stack-size
         queue-init queue-enqueue queue-dequeue queue-peek queue-is-empty queue-size)

;; ---------------------------------------------------------------------------
;; Node — celda compartida: su init y sus accesores son parte del contrato
;; ---------------------------------------------------------------------------

(define (node-init value)
  (node value #f))

(define (node-get-value node)
  (node-value node))

(define (node-get-next node)
  (node-next node))

;; Enlaza otro nodo y devuelve el propio nodo (`set_next`).
(define (node-set-next node next)
  (set-node-next! node next)
  node)

;; ---------------------------------------------------------------------------
;; LinkedList
;; ---------------------------------------------------------------------------

(define (linked-list-init)
  (linked-list #f #f 0))

;; Valor de la cabeza, o #f con la lista vacía (`get_head`).
(define (linked-list-get-head linked-list)
  (let ((head (linked-list-head linked-list)))
    (if head (node-value head) #f)))

;; Inserta al principio de la lista (`insert_head`).
(define (linked-list-insert-head linked-list value)
  (let ((new-node (node-init value)))
    (set-node-next! new-node (linked-list-head linked-list))
    (set-linked-list-head! linked-list new-node)
    (when (not (linked-list-tail linked-list))
      (set-linked-list-tail! linked-list new-node))
    (set-linked-list-count! linked-list (+ 1 (linked-list-count linked-list)))
    new-node))

;; Inserta al final de la lista (`insert_tail`).
(define (linked-list-insert-tail linked-list value)
  (let ((new-node (node-init value)))
    (if (linked-list-tail linked-list)
        (set-node-next! (linked-list-tail linked-list) new-node)
        (set-linked-list-head! linked-list new-node))
    (set-linked-list-tail! linked-list new-node)
    (set-linked-list-count! linked-list (+ 1 (linked-list-count linked-list)))
    new-node))

;; Elimina la primera aparición: #t si estaba, #f si no (`delete`).
;; Recorre desde la cabeza en O(n) conservando el nodo anterior, y al borrar el último
;; nodo deja la cola en el anterior, que es lo que el pseudocódigo hace con `tail`.
(define (linked-list-delete linked-list value)
  (let loop ((previous #f) (current (linked-list-head linked-list)))
    (cond
      ((not current) #f)
      ((= (node-value current) value)
       (if previous
           (set-node-next! previous (node-next current))
           (set-linked-list-head! linked-list (node-next current)))
       (when (eq? (linked-list-tail linked-list) current)
         (set-linked-list-tail! linked-list previous))
       (set-linked-list-count! linked-list (- (linked-list-count linked-list) 1))
       #t)
      (else (loop current (node-next current))))))

;; Cierto exactamente cuando no hay nodos (`is_empty`).
(define (linked-list-is-empty linked-list)
  (not (linked-list-head linked-list)))

;; Número de nodos (`size`).
(define (linked-list-size linked-list)
  (linked-list-count linked-list))

;; ---------------------------------------------------------------------------
;; Stack — LIFO independiente: no envuelve LinkedList
;; ---------------------------------------------------------------------------

(define (stack-init)
  (stack #f 0))

;; Apila sobre el tope (`push`).
(define (stack-push stack value)
  (let ((new-node (node-init value)))
    (set-node-next! new-node (stack-top stack))
    (set-stack-top! stack new-node)
    (set-stack-count! stack (+ 1 (stack-count stack)))
    new-node))

;; Extrae el tope y devuelve su valor, o #f con la pila vacía (`pop`).
(define (stack-pop stack)
  (let ((top (stack-top stack)))
    (when top
      (set-stack-top! stack (node-next top))
      (set-stack-count! stack (- (stack-count stack) 1)))
    (if top (node-value top) #f)))

;; Observa el valor del tope sin extraerlo, o #f con la pila vacía (`peek`).
(define (stack-peek stack)
  (let ((top (stack-top stack)))
    (if top (node-value top) #f)))

(define (stack-is-empty stack)
  (not (stack-top stack)))

(define (stack-size stack)
  (stack-count stack))

;; ---------------------------------------------------------------------------
;; Queue — FIFO independiente: no envuelve LinkedList
;; ---------------------------------------------------------------------------

(define (queue-init)
  (queue #f #f 0))

;; Añade por el final (`enqueue`). Los punteros del contrato son `front` y `rear`.
(define (queue-enqueue queue value)
  (let ((new-node (node-init value)))
    (if (queue-rear queue)
        (set-node-next! (queue-rear queue) new-node)
        (set-queue-front! queue new-node))
    (set-queue-rear! queue new-node)
    (set-queue-count! queue (+ 1 (queue-count queue)))
    new-node))

;; Extrae el frente y devuelve su valor, o #f con la cola vacía (`dequeue`).
;; Al vaciarse, el `rear` vuelve a ausente junto con el `front`.
(define (queue-dequeue queue)
  (let ((front (queue-front queue)))
    (when front
      (set-queue-front! queue (node-next front))
      (when (not (queue-front queue))
        (set-queue-rear! queue #f))
      (set-queue-count! queue (- (queue-count queue) 1)))
    (if front (node-value front) #f)))

;; Observa el valor del frente sin extraerlo, o #f con la cola vacía (`peek`).
(define (queue-peek queue)
  (let ((front (queue-front queue)))
    (if front (node-value front) #f)))

(define (queue-is-empty queue)
  (not (queue-front queue)))

(define (queue-size queue)
  (queue-count queue))
