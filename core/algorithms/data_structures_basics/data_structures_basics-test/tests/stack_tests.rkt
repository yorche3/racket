#lang racket/base

;; Casos del contrato `Stack` de la especificación 06_Data_Structures_Basics.
;;
;; Los cuatro pasos corren sobre la misma pila: se declara una vez con `stack_init` y cada
;; paso continúa el estado anterior, sin reiniciar el escenario. Aislamiento: la instancia
;; es la del propio escenario.

(require rackunit
         "contract.rkt"
         "../../data_structures_basics-lib/data-structures-basics.rkt")

;; Fixtures: un nombre por valor del escenario.
(define pushed_first 10)
(define pushed_second 20)
(define pushed_third 30)
(define pushed_after_pop 40)

(module+ test
  (define stack (stack_init))

  ;; Paso 1 — estado vacío y extracción fallida.
  (check_contract "Stack 1: is_empty should be true after init" (stack_is_empty stack) #t)
  (check_contract "Stack 1: size should be 0 after init" (stack_size stack) 0)
  (check_contract "Stack 1: peek on an empty stack should return #f" (stack_peek stack) #f)
  (check_contract "Stack 1: pop on an empty stack should return #f" (stack_pop stack) #f)
  (check_contract "Stack 1: a failed pop should keep the stack empty" (stack_is_empty stack) #t)

  ;; Paso 2 — LIFO y `peek` no mutante.
  (stack_push stack pushed_first)
  (stack_push stack pushed_second)
  (stack_push stack pushed_third)
  (check_contract "Stack 2: peek should return 30" (stack_peek stack) pushed_third)
  (check_contract "Stack 2: size should be 3 after three pushes" (stack_size stack) 3)

  ;; Paso 3 — extracción y reutilización.
  (check_contract "Stack 3: the first pop should return 30" (stack_pop stack) pushed_third)
  (stack_push stack pushed_after_pop)
  (check_contract "Stack 3: the reused top should return 40" (stack_pop stack) pushed_after_pop)
  (check_contract "Stack 3: the next pop should return 20" (stack_pop stack) pushed_second)
  (check_contract "Stack 3: the final pop should return 10" (stack_pop stack) pushed_first)
  (check_contract "Stack 3: is_empty should be true after removing everything" (stack_is_empty stack) #t)
  (check_contract "Stack 3: size should be 0 after removing everything" (stack_size stack) 0)

  ;; Paso 4 — vacío tras la extracción.
  (check_contract "Stack 4: pop on an empty stack should fail" (stack_pop stack) #f)
  (check_contract "Stack 4: a failed pop should keep the stack empty" (stack_is_empty stack) #t))
