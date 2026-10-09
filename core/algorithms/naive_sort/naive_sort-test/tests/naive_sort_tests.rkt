#lang racket

;; Casos de la especificación 05_Naive_Sort.
;;
;; Tabla de casos: cada uno es un par independiente (entrada → salida esperada), así que
;; el ejecutor los recorre con las tres funciones del contrato y el mismo mensaje
;; `<algoritmo> should sort <descripción>`. La lista vacía es `null` en Racket
;; (`(null? '())` da `#t`), así que el indicador de fallo del contrato es `#f`, que sí
;; distingue una entrada nula o inválida de la lista vacía. No se esperan excepciones.
;;
;; Aislamiento: las listas de Racket son inmutables, así que la tabla puede compartirse
;; sin riesgo de contaminar los casos siguientes; cada caso recibe su propio valor.

(require rackunit
         "contract.rkt"
         "../../naive_sort-lib/naive-sort.rkt")

;; Fixtures: un nombre por valor del escenario.
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

;; Cada caso: descripción, entrada y salida esperada.
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

;; Ejecutor del escenario: recorre la tabla con una de las funciones del contrato.
(define (check-sorts-all-cases sort-function algorithm)
  (for ([c (in-list cases)])
    (match-define (list description input expected) c)
    (check-contract (format "~a should sort ~a" algorithm description)
                    (sort-function input)
                    expected)))

(module+ test
  (check-sorts-all-cases selection-sort "selection_sort")
  (check-sorts-all-cases bubble-sort "bubble_sort")
  (check-sorts-all-cases insertion-sort "insertion_sort"))
