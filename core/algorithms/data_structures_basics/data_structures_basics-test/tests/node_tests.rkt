#lang racket/base

;; Casos del contrato `Node` de la especificación 06_Data_Structures_Basics.
;;
;; `Node` es la única celda enlazada del módulo y la comparten `LinkedList`, `Stack` y
;; `Queue`. La ausencia del enlace usa la representación nativa de Racket, `#f`, que es
;; también el indicador de fallo del contrato; no se añade un caso nulo aparte porque
;; Racket no tiene `null` y los casos de estado vacío de las tres estructuras ya verifican
;; ese indicador. Los valores son enteros positivos, así que no colisionan con él.

(require rackunit
         "contract.rkt"
         "../../data_structures_basics-lib/data-structures-basics.rkt")

;; Fixtures: un nombre por valor del escenario.
(define first_value 10)
(define second_value 20)

(module+ test
  ;; Paso 1 — inicializar y observar valor/enlace.
  (define first_node (node_init first_value))
  (check_contract "Node 1: get_value should be 10" (node_get_value first_node) first_value)
  (check_contract "Node 1: get_next should be the native absence #f" (node_get_next first_node) #f)

  ;; Paso 2 — inicializar otro nodo, enlazarlo y recorrerlo.
  (define second_node (node_init second_value))
  (node_set_next first_node second_node)
  (check_contract "Node 2: traversal should reach 20" (node_get_value (node_get_next first_node)) second_value)
  (check_contract "Node 2: the second node's next should be absent" (node_get_next second_node) #f))
