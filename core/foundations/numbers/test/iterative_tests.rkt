#lang racket

(require rackunit)
(require "../src/numbers.rkt")

(provide iterative-suite)

(define iterative-suite
  (test-suite "Iterative Algorithms"
    (test-case "sum_of_first_n_ite"
      (check-equal? (sum_of_first_n_ite 0) 0)
      (check-equal? (sum_of_first_n_ite 3) 6))

    (test-case "factorial_ite"
      (check-equal? (factorial_ite 0) 1)
      (check-equal? (factorial_ite 4) 24))

    (test-case "fibonacci_ite"
      (check-equal? (fibonacci_ite 0) 0)
      (check-equal? (fibonacci_ite 1) 1)
      (check-equal? (fibonacci_ite 6) 8))

    (test-case "greatest_common_divisor_ite"
      (check-equal? (greatest_common_divisor_ite 12 8) 4)
      (check-equal? (greatest_common_divisor_ite 7 5) 1))

    (test-case "least_common_multiple_ite"
      (check-equal? (least_common_multiple_ite 4 6) 12)
      (check-equal? (least_common_multiple_ite 6 8) 24))))

