#lang racket/base

(provide hello
         tree-node-init tree-node-get-value tree-node-get-left tree-node-get-right
         tree-node-set-left tree-node-set-right
         binary-tree-init binary-tree-insert binary-tree-contains
         binary-tree-is-empty binary-tree-size
         graph-init graph-add-vertex graph-add-edge graph-has-edge
         graph-get-neighbors graph-is-empty graph-vertex-count graph-edge-count)

(require racket/format)

(define (hello [name "World"])
  (~a "Hello, " name "!"))

(struct tree-node (value left right))
(struct binary-tree (root count))
(struct graph-node (value neighbors next-vertex))
(struct graph (vertices vertex-total edges))

;; TreeNode: init integer -> node; getters -> integer or node/#f;
;; setters (node, node/#f) -> new node.
(define (tree-node-init value) #f)
(define (tree-node-get-value node) #f)
(define (tree-node-get-left node) #f)
(define (tree-node-get-right node) #f)
(define (tree-node-set-left node left) #f)
(define (tree-node-set-right node right) #f)

;; BinaryTree: init -> tree; insert (tree, integer) -> new tree;
;; contains and is-empty -> boolean; size -> nonnegative integer.
(define (binary-tree-init) #f)
(define (binary-tree-insert tree value) #f)
(define (binary-tree-contains tree value) #f)
(define (binary-tree-is-empty tree) #f)
(define (binary-tree-size tree) #f)

(define (graph-node-init label) #f)

;; Graph: init -> graph; updates -> new graph, or #f for a missing endpoint.
;; has-edge and is-empty -> boolean; counts -> nonnegative integer;
;; get-neighbors -> immutable list of integers, or #f for a missing vertex.
(define (graph-init) #f)
(define (graph-add-vertex graph label) #f)
(define (graph-add-edge graph source target) #f)
(define (graph-has-edge graph source target) #f)
(define (graph-get-neighbors graph label) #f)
(define (graph-is-empty graph) #f)
(define (graph-vertex-count graph) #f)
(define (graph-edge-count graph) #f)
