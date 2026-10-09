#lang racket/base

;; Casos del contrato `Stack` de la especificación 06_Data_Structures_Basics.
;;
;; Los cuatro pasos corren sobre la misma pila: se declara una vez con `stack-init` y cada
;; paso continúa el estado anterior, sin reiniciar el escenario. Aislamiento: la instancia
;; es la del propio escenario.

(require rackunit
         "contract.rkt"
         "../../data_structures_basics-lib/data-structures-basics.rkt")

;; Fixtures: un nombre por valor del escenario.
(define pushed-first 10)
(define pushed-second 20)
(define pushed-third 30)
(define pushed-after-pop 40)

(module+ test
  (define stack (stack-init))

  ;; Paso 1 — estado vacío y extracción fallida.
  (check-contract "Stack 1: is_empty should be true after init" (stack-is-empty stack) #t)
  (check-contract "Stack 1: size should be 0 after init" (stack-size stack) 0)
  (check-contract "Stack 1: peek on an empty stack should return #f" (stack-peek stack) #f)
  (check-contract "Stack 1: pop on an empty stack should return #f" (stack-pop stack) #f)
  (check-contract "Stack 1: a failed pop should keep the stack empty" (stack-is-empty stack) #t)

  ;; Paso 2 — LIFO y `peek` no mutante.
  (stack-push stack pushed-first)
  (stack-push stack pushed-second)
  (stack-push stack pushed-third)
  (check-contract "Stack 2: peek should return 30" (stack-peek stack) pushed-third)
  (check-contract "Stack 2: size should be 3 after three pushes" (stack-size stack) 3)

  ;; Paso 3 — extracción y reutilización.
  (check-contract "Stack 3: the first pop should return 30" (stack-pop stack) pushed-third)
  (stack-push stack pushed-after-pop)
  (check-contract "Stack 3: the reused top should return 40" (stack-pop stack) pushed-after-pop)
  (check-contract "Stack 3: the next pop should return 20" (stack-pop stack) pushed-second)
  (check-contract "Stack 3: the final pop should return 10" (stack-pop stack) pushed-first)
  (check-contract "Stack 3: is_empty should be true after removing everything" (stack-is-empty stack) #t)
  (check-contract "Stack 3: size should be 0 after removing everything" (stack-size stack) 0)

  ;; Paso 4 — vacío tras la extracción.
  (check-contract "Stack 4: pop on an empty stack should fail" (stack-pop stack) #f)
  (check-contract "Stack 4: a failed pop should keep the stack empty" (stack-is-empty stack) #t))
