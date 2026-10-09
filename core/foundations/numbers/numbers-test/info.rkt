#lang info

(define collection "numbers")
(define deps '("base"))
(define build-deps '("numbers-lib"
                     "rackunit-lib"))
(define version "0.0")
(define pkg-authors '(yorche3))
(define clean '("compiled" "tests/compiled"))
