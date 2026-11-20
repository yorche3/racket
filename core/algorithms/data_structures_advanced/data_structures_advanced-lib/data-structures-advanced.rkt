#lang racket/base

;; data_structures_advanced — árbol binario de búsqueda y grafo dirigido sobre
;; structs inmutables.
;;
;; Especificación: 07_Data_Structures_Advanced
;;
;; Contrato Racket: structs y una función por operación, con identificadores en
;; kebab-case. La ausencia es `#f` y los fallos son `#f`; las actualizaciones
;; devuelven el valor nuevo en lugar de mutar.

(provide tree-node-init tree-node-get-value tree-node-get-left
         tree-node-get-right tree-node-set-left tree-node-set-right
         binary-tree-init binary-tree-insert binary-tree-contains
         binary-tree-is-empty binary-tree-size
         graph-init graph-add-vertex graph-add-edge graph-has-edge
         graph-get-neighbors graph-is-empty graph-vertex-count
         graph-edge-count)

(require racket/list)

(struct tree-node (value left right))
(struct binary-tree (root count))
(struct graph-node (value neighbors next-vertex))
(struct graph (vertices vertex-total edges))

;; TreeNode: init integer -> node; getters -> integer or node/#f;
;; setters (node, node/#f) -> new node.
(define (tree-node-init value)
  (tree-node value #f #f))
(define (tree-node-get-value node)
  (tree-node-value node))
(define (tree-node-get-left node)
  (tree-node-left node))
(define (tree-node-get-right node)
  (tree-node-right node))
(define (tree-node-set-left node left)
  (tree-node (tree-node-value node) left (tree-node-right node)))
(define (tree-node-set-right node right)
  (tree-node (tree-node-value node) (tree-node-left node) right))

;; BinaryTree: init -> tree; insert (tree, integer) -> new tree;
;; contains and is-empty -> boolean; size -> nonnegative integer.
(define (binary-tree-init)
  (binary-tree #f 0))

(define (tree-insert-node node value)
  (cond
    [(not node) (values (tree-node value #f #f) #t)]
    [(= value (tree-node-value node)) (values node #f)]
    [(< value (tree-node-value node))
     (define-values (new-left inserted?)
       (tree-insert-node (tree-node-left node) value))
     (values (tree-node (tree-node-value node) new-left
                        (tree-node-right node))
             inserted?)]
    [else
     (define-values (new-right inserted?)
       (tree-insert-node (tree-node-right node) value))
     (values (tree-node (tree-node-value node) (tree-node-left node)
                        new-right)
             inserted?)]))

(define (binary-tree-insert tree value)
  (define-values (new-root inserted?)
    (tree-insert-node (binary-tree-root tree) value))
  (if inserted?
      (binary-tree new-root (+ (binary-tree-count tree) 1))
      tree))

(define (binary-tree-contains tree value)
  (define (tree-contains-node node value)
    (cond
      [(not node) #f]
      [(= value (tree-node-value node)) #t]
      [(< value (tree-node-value node))
       (tree-contains-node (tree-node-left node) value)]
      [else (tree-contains-node (tree-node-right node) value)]))
  (tree-contains-node (binary-tree-root tree) value))

(define (binary-tree-is-empty tree)
  (zero? (binary-tree-count tree)))

(define (binary-tree-size tree)
  (binary-tree-count tree))

(define (graph-node-init label)
  (graph-node label '() #f))

;; Graph: init -> graph; updates -> new graph, or #f for a missing endpoint.
;; has-edge and is-empty -> boolean; counts -> nonnegative integer;
;; get-neighbors -> immutable list of integers, or #f for a missing vertex.
(define (graph-init)
  (graph #f 0 0))

;; Recorre el registro canónico enlazado por next-vertex.
(define (find-vertex node label)
  (cond
    [(not node) #f]
    [(= label (graph-node-value node)) node]
    [else (find-vertex (graph-node-next-vertex node) label)]))

(define (has-neighbor? neighbors label)
  (cond
    [(empty? neighbors) #f]
    [(= label (first neighbors)) #t]
    [else (has-neighbor? (rest neighbors) label)]))

;; Inserción ordenada y sin duplicados, sin ordenamiento de biblioteca.
(define (insert-neighbor neighbors label)
  (cond
    [(empty? neighbors) (list label)]
    [(<= label (first neighbors)) (cons label neighbors)]
    [else (cons (first neighbors) (insert-neighbor (rest neighbors) label))]))

;; Copia la cadena sustituyendo la adyacencia del vértice indicado.
(define (update-neighbors node label neighbors)
  (cond
    [(not node) #f]
    [(= label (graph-node-value node))
     (graph-node label neighbors (graph-node-next-vertex node))]
    [else
     (define rest-updated
       (update-neighbors (graph-node-next-vertex node) label neighbors))
     (and rest-updated
          (graph-node (graph-node-value node) (graph-node-neighbors node)
                      rest-updated))]))

(define (graph-add-vertex g label)
  (if (find-vertex (graph-vertices g) label)
      g
      (graph (graph-node label '() (graph-vertices g))
             (+ (graph-vertex-total g) 1)
             (graph-edges g))))

(define (graph-add-edge g source target)
  (define source-node (find-vertex (graph-vertices g) source))
  (cond
    [(not source-node) #f]
    [(not (find-vertex (graph-vertices g) target)) #f]
    [(has-neighbor? (graph-node-neighbors source-node) target) g]
    [else
     (graph (update-neighbors (graph-vertices g) source
                              (insert-neighbor
                               (graph-node-neighbors source-node) target))
            (graph-vertex-total g)
            (+ (graph-edges g) 1))]))

(define (graph-has-edge g source target)
  (define source-node (find-vertex (graph-vertices g) source))
  (and source-node
       (has-neighbor? (graph-node-neighbors source-node) target)))

(define (graph-get-neighbors g label)
  (define node (find-vertex (graph-vertices g) label))
  (and node (graph-node-neighbors node)))

(define (graph-is-empty g)
  (not (graph-vertices g)))

(define (graph-vertex-count g)
  (graph-vertex-total g))

(define (graph-edge-count g)
  (graph-edges g))
