#lang racket

(provide
 sum_of_first_n_rec factorial_rec fibonacci_rec
 greatest_common_divisor_rec least_common_multiple_rec
 sum_of_first_n_acc factorial_acc fibonacci_acc
 greatest_common_divisor_acc least_common_multiple_acc
 sum_of_first_n_ite factorial_ite fibonacci_ite
 greatest_common_divisor_ite least_common_multiple_ite)

;; Direct recursion (_rec)

(define (sum_of_first_n_rec n)
  (if (= n 0)
      0
      (+ n (sum_of_first_n_rec (- n 1)))))

(define (factorial_rec n)
  (if (= n 0)
      1
      (* n (factorial_rec (- n 1)))))

(define (fibonacci_rec n)
  (if (<= n 1)
      n
      (+ (fibonacci_rec (- n 1)) (fibonacci_rec (- n 2)))))

(define (greatest_common_divisor_rec a b)
  (if (= b 0)
      a
      (greatest_common_divisor_rec b (modulo a b))))

(define (least_common_multiple_rec a b)
  (/ (* a b) (greatest_common_divisor_rec a b)))

;; Accumulator recursion (_acc): tail calls, TCO guaranteed in Racket

(define (sum_of_first_n_acc n)
  (sum_of_first_n_acc_help n 0))

(define (sum_of_first_n_acc_help n acc)
  (if (<= n 0)
      acc
      (sum_of_first_n_acc_help (- n 1) (+ n acc))))

(define (factorial_acc n)
  (factorial_acc_help n 1))

(define (factorial_acc_help n acc)
  (if (<= n 1)
      acc
      (factorial_acc_help (- n 1) (* n acc))))

(define (fibonacci_acc n)
  (fibonacci_acc_help n 0 1))

(define (fibonacci_acc_help n acc2 acc1)
  (cond
    [(<= n 0) acc2]
    [(<= n 2) (+ acc1 acc2)]
    [else (fibonacci_acc_help (- n 1) acc1 (+ acc1 acc2))]))

(define (greatest_common_divisor_acc a b)
  (greatest_common_divisor_acc_help a b))

(define (greatest_common_divisor_acc_help a b)
  (if (= b 0)
      a
      (greatest_common_divisor_acc_help b (modulo a b))))

(define (least_common_multiple_acc a b)
  (/ (* a b) (greatest_common_divisor_acc a b)))

;; Iterative (_ite): native do loops

(define (sum_of_first_n_ite n)
  (do ([i 1 (+ i 1)]
       [result 0 (+ result i)])
      [(> i n) result]))

(define (factorial_ite n)
  (do ([i 2 (+ i 1)]
       [result 1 (* result i)])
      [(> i n) result]))

(define (fibonacci_ite n)
  (if (<= n 1)
      n
      (do ([i 2 (+ i 1)]
           [acc2 0 acc1]
           [acc1 1 (+ acc1 acc2)])
          [(> i n) acc1])))

(define (greatest_common_divisor_ite a b)
  (do ([a a b]
       [b b (modulo a b)])
      [(= b 0) a]))

(define (least_common_multiple_ite a b)
  (/ (* a b) (greatest_common_divisor_ite a b)))
