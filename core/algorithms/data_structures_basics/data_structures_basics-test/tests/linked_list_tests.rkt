#lang racket/base

;; Casos del contrato `LinkedList` de la especificación 06_Data_Structures_Basics.
;;
;; Los cinco pasos corren sobre la misma lista: se declara una vez con `linked_list_init`
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
(define inserted_tail_first 10)
(define inserted_tail_second 20)
(define inserted_head_value 5)
(define repeated_value 10)
(define absent_value 99)

(module+ test
  (define linked_list (linked_list_init))

  ;; Paso 1 — estado vacío.
  (check_contract "LinkedList 1: is_empty should be true after init" (linked_list_is_empty linked_list) #t)
  (check_contract "LinkedList 1: size should be 0 after init" (linked_list_size linked_list) 0)
  (check_contract "LinkedList 1: get_head on an empty list should return #f" (linked_list_get_head linked_list) #f)

  ;; Paso 2 — inserción por ambos extremos: el orden del contrato es 5, 10, 20, 10.
  (linked_list_insert_tail linked_list inserted_tail_first)
  (linked_list_insert_tail linked_list inserted_tail_second)
  (linked_list_insert_head linked_list inserted_head_value)
  (linked_list_insert_tail linked_list repeated_value)
  (check_contract "LinkedList 2: size should be 4 after the four insertions" (linked_list_size linked_list) 4)
  (check_contract "LinkedList 2: the head of the order 5, 10, 20, 10 should be 5" (linked_list_get_head linked_list) inserted_head_value)

  ;; Paso 3 — eliminar la primera aparición: la lista queda 5, 20, 10.
  (check_contract "LinkedList 3: deleting a present value should succeed" (linked_list_delete linked_list inserted_tail_first) #t)
  (check_contract "LinkedList 3: size should be 3 after delete(10)" (linked_list_size linked_list) 3)
  (check_contract "LinkedList 3: the head should still be 5 after delete(10)" (linked_list_get_head linked_list) inserted_head_value)

  ;; Paso 4 — valor ausente: ni el orden ni el tamaño cambian.
  (check_contract "LinkedList 4: deleting an absent value should fail" (linked_list_delete linked_list absent_value) #f)
  (check_contract "LinkedList 4: size should not change after delete(99)" (linked_list_size linked_list) 3)
  (check_contract "LinkedList 4: the head should not change after delete(99)" (linked_list_get_head linked_list) inserted_head_value)

  ;; Paso 5 — vaciar la lista: cada borrado revela el valor siguiente del orden.
  (check_contract "LinkedList 5: deleting 5 should succeed" (linked_list_delete linked_list inserted_head_value) #t)
  (check_contract "LinkedList 5: after delete(5) the next value of the order should be 20" (linked_list_get_head linked_list) inserted_tail_second)
  (check_contract "LinkedList 5: deleting 20 should succeed" (linked_list_delete linked_list inserted_tail_second) #t)
  (check_contract "LinkedList 5: after delete(20) the last value of the order should be 10" (linked_list_get_head linked_list) repeated_value)
  (check_contract "LinkedList 5: deleting the last value should succeed" (linked_list_delete linked_list repeated_value) #t)
  (check_contract "LinkedList 5: is_empty should be true after emptying" (linked_list_is_empty linked_list) #t)
  (check_contract "LinkedList 5: size should be 0 after emptying" (linked_list_size linked_list) 0)
  (check_contract "LinkedList 5: get_head should return #f again" (linked_list_get_head linked_list) #f))
