#lang racket

(require rackunit)
(require "../src/numbers.rkt")

(provide recursive-suite)

(define recursive-suite
  (test-suite "Recursive Algorithms"
    (test-case "sum_of_first_n_rec"
      (check-equal? (sum_of_first_n_rec 0) 0)
      (check-equal? (sum_of_first_n_rec 3) 6))

    (test-case "factorial_rec"
      (check-equal? (factorial_rec 0) 1)
      (check-equal? (factorial_rec 4) 24))

    (test-case "fibonacci_rec"
      (check-equal? (fibonacci_rec 0) 0)
      (check-equal? (fibonacci_rec 1) 1)
      (check-equal? (fibonacci_rec 6) 8))

    (test-case "greatest_common_divisor_rec"
      (check-equal? (greatest_common_divisor_rec 12 8) 4)
      (check-equal? (greatest_common_divisor_rec 7 5) 1))

    (test-case "least_common_multiple_rec"
      (check-equal? (least_common_multiple_rec 4 6) 12)
      (check-equal? (least_common_multiple_rec 6 8) 24))))

