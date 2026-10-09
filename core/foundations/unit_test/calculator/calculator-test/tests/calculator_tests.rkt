#lang racket

;; Casos de la especificación 03_Unit_Test_Calculator.
;;
;; Cada caso es un par independiente (entrada → salida esperada), así que el mensaje lleva
;; la conducta y la entrada: `<operación> should be <esperado> for <entrada>`. Se mantienen
;; los cinco casos de la suite original, uno por operación del contrato.
;;
;; Aislamiento: las cinco operaciones son puras sobre enteros, así que ningún caso puede
;; contaminar a los siguientes.

(require rackunit
         "contract.rkt"
         "../../calculator-lib/calculator.rkt")

(module+ test
  ;; addition
  (check-contract "addition should be 5 for 2 and 3" (addition 2 3) 5)

  ;; subtraction
  (check-contract "subtraction should be 3 for 5 and 2" (subtraction 5 2) 3)

  ;; multiplication
  (check-contract "multiplication should be 12 for 3 and 4" (multiplication 3 4) 12)

  ;; division
  (check-contract "division should be 3 for 10 and 3" (division 10 3) 3)

  ;; modulus
  (check-contract "modulus should be 1 for 10 and 3" (modulus 10 3) 1))
