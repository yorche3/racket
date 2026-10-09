#lang racket/base

;; Casos del contrato `LinkedList` de la especificación 06_Data_Structures_Basics.
;;
;; Los cinco pasos corren sobre la misma lista: se declara una vez con `linked-list-init`
;; y cada paso continúa el estado anterior, sin reiniciar el escenario. Aislamiento: la
;; instancia es la del propio escenario, así que ninguna suite comparte fixtures mutables.
;;
;; El contrato expone el valor de la cabeza (`get_head`), no el nodo, así que el orden
;; `5, 10, 20, 10` se observa por esa cabeza en cada paso —como hace el módulo Ada—; la
;; cadena de nodos no es observable desde el contrato y por eso no se recorre.

(require rackunit
         "contract.rkt"
         "../../data_structures_basics-lib/data-structures-basics.rkt")

;; Fixtures: un nombre por valor del escenario.
(define inserted-tail-first 10)
(define inserted-tail-second 20)
(define inserted-head-value 5)
(define repeated-value 10)
(define absent-value 99)

(module+ test
  (define linked-list (linked-list-init))

  ;; Paso 1 — estado vacío.
  (check-contract "LinkedList 1: is_empty should be true after init" (linked-list-is-empty linked-list) #t)
  (check-contract "LinkedList 1: size should be 0 after init" (linked-list-size linked-list) 0)
  (check-contract "LinkedList 1: get_head on an empty list should return #f" (linked-list-get-head linked-list) #f)

  ;; Paso 2 — inserción por ambos extremos: el orden del contrato es 5, 10, 20, 10.
  (linked-list-insert-tail linked-list inserted-tail-first)
  (linked-list-insert-tail linked-list inserted-tail-second)
  (linked-list-insert-head linked-list inserted-head-value)
  (linked-list-insert-tail linked-list repeated-value)
  (check-contract "LinkedList 2: size should be 4 after the four insertions" (linked-list-size linked-list) 4)
  (check-contract "LinkedList 2: the head of the order 5, 10, 20, 10 should be 5" (linked-list-get-head linked-list) inserted-head-value)

  ;; Paso 3 — eliminar la primera aparición: la lista queda 5, 20, 10.
  (check-contract "LinkedList 3: deleting a present value should succeed" (linked-list-delete linked-list inserted-tail-first) #t)
  (check-contract "LinkedList 3: size should be 3 after delete(10)" (linked-list-size linked-list) 3)
  (check-contract "LinkedList 3: the head should still be 5 after delete(10)" (linked-list-get-head linked-list) inserted-head-value)

  ;; Paso 4 — valor ausente: ni el orden ni el tamaño cambian.
  (check-contract "LinkedList 4: deleting an absent value should fail" (linked-list-delete linked-list absent-value) #f)
  (check-contract "LinkedList 4: size should not change after delete(99)" (linked-list-size linked-list) 3)
  (check-contract "LinkedList 4: the head should not change after delete(99)" (linked-list-get-head linked-list) inserted-head-value)

  ;; Paso 5 — vaciar la lista: cada borrado revela el valor siguiente del orden.
  (check-contract "LinkedList 5: deleting 5 should succeed" (linked-list-delete linked-list inserted-head-value) #t)
  (check-contract "LinkedList 5: after delete(5) the next value of the order should be 20" (linked-list-get-head linked-list) inserted-tail-second)
  (check-contract "LinkedList 5: deleting 20 should succeed" (linked-list-delete linked-list inserted-tail-second) #t)
  (check-contract "LinkedList 5: after delete(20) the last value of the order should be 10" (linked-list-get-head linked-list) repeated-value)
  (check-contract "LinkedList 5: deleting the last value should succeed" (linked-list-delete linked-list repeated-value) #t)
  (check-contract "LinkedList 5: is_empty should be true after emptying" (linked-list-is-empty linked-list) #t)
  (check-contract "LinkedList 5: size should be 0 after emptying" (linked-list-size linked-list) 0)
  (check-contract "LinkedList 5: get_head should return #f again" (linked-list-get-head linked-list) #f))
