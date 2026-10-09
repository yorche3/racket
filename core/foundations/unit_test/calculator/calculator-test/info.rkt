#lang info

(define collection "calculator")
(define deps '("base"))
(define build-deps '("calculator-lib"
                     "rackunit-lib"))
(define version "0.0")
(define pkg-authors '(yorche3))
(define clean '("compiled" "tests/compiled"))
