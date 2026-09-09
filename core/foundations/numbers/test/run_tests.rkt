#lang racket

(require rackunit/text-ui rackunit-fancy-runner)
(require "./recursive_tests.rkt")
(require "./recursive_with_acc_tests.rkt")
(require "./iterative_tests.rkt")

(run-tests recursive-suite)
(run-tests recursive-with-acc-suite)
(run-tests iterative-suite)
