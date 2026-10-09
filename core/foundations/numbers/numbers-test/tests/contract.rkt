#lang racket

;; Ejecutor compartido de la suite del módulo.
;;
;; Cada caso de 04_Numbers es un par independiente (entrada → salida esperada), así que el
;; ejecutor recibe el mensaje, el valor observado y el esperado, y compara. El mensaje
;; queda en el formato de la casa, `<sujeto> should <conducta esperada>`:
;;
;;   sum_of_first_n_rec should be 6 for n = 3
;;
;; `raco test` recoge los `check-equal?` de los submodules `test` y los cuenta.

(provide check-contract)

(require rackunit)

(define (check-contract message actual expected)
  (check-equal? actual expected message))
