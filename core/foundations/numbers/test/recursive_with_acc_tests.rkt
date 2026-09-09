#lang racket

(require rackunit)
(require "../src/numbers.rkt")

(provide recursive-with-acc-suite)

(define recursive-with-acc-suite
  (test-suite "Recursive with Accumulator Algorithms"
    (test-case "sum_of_first_n_acc"
      (check-equal? (sum_of_first_n_acc 0) 0)
      (check-equal? (sum_of_first_n_acc 3) 6))

    (test-case "factorial_acc"
      (check-equal? (factorial_acc 0) 1)
      (check-equal? (factorial_acc 4) 24))

    (test-case "fibonacci_acc"
      (check-equal? (fibonacci_acc 0) 0)
      (check-equal? (fibonacci_acc 1) 1)
      (check-equal? (fibonacci_acc 6) 8))

    (test-case "greatest_common_divisor_acc"
      (check-equal? (greatest_common_divisor_acc 12 8) 4)
      (check-equal? (greatest_common_divisor_acc 7 5) 1))

    (test-case "least_common_multiple_acc"
      (check-equal? (least_common_multiple_acc 4 6) 12)
      (check-equal? (least_common_multiple_acc 6 8) 24))))

