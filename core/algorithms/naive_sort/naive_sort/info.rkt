#lang info

(define version "0.0")
(define collection 'multi)
(define deps '("base"
               "naive_sort-lib"
               "naive_sort-doc"
               "naive_sort-test"))
(define build-deps '())
(define implies '("naive_sort-lib"
                  "naive_sort-doc"
                  "naive_sort-test"))
