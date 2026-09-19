#lang racket

;; naive_sort — ordenamientos elementales O(n²).
;;
;; Especificación: 05_Naive_Sort
;;
;; Contrato: recibe una lista de enteros y devuelve la lista ordenada de menor a
;; mayor (in-place o como copia ordenada), sin invocar `sort` ni ninguna
;; biblioteca de ordenamiento, y sin estructuras auxiliares complejas.
;; Si la entrada es nula o inválida devuelve `#f` como indicador de fallo; si
;; está vacía devuelve la misma lista vacía. No lanza excepciones.
;;
;; Implementación pendiente: la escribe el autor. Esta delegación solo genera el
;; esqueleto y las pruebas unitarias.
(provide
    selection-sort
    bubble-sort
    insertion-sort)

(define (selection-sort arr)
  (if (or (not (list? arr)) (null? arr))
      #f
      (let loop ((lst arr) (sorted '()))
        (if (null? lst)
            (reverse sorted)
            (let* ((min (apply min lst))
                   (rest (remove min lst)))
              (loop rest (cons min sorted)))))))

(define (bubble-sort arr)
  (if (or (not (list? arr)) (null? arr))
      #f
      (let loop ((lst arr) (n (length arr)))
        (if (= n 1)
            lst
            (begin
              (for ((i (- n 1)))
                (when (> (list-ref lst i) (list-ref lst (+ i 1)))
                  (let ((temp (list-ref lst i)))
                    (set! lst (list-set lst i (list-ref lst (+ i 1))))
                    (set! lst (list-set lst (+ i 1) temp)))))
              (loop lst (- n 1)))))))

(define (insertion-sort arr)
  (if (or (not (list? arr)) (null? arr))
      #f
      (let loop ((lst arr) (sorted '()))
        (if (null? lst)
            (reverse sorted)
            (let* ((current (car lst))
                   (rest (cdr lst)))
              (let insert ((s sorted))
                (if (or (null? s) (< current (car s)))
                    (loop rest (cons current s))
                    (insert (cdr s)))))))))