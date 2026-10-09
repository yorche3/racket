#lang info

(define version "0.0")
(define collection 'multi)
(define deps '("base"
               "calculator-lib"
               "calculator-doc"
               "calculator-test"))
(define build-deps '())
(define implies '("calculator-lib"
                  "calculator-doc"
                  "calculator-test"))
