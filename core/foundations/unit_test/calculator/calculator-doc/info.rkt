#lang info

(define collection "calculator")
(define deps '("base"))
(define build-deps '("calculator-lib"
                     "scribble-lib"
                     "racket-doc"
                     "sandbox-lib"))
(define version "0.0")
(define pkg-authors '(yorche3))
(define scribblings '(("scribblings/calculator.scrbl" ())))
(define clean '("compiled" "doc" "doc/calculator"))
