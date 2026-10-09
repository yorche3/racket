#lang info

(define collection "data_structures_basics")
(define deps '("base"))
(define build-deps '("data_structures_basics-lib"
                     "scribble-lib"
                     "racket-doc"
                     "sandbox-lib"))
(define version "0.0")
(define pkg-authors '(yorche3))
(define scribblings '(("scribblings/data_structures_basics.scrbl" ())))
(define clean '("compiled" "doc" "doc/data_structures_basics"))
