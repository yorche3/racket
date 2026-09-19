#lang racket

(require rackunit/text-ui rackunit-fancy-runner)
(require "./naive_sort_tests.rkt")

(run-tests naive-sort-suite)
