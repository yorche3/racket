#lang racket/base

;; Casos del contrato `Queue` de la especificación 06_Data_Structures_Basics.
;;
;; Los cuatro pasos corren sobre la misma cola: se declara una vez con `queue_init` y cada
;; paso continúa el estado anterior, sin reiniciar el escenario. Aislamiento: la instancia
;; es la del propio escenario.

(require rackunit
         "contract.rkt"
         "../../data_structures_basics-lib/data-structures-basics.rkt")

;; Fixtures: un nombre por valor del escenario.
(define enqueued_first 10)
(define enqueued_second 20)
(define enqueued_third 30)
(define enqueued_after_dequeue 40)

(module+ test
  (define queue (queue_init))

  ;; Paso 1 — estado vacío y extracción fallida.
  (check_contract "Queue 1: is_empty should be true after init" (queue_is_empty queue) #t)
  (check_contract "Queue 1: size should be 0 after init" (queue_size queue) 0)
  (check_contract "Queue 1: peek on an empty queue should return #f" (queue_peek queue) #f)
  (check_contract "Queue 1: dequeue on an empty queue should return #f" (queue_dequeue queue) #f)
  (check_contract "Queue 1: a failed dequeue should keep the queue empty" (queue_is_empty queue) #t)

  ;; Paso 2 — FIFO y `peek` no mutante.
  (queue_enqueue queue enqueued_first)
  (queue_enqueue queue enqueued_second)
  (queue_enqueue queue enqueued_third)
  (check_contract "Queue 2: peek should return 10" (queue_peek queue) enqueued_first)
  (check_contract "Queue 2: size should be 3 after three enqueues" (queue_size queue) 3)

  ;; Paso 3 — extracción y reutilización.
  (check_contract "Queue 3: the first dequeue should return 10" (queue_dequeue queue) enqueued_first)
  (queue_enqueue queue enqueued_after_dequeue)
  (check_contract "Queue 3: the next dequeue should return 20" (queue_dequeue queue) enqueued_second)
  (check_contract "Queue 3: the next dequeue should return 30" (queue_dequeue queue) enqueued_third)
  (check_contract "Queue 3: the final dequeue should return 40" (queue_dequeue queue) enqueued_after_dequeue)
  (check_contract "Queue 3: is_empty should be true after removing everything" (queue_is_empty queue) #t)
  (check_contract "Queue 3: size should be 0 after removing everything" (queue_size queue) 0)

  ;; Paso 4 — vacío tras la extracción.
  (check_contract "Queue 4: dequeue on an empty queue should fail" (queue_dequeue queue) #f)
  (check_contract "Queue 4: a failed dequeue should keep the queue empty" (queue_is_empty queue) #t))
