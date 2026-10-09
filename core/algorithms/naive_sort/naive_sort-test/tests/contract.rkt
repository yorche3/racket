#lang racket

;; Ejecutor compartido de la suite del módulo.
;;
;; Los casos de 05_Naive_Sort son pares (entrada, salida) independientes, así que el
;; ejecutor recibe el mensaje, el valor observado y el esperado, y compara. El mensaje
;; queda en el formato de la casa, `<sujeto> should <conducta esperada>`:
;;
;;   selection-sort should sort an unsorted array
;;
;; `raco test` recoge los `check-equal?` de los submodules `test` y los cuenta.

(provide check-contract)

(require rackunit)

(define (check-contract message actual expected)
  (check-equal? actual expected message))
