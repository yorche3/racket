#lang racket

;; Casos de la especificación 04_Numbers — recursión directa (`_rec`).
;;
;; Cada caso es un par independiente (entrada → salida esperada), así que el mensaje lleva
;; la conducta y la entrada: `<función> should be <esperado> for <entrada>`. Se mantienen
;; los cinco grupos de la suite original, uno por algoritmo.
;;
;; Aislamiento: las funciones del contrato son puras sobre enteros, así que ningún caso
;; puede contaminar a los siguientes.

(require rackunit
         "contract.rkt"
         "../../numbers-lib/numbers.rkt")

(module+ test
  ;; sum_of_first_n_rec
  (check-contract "sum_of_first_n_rec should be 0 for n = 0" (sum_of_first_n_rec 0) 0)
  (check-contract "sum_of_first_n_rec should be 6 for n = 3" (sum_of_first_n_rec 3) 6)

  ;; factorial_rec
  (check-contract "factorial_rec should be 1 for n = 0" (factorial_rec 0) 1)
  (check-contract "factorial_rec should be 24 for n = 4" (factorial_rec 4) 24)

  ;; fibonacci_rec
  (check-contract "fibonacci_rec should be 0 for n = 0" (fibonacci_rec 0) 0)
  (check-contract "fibonacci_rec should be 1 for n = 1" (fibonacci_rec 1) 1)
  (check-contract "fibonacci_rec should be 8 for n = 6" (fibonacci_rec 6) 8)

  ;; greatest_common_divisor_rec
  (check-contract "greatest_common_divisor_rec should be 4 for 12 and 8"
                  (greatest_common_divisor_rec 12 8) 4)
  (check-contract "greatest_common_divisor_rec should be 1 for 7 and 5"
                  (greatest_common_divisor_rec 7 5) 1)

  ;; least_common_multiple_rec
  (check-contract "least_common_multiple_rec should be 12 for 4 and 6"
                  (least_common_multiple_rec 4 6) 12)
  (check-contract "least_common_multiple_rec should be 24 for 6 and 8"
                  (least_common_multiple_rec 6 8) 24))
