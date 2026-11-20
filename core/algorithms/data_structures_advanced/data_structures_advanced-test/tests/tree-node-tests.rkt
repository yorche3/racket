#lang racket/base

;; Casos `TreeNode` de la especificación 07_Data_Structures_Advanced (6 filas).
;; Adaptación: los nodos son inmutables, así que `set_left`/`set_right` devuelven un
;; nodo nuevo; cada caso encadena los nodos devueltos. La ausencia es `#f`.

(require "contract.rkt"
         "../../data_structures_advanced-lib/data-structures-advanced.rkt")

;; Fixtures: un nombre por valor.
(define parent-value 10)
(define left-value 20)
(define right-value 30)

(module+ test
  (define (make-parent) (tree-node-init parent-value))
  (define (make-left) (tree-node-init left-value))
  (define (make-right) (tree-node-init right-value))

  ;; Caso 1 — crear un nodo de árbol.
  (let ([node (make-parent)])
    (check-contract "TreeNode 1: get_value should be 10 after init(10)"
                    (tree-node-get-value node) parent-value))

  ;; Caso 2 — enlaces iniciales ausentes.
  (let ([node (make-parent)])
    (check-contract "TreeNode 2: get_left should be absent after init" (tree-node-get-left node) #f)
    (check-contract "TreeNode 2: get_right should be absent after init" (tree-node-get-right node) #f))

  ;; Caso 3 — enlazar dos hijos.
  (let* ([parent (tree-node-set-right (tree-node-set-left (make-parent) (make-left)) (make-right))])
    (check-contract "TreeNode 3: the left child value should be 20"
                    (tree-node-get-value (tree-node-get-left parent)) left-value)
    (check-contract "TreeNode 3: the right child value should be 30"
                    (tree-node-get-value (tree-node-get-right parent)) right-value))

  ;; Caso 4 — recorrer cada enlace.
  (let* ([parent (tree-node-set-right (tree-node-set-left (make-parent) (make-left)) (make-right))]
         [left (tree-node-get-left parent)]
         [right (tree-node-get-right parent)])
    (check-contract "TreeNode 4: following get_left should lead to 20" (tree-node-get-value left) left-value)
    (check-contract "TreeNode 4: following get_right should lead to 30" (tree-node-get-value right) right-value)
    (check-contract "TreeNode 4: the left child's left link should be absent" (tree-node-get-left left) #f)
    (check-contract "TreeNode 4: the left child's right link should be absent" (tree-node-get-right left) #f)
    (check-contract "TreeNode 4: the right child's left link should be absent" (tree-node-get-left right) #f)
    (check-contract "TreeNode 4: the right child's right link should be absent" (tree-node-get-right right) #f))

  ;; Caso 5 — desenlazar hijos: primero el izquierdo, luego el derecho.
  (let* ([linked (tree-node-set-right (tree-node-set-left (make-parent) (make-left)) (make-right))]
         [left-cleared (tree-node-set-left linked #f)]
         [both-cleared (tree-node-set-right left-cleared #f)])
    (check-contract "TreeNode 5: clearing left should preserve value 10" (tree-node-get-value left-cleared) parent-value)
    (check-contract "TreeNode 5: clearing left should make get_left absent" (tree-node-get-left left-cleared) #f)
    (check-contract "TreeNode 5: clearing left should preserve the right child 30"
                    (tree-node-get-value (tree-node-get-right left-cleared)) right-value)
    (check-contract "TreeNode 5: clearing right should leave get_left absent" (tree-node-get-left both-cleared) #f)
    (check-contract "TreeNode 5: clearing right should leave get_right absent" (tree-node-get-right both-cleared) #f)
    (check-contract "TreeNode 5: clearing right should preserve value 10" (tree-node-get-value both-cleared) parent-value))

  ;; Caso 6 — adaptación inmutable: el original no cambia.
  (let* ([original (make-parent)]
         [updated (tree-node-set-left original (make-left))])
    (check-contract "TreeNode 6: set_left should return a node with the new link"
                    (tree-node-get-value (tree-node-get-left updated)) left-value)
    (check-contract "TreeNode 6: the original node should keep its left link absent" (tree-node-get-left original) #f)
    (check-contract "TreeNode 6: the original node should keep value 10" (tree-node-get-value original) parent-value)))
