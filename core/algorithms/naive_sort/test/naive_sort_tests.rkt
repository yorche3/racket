#lang racket

(require rackunit)
(require "../src/naive_sort.rkt")

;; Casos de prueba de la especificación 05_Naive_Sort.md
;;
;; Caso nulo incluido: en Racket la lista vacía ES `null` (`(null? '())` da `#t`),
;; así que el indicador de fallo del contrato es `#f`, que sí distingue una
;; entrada nula o inválida de la lista vacía. No se esperan excepciones.
;;
;; Aislamiento: las listas de Racket son inmutables, así que cada caso puede usar
;; la constante compartida sin riesgo de contaminar los siguientes.

(define standard-input (list 5 2 9 1 5 6))
(define standard-output (list 1 2 5 5 6 9))

(define sorted-input (list 1 2 3 4 5))
(define sorted-output (list 1 2 3 4 5))

(define reverse-input (list 5 4 3 2 1))
(define reverse-output (list 1 2 3 4 5))

(define identical-input (list 7 7 7 7))
(define identical-output (list 7 7 7 7))

(define negative-input (list 3 -1 4 -5 0))
(define negative-output (list -5 -1 0 3 4))

(define single-input (list 42))
(define single-output (list 42))

(define empty-input '())
(define empty-output '())

(define invalid-input #f)
(define invalid-output #f)

(define cases
  (list
   (list "an unsorted array" standard-input standard-output)
   (list "an already sorted array" sorted-input sorted-output)
   (list "a reverse ordered array" reverse-input reverse-output)
   (list "an array of identical elements" identical-input identical-output)
   (list "an array with negative numbers" negative-input negative-output)
   (list "a single element array" single-input single-output)
   (list "an empty array" empty-input empty-output)
   (list "a null or invalid input" invalid-input invalid-output)))

;; Helper compartido: recibe la función a probar y el nombre del algoritmo, y
;; ejecuta todos los casos con el mensaje descriptivo del contrato.
(define (assert-sorts-all-cases sort-function algorithm)
  (for ([c (in-list cases)])
    (match-define (list description input expected) c)
    (check-equal?
     (sort-function input)
     expected
     (format "~a should sort ~a" algorithm description))))

(provide naive-sort-suite)

(define naive-sort-suite
  (test-suite
   "naive_sort"
   (test-case "selection_sort"
     (assert-sorts-all-cases selection_sort "selection_sort"))
   (test-case "bubble_sort"
     (assert-sorts-all-cases bubble_sort "bubble_sort"))
   (test-case "insertion_sort"
     (assert-sorts-all-cases insertion_sort "insertion_sort"))))
