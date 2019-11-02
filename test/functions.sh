#!/bin/bash

coverage() {
  # kcovのインストールされている環境でのみ実行
  if type kcov 2> /dev/null; then
    kcov --bash-dont-parse-binary-dir coverage "$@" || true
  fi
}
