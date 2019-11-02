#!/bin/bash

coverage() {
  # kcovのインストールされている環境でのみ実行
  if type kcov 2> /dev/null; then
    local options=(--bash-dont-parse-binary-dir)

    # CI上で実行されているときだけオプションを追加
    if [[ -z "$TRAVIS_JOB_ID" ]]; then
      options+=("--coveralls-id=$TRAVIS_JOB_ID")
    fi

    kcov "${options[@]}" coverage "$@" || true
  fi
}
