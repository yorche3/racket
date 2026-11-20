#lang info

(define collection "data_structures_advanced")
(define deps '("base"))
(define build-deps '("data_structures_advanced-lib"
                     "scribble-lib"
                     "racket-doc"
                     "sandbox-lib"))
(define version "0.0")
(define pkg-authors '(yorche3))
(define scribblings '(("scribblings/data_structures_advanced.scrbl" ())))
(define clean '("compiled" "doc" "doc/data_structures_advanced"))
