#lang racket

(require rackunit/text-ui rackunit-fancy-runner)
(require "./calculator_test.rkt")

(run-tests calculator-suite)
