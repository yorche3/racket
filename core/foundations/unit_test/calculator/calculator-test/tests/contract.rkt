#lang racket

;; Ejecutor compartido de la suite del módulo.
;;
;; Cada caso de 03_Unit_Test_Calculator es un par independiente (entrada → salida
;; esperada), así que el ejecutor recibe el mensaje, el valor observado y el esperado, y
;; compara. El mensaje queda en el formato de la casa,
;; `<sujeto> should <conducta esperada>`:
;;
;;   addition should be 5 for 2 and 3
;;
;; `raco test` recoge los `check-equal?` de los submodules `test` y los cuenta.

(provide check-contract)

(require rackunit)

(define (check-contract message actual expected)
  (check-equal? actual expected message))
