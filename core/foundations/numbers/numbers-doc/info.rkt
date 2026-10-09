#lang info

(define collection "numbers")
(define deps '("base"))
(define build-deps '("numbers-lib"
                     "scribble-lib"
                     "racket-doc"
                     "sandbox-lib"))
(define version "0.0")
(define pkg-authors '(yorche3))
(define scribblings '(("scribblings/numbers.scrbl" ())))
(define clean '("compiled" "doc" "doc/numbers"))
