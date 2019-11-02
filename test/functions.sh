#!/bin/bash

run_test() {
  run "$@"
  kcov --bash-dont-parse-binary-dir ../coverage "$@"
}
