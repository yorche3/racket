#lang racket

;; naive_sort — ordenamientos elementales O(n²).
;;
;; Especificación: 05_Naive_Sort
;;
;; Contrato: recibe una lista de enteros y devuelve la lista ordenada de menor a
;; mayor (in-place o como copia ordenada), sin invocar `sort` ni ninguna
;; biblioteca de ordenamiento, y sin estructuras auxiliares complejas.
;; Si la entrada es nula o inválida devuelve `#f` como indicador de fallo; si
;; está vacía devuelve la misma lista vacía. No lanza excepciones.
;;
;; Implementación pendiente: la escribe el autor. Esta delegación solo genera el
;; esqueleto y las pruebas unitarias.
(provide
    selection-sort
    bubble-sort
    insertion-sort)

;; selection-sort: ordena una copia ascendente con el algoritmo de selección O(n^2)
;; input: una lista de enteros (opcional, no se muta la entrada)
;; output: una lista nueva ordenada, o #f si la entrada no es una lista
(define (selection-sort arr)
  (cond
    [(not (list? arr)) #f]
    [(or (null? arr) (null? (cdr arr))) arr]
    [else
     ;; El vector es la representación indexable que el pseudocódigo necesita:
     ;; con listas, cada intercambio costaría O(n) y el algoritmo sería O(n^3).
     (define v (list->vector arr))
     (define n (vector-length v))
     (for ([i (in-range 0 (- n 1))])
       (define min-idx i)
       (for ([j (in-range (add1 i) n)])
         (when (< (vector-ref v j) (vector-ref v min-idx))
           (set! min-idx j)))
       (unless (= min-idx i)
         (define temp (vector-ref v i))
         (vector-set! v i (vector-ref v min-idx))
         (vector-set! v min-idx temp)))
     (vector->list v)]))

;; bubble-sort: ordena una copia ascendente con el algoritmo de burbuja O(n^2) y
;; su bandera de salida temprana
;; input: una lista de enteros (opcional, no se muta la entrada)
;; output: una lista nueva ordenada, o #f si la entrada no es una lista
(define (bubble-sort arr)
  (cond
    [(not (list? arr)) #f]
    [(or (null? arr) (null? (cdr arr))) arr]
    [else
     (define v (list->vector arr))
     (define n (vector-length v))
     (let pass ([i 0] [swapped #t])
       (cond
         [(or (>= i (- n 1)) (not swapped)) (vector->list v)]
         [else
          (define did-swap #f)
          (for ([j (in-range 0 (- n 1 i))])
            (when (> (vector-ref v j) (vector-ref v (add1 j)))
              (define temp (vector-ref v j))
              (vector-set! v j (vector-ref v (add1 j)))
              (vector-set! v (add1 j) temp)
              (set! did-swap #t)))
          (pass (add1 i) did-swap)]))]))

;; insertion-sort: ordena una copia ascendente desplazando cada clave a su posición
;; input: una lista de enteros (opcional, no se muta la entrada)
;; output: una lista nueva ordenada, o #f si la entrada no es una lista
(define (insertion-sort arr)
  (cond
    [(not (list? arr)) #f]
    [(or (null? arr) (null? (cdr arr))) arr]
    [else
     (define v (list->vector arr))
     (define n (vector-length v))
     (for ([i (in-range 1 n)])
       (define key (vector-ref v i))
       (define j (sub1 i))
       (let shift ()
         (when (and (>= j 0) (> (vector-ref v j) key))
           (vector-set! v (add1 j) (vector-ref v j))
           (set! j (sub1 j))
           (shift)))
       (vector-set! v (add1 j) key))
     (vector->list v)]))
