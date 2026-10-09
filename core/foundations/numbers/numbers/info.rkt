#lang info

(define version "0.0")
(define collection 'multi)
(define deps '("base"
               "numbers-lib"
               "numbers-doc"
               "numbers-test"))
(define build-deps '())
(define implies '("numbers-lib"
                  "numbers-doc"
                  "numbers-test"))
