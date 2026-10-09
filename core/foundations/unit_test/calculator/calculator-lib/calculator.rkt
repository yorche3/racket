#lang racket

(provide addition subtraction multiplication division modulus)

(define (addition a b)
  (+ a b))

(define (subtraction a b)
  (- a b))

(define (multiplication a b)
  (let loop ([i 0] [result 0])
    (if (= i b)
        result
        (loop (+ i 1) (addition result a)))))

(define (division a b)
  (let loop ([a a] [quotient 0])
    (if (< a b)
        quotient
        (loop (subtraction a b) (addition quotient 1)))))

(define (modulus a b)
  (define q (division a b))
  (define p (multiplication q b))
  (subtraction a p))
