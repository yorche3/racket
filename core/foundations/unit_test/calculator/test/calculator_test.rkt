#lang racket

(require rackunit
         "../src/calculator.rkt")

(check-equal? (addition 2 3) 5 "addition")
(check-equal? (subtraction 5 2) 3 "subtraction")
(check-equal? (multiplication 3 4) 12 "multiplication")
(check-equal? (division 10 3) 3 "division")
(check-equal? (modulus 10 3) 1 "modulus")
