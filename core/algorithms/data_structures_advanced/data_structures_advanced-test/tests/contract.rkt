#lang racket/base

;; Ejecutor compartido de la suite del módulo.
;;
;; Los casos de 07_Data_Structures_Advanced son pasos sucesivos sobre una instancia
;; recién creada, así que el ejecutor recibe el mensaje del paso, el valor observado y el
;; esperado. El mensaje sigue el formato de la casa, `<sujeto> should <conducta esperada>`.
;; `succeeded?` normaliza el indicador de éxito (cualquier valor distinto de #f) a booleano.

(provide check-contract succeeded?)

(require rackunit)

(define (check-contract message actual expected)
  (check-equal? actual expected message))

(define (succeeded? result)
  (if result #t #f))
