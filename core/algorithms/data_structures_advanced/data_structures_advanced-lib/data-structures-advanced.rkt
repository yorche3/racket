#lang racket/base

(provide hello)

(require racket/format)

(define (hello [name "World"])
  (~a "Hello, " name "!"))
