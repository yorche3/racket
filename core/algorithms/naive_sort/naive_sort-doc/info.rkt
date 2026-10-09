#lang info

(define collection "naive_sort")
(define deps '("base"))
(define build-deps '("naive_sort-lib"
                     "scribble-lib"
                     "racket-doc"
                     "sandbox-lib"))
(define version "0.0")
(define pkg-authors '(yorche3))
(define scribblings '(("scribblings/naive_sort.scrbl" ())))
(define clean '("compiled" "doc" "doc/naive_sort"))
