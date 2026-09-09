#lang racket

(require rackunit)
(require "../src/calculator.rkt")

(provide calculator-suite)

(define calculator-suite
  (test-suite "Calculator"
    (test-case "addition"
      (check-equal? (addition 2 3) 5))

    (test-case "subtraction"
      (check-equal? (subtraction 5 2) 3))

    (test-case "multiplication"
      (check-equal? (multiplication 3 4) 12))

    (test-case "division"
      (check-equal? (division 10 3) 3))

    (test-case "modulus"
      (check-equal? (modulus 10 3) 1))))

