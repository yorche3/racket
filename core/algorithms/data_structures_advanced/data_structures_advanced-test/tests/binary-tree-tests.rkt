#lang racket/base

;; Casos `BinaryTree` de la especificación 07_Data_Structures_Advanced (7 filas).
;; Adaptación: el árbol es inmutable; `insert` devuelve el árbol nuevo (éxito) o `#f`
;; (fallo), y cada caso encadena los árboles devueltos desde un `init` propio.

(require racket/list
         "contract.rkt"
         "../../data_structures_advanced-lib/data-structures-advanced.rkt")

;; Fixtures: un nombre por entrada.
(define root-value 50)
(define lower-value 30)
(define higher-value 70)
(define lower-leaf-value 20)
(define middle-leaf-value 40)
(define absent-value 99)

;; Inserta en orden comprobando el éxito de cada alta; devuelve el último árbol.
(define (insert-all message tree values)
  (for/fold ([current tree]) ([value (in-list values)] [step (in-naturals 1)])
    (define next (and current (binary-tree-insert current value)))
    (check-contract (format "~a: insert(~a) should succeed (step ~a)" message value step)
                    (succeeded? next) #t)
    next))

(define (check-all-present message tree values)
  (for ([value (in-list values)])
    (check-contract (format "~a: contains(~a) should succeed" message value)
                    (binary-tree-contains tree value) #t)))

(module+ test
  ;; Caso 1 — crear vacío.
  (let ([tree (binary-tree-init)])
    (check-contract "BinaryTree 1: is_empty should be true after init" (binary-tree-is-empty tree) #t)
    (check-contract "BinaryTree 1: size should be 0 after init" (binary-tree-size tree) 0)
    (check-contract "BinaryTree 1: contains(50) should fail on an empty tree" (binary-tree-contains tree root-value) #f))

  ;; Caso 2 — insertar la raíz.
  (let ([tree (insert-all "BinaryTree 2" (binary-tree-init) (list root-value))])
    (check-contract "BinaryTree 2: size should be 1" (binary-tree-size tree) 1)
    (check-contract "BinaryTree 2: is_empty should be false" (binary-tree-is-empty tree) #f)
    (check-contract "BinaryTree 2: contains(50) should succeed" (binary-tree-contains tree root-value) #t))

  ;; Caso 3 — insertar menor y mayor.
  (let* ([values (list root-value lower-value higher-value)]
         [tree (insert-all "BinaryTree 3" (binary-tree-init) values)])
    (check-contract "BinaryTree 3: size should be 3" (binary-tree-size tree) 3)
    (check-all-present "BinaryTree 3" tree values))

  ;; Caso 4 — ramas de varios niveles.
  (let* ([values (list root-value lower-value higher-value lower-leaf-value middle-leaf-value)]
         [tree (insert-all "BinaryTree 4" (binary-tree-init) values)])
    (check-all-present "BinaryTree 4" tree values)
    (check-contract "BinaryTree 4: size should be 5" (binary-tree-size tree) 5))

  ;; Caso 5 — valor ausente en árbol no vacío.
  (let ([tree (insert-all "BinaryTree 5" (binary-tree-init) (list root-value))])
    (check-contract "BinaryTree 5: contains(99) should fail" (binary-tree-contains tree absent-value) #f)
    (check-contract "BinaryTree 5: size should stay 1" (binary-tree-size tree) 1)
    (check-contract "BinaryTree 5: contains(50) should still succeed" (binary-tree-contains tree root-value) #t))

  ;; Caso 6 — duplicado idempotente.
  (let* ([values (list root-value lower-value higher-value)]
         [tree (insert-all "BinaryTree 6" (binary-tree-init) (append values (list lower-value)))])
    (check-contract "BinaryTree 6: size should be 3 after the duplicate" (binary-tree-size tree) 3)
    (check-all-present "BinaryTree 6" tree values))

  ;; Caso 7 — inserciones ordenadas.
  (let* ([values (list lower-leaf-value lower-value middle-leaf-value root-value higher-value)]
         [tree (insert-all "BinaryTree 7" (binary-tree-init) values)])
    (check-contract "BinaryTree 7: size should be 5" (binary-tree-size tree) 5)
    (check-all-present "BinaryTree 7" tree values)
    (check-contract "BinaryTree 7: contains(99) should fail" (binary-tree-contains tree absent-value) #f)))
