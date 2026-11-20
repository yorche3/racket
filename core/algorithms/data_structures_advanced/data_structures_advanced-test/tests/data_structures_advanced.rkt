#lang racket

(require rackunit
         rackunit/text-ui
         "../../data_structures_advanced-lib/data-structures-advanced.rkt")

(define tests
  (test-suite
   "Tests for data_structures_advanced"))

(module+ test
  (void
   (run-tests tests)))
