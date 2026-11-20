#lang racket/base

;; Casos `Graph` de la especificación 07_Data_Structures_Advanced (11 filas).
;; Adaptaciones: el grafo es inmutable; `add_vertex`/`add_edge` devuelven el grafo nuevo
;; (éxito) o `#f` (fallo) y cada caso encadena los grafos devueltos. `get_neighbors`
;; devuelve una lista inmutable o `#f` si el vértice no existe: `'()` ≠ `#f`.
;; No representable (caso 11): modificar la copia devuelta, porque la lista es inmutable;
;; se conserva el resto del escenario.

(require "contract.rkt"
         "../../data_structures_advanced-lib/data-structures-advanced.rkt")

;; Fixtures: un nombre por etiqueta.
(define label-ten 10)
(define label-thirty 30)
(define label-fifty 50)
(define label-seventy 70)
(define missing-label 99)
(define other-missing-label 98)

;; Aplica una operación comprobando que tiene éxito; devuelve el grafo resultante.
(define (step-ok message graph operation . args)
  (define next (and graph (apply operation graph args)))
  (check-contract message (succeeded? next) #t)
  next)

(define (build-graph message labels)
  (for/fold ([graph (graph-init)]) ([label (in-list labels)])
    (step-ok (format "~a: add_vertex(~a) should succeed" message label) graph graph-add-vertex label)))

(define (check-counts message graph vertices edges)
  (check-contract (format "~a: vertex_count should be ~a" message vertices) (graph-vertex-count graph) vertices)
  (check-contract (format "~a: edge_count should be ~a" message edges) (graph-edge-count graph) edges))

(module+ test
  ;; Caso 1 — crear vacío.
  (let ([graph (graph-init)])
    (check-contract "Graph 1: is_empty should be true after init" (graph-is-empty graph) #t)
    (check-counts "Graph 1" graph 0 0)
    (check-contract "Graph 1: has_edge(10,30) should fail" (graph-has-edge graph label-ten label-thirty) #f)
    (check-contract "Graph 1: get_neighbors(10) should fail" (graph-get-neighbors graph label-ten) #f))

  ;; Caso 2 — vértice aislado.
  (let ([graph (build-graph "Graph 2" (list label-ten))])
    (check-contract "Graph 2: is_empty should be false" (graph-is-empty graph) #f)
    (check-counts "Graph 2" graph 1 0)
    (check-contract "Graph 2: neighbours of 10 should be empty" (graph-get-neighbors graph label-ten) '()))

  ;; Caso 3 — etiquetas no consecutivas y arista dirigida.
  (let* ([graph (build-graph "Graph 3" (list label-ten label-seventy))]
         [graph (step-ok "Graph 3: add_edge(10,70) should succeed" graph graph-add-edge label-ten label-seventy)])
    (check-contract "Graph 3: has_edge(10,70) should succeed" (graph-has-edge graph label-ten label-seventy) #t)
    (check-contract "Graph 3: has_edge(70,10) should fail" (graph-has-edge graph label-seventy label-ten) #f)
    (check-counts "Graph 3" graph 2 1))

  ;; Caso 4 — vértice duplicado conserva adyacencia.
  (let* ([graph (build-graph "Graph 4" (list label-ten label-thirty))]
         [graph (step-ok "Graph 4: add_edge(10,30) should succeed" graph graph-add-edge label-ten label-thirty)]
         [graph (step-ok "Graph 4: duplicate add_vertex(10) should succeed" graph graph-add-vertex label-ten)])
    (check-counts "Graph 4" graph 2 1)
    (check-contract "Graph 4: neighbours of 10 should be (30)" (graph-get-neighbors graph label-ten) (list label-thirty)))

  ;; Caso 5 — arista duplicada.
  (let* ([graph (build-graph "Graph 5" (list label-ten label-thirty))]
         [graph (step-ok "Graph 5: first add_edge(10,30) should succeed" graph graph-add-edge label-ten label-thirty)]
         [graph (step-ok "Graph 5: second add_edge(10,30) should succeed" graph graph-add-edge label-ten label-thirty)])
    (check-counts "Graph 5" graph 2 1)
    (check-contract "Graph 5: neighbours of 10 should be (30)" (graph-get-neighbors graph label-ten) (list label-thirty)))

  ;; Caso 6 — extremo inexistente sin mutación.
  (let* ([graph (build-graph "Graph 6" (list label-ten label-thirty))]
         [graph (step-ok "Graph 6: add_edge(10,30) should succeed" graph graph-add-edge label-ten label-thirty)])
    (check-contract "Graph 6: add_edge(10,99) should fail" (graph-add-edge graph label-ten missing-label) #f)
    (check-contract "Graph 6: add_edge(99,10) should fail" (graph-add-edge graph missing-label label-ten) #f)
    (check-contract "Graph 6: add_edge(98,99) should fail" (graph-add-edge graph other-missing-label missing-label) #f)
    (check-contract "Graph 6: add_edge(99,99) should fail" (graph-add-edge graph missing-label missing-label) #f)
    (check-counts "Graph 6" graph 2 1)
    (check-contract "Graph 6: neighbours of 10 should be (30)" (graph-get-neighbors graph label-ten) (list label-thirty))
    (check-contract "Graph 6: neighbours of 30 should be empty" (graph-get-neighbors graph label-thirty) '())
    (check-contract "Graph 6: has_edge(10,99) should fail" (graph-has-edge graph label-ten missing-label) #f)
    (check-contract "Graph 6: has_edge(99,10) should fail" (graph-has-edge graph missing-label label-ten) #f)
    (check-contract "Graph 6: has_edge(98,99) should fail" (graph-has-edge graph other-missing-label missing-label) #f)
    (check-contract "Graph 6: has_edge(99,99) should fail" (graph-has-edge graph missing-label missing-label) #f)
    (check-contract "Graph 6: get_neighbors(98) should fail" (graph-get-neighbors graph other-missing-label) #f)
    (check-contract "Graph 6: get_neighbors(99) should fail" (graph-get-neighbors graph missing-label) #f))

  ;; Caso 7 — vecinos ordenados y contadores.
  (let* ([graph (build-graph "Graph 7" (list label-ten label-thirty label-fifty label-seventy))]
         [graph (step-ok "Graph 7: add_edge(10,70) should succeed" graph graph-add-edge label-ten label-seventy)]
         [graph (step-ok "Graph 7: add_edge(10,30) should succeed" graph graph-add-edge label-ten label-thirty)]
         [graph (step-ok "Graph 7: add_edge(10,50) should succeed" graph graph-add-edge label-ten label-fifty)]
         [graph (step-ok "Graph 7: add_edge(30,50) should succeed" graph graph-add-edge label-thirty label-fifty)])
    (check-contract "Graph 7: neighbours of 10 should be (30 50 70)"
                    (graph-get-neighbors graph label-ten) (list label-thirty label-fifty label-seventy))
    (check-contract "Graph 7: neighbours of 30 should be (50)" (graph-get-neighbors graph label-thirty) (list label-fifty))
    (check-contract "Graph 7: neighbours of 50 should be empty" (graph-get-neighbors graph label-fifty) '())
    (check-contract "Graph 7: neighbours of 70 should be empty" (graph-get-neighbors graph label-seventy) '())
    (check-counts "Graph 7" graph 4 4))

  ;; Caso 8 — consulta de arista ausente.
  (let ([graph (build-graph "Graph 8" (list label-ten label-thirty))])
    (check-contract "Graph 8: has_edge(10,30) should fail" (graph-has-edge graph label-ten label-thirty) #f)
    (check-counts "Graph 8" graph 2 0)
    (check-contract "Graph 8: is_empty should be false" (graph-is-empty graph) #f))

  ;; Caso 9 — vecinos de vértice inexistente.
  (let ([graph (build-graph "Graph 9" (list label-ten))])
    (check-contract "Graph 9: get_neighbors(99) should fail (#f)" (graph-get-neighbors graph missing-label) #f)
    (check-contract "Graph 9: neighbours of 10 should be empty, not failure" (graph-get-neighbors graph label-ten) '())
    (check-counts "Graph 9" graph 1 0))

  ;; Caso 10 — bucle y duplicado.
  (let* ([graph (build-graph "Graph 10" (list label-ten))]
         [graph (step-ok "Graph 10: first add_edge(10,10) should succeed" graph graph-add-edge label-ten label-ten)]
         [graph (step-ok "Graph 10: second add_edge(10,10) should succeed" graph graph-add-edge label-ten label-ten)])
    (check-contract "Graph 10: has_edge(10,10) should succeed" (graph-has-edge graph label-ten label-ten) #t)
    (check-contract "Graph 10: neighbours of 10 should be (10)" (graph-get-neighbors graph label-ten) (list label-ten))
    (check-counts "Graph 10" graph 1 1))

  ;; Caso 11 — aislamiento del resultado de vecinos (sin modificar la copia: inmutable).
  (let* ([graph (build-graph "Graph 11" (list label-ten label-thirty label-fifty))]
         [graph (step-ok "Graph 11: add_edge(10,30) should succeed" graph graph-add-edge label-ten label-thirty)]
         [saved (graph-get-neighbors graph label-ten)]
         [graph (step-ok "Graph 11: add_edge(10,50) should succeed" graph graph-add-edge label-ten label-fifty)])
    (check-contract "Graph 11: the saved neighbours should remain (30)" saved (list label-thirty))
    (check-contract "Graph 11: a fresh query should return (30 50)"
                    (graph-get-neighbors graph label-ten) (list label-thirty label-fifty))
    (check-counts "Graph 11" graph 3 2)))
