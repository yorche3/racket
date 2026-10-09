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
(define first-value 10)
(define second-value 20)

(module+ test
  ;; Paso 1 — inicializar y observar valor/enlace.
  (define first-node (node-init first-value))
  (check-contract "Node 1: get_value should be 10" (node-get-value first-node) first-value)
  (check-contract "Node 1: get_next should be the native absence #f" (node-get-next first-node) #f)

  ;; Paso 2 — inicializar otro nodo, enlazarlo y recorrerlo.
  (define second-node (node-init second-value))
  (node-set-next first-node second-node)
  (check-contract "Node 2: traversal should reach 20" (node-get-value (node-get-next first-node)) second-value)
  (check-contract "Node 2: the second node's next should be absent" (node-get-next second-node) #f))
