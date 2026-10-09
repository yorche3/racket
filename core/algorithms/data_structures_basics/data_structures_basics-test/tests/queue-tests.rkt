#lang racket/base

;; Casos del contrato `Queue` de la especificación 06_Data_Structures_Basics.
;;
;; Los cuatro pasos corren sobre la misma cola: se declara una vez con `queue-init` y cada
;; paso continúa el estado anterior, sin reiniciar el escenario. Aislamiento: la instancia
;; es la del propio escenario.

(require rackunit
         "contract.rkt"
         "../../data_structures_basics-lib/data-structures-basics.rkt")

;; Fixtures: un nombre por valor del escenario.
(define enqueued-first 10)
(define enqueued-second 20)
(define enqueued-third 30)
(define enqueued-after-dequeue 40)

(module+ test
  (define queue (queue-init))

  ;; Paso 1 — estado vacío y extracción fallida.
  (check-contract "Queue 1: is_empty should be true after init" (queue-is-empty queue) #t)
  (check-contract "Queue 1: size should be 0 after init" (queue-size queue) 0)
  (check-contract "Queue 1: peek on an empty queue should return #f" (queue-peek queue) #f)
  (check-contract "Queue 1: dequeue on an empty queue should return #f" (queue-dequeue queue) #f)
  (check-contract "Queue 1: a failed dequeue should keep the queue empty" (queue-is-empty queue) #t)

  ;; Paso 2 — FIFO y `peek` no mutante.
  (queue-enqueue queue enqueued-first)
  (queue-enqueue queue enqueued-second)
  (queue-enqueue queue enqueued-third)
  (check-contract "Queue 2: peek should return 10" (queue-peek queue) enqueued-first)
  (check-contract "Queue 2: size should be 3 after three enqueues" (queue-size queue) 3)

  ;; Paso 3 — extracción y reutilización.
  (check-contract "Queue 3: the first dequeue should return 10" (queue-dequeue queue) enqueued-first)
  (queue-enqueue queue enqueued-after-dequeue)
  (check-contract "Queue 3: the next dequeue should return 20" (queue-dequeue queue) enqueued-second)
  (check-contract "Queue 3: the next dequeue should return 30" (queue-dequeue queue) enqueued-third)
  (check-contract "Queue 3: the final dequeue should return 40" (queue-dequeue queue) enqueued-after-dequeue)
  (check-contract "Queue 3: is_empty should be true after removing everything" (queue-is-empty queue) #t)
  (check-contract "Queue 3: size should be 0 after removing everything" (queue-size queue) 0)

  ;; Paso 4 — vacío tras la extracción.
  (check-contract "Queue 4: dequeue on an empty queue should fail" (queue-dequeue queue) #f)
  (check-contract "Queue 4: a failed dequeue should keep the queue empty" (queue-is-empty queue) #t))
