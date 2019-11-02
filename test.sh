#!/bin/bash

SCRIPT_NAME="$(basename "${BASH_SOURCE:-$0}")"
readonly SCRIPT_NAME

readonly RED=$'\x1b[31m'
readonly BLUE=$'\x1b[34m'
readonly RESET=$'\x1b[m'

cd test || exit 1

main() {
  local bats_cmd=(bats)
  # CI上で実行されるときはtap形式で出力する
  if [[ ! "$TRAVIS_JOB_ID" == "" ]]; then
    bats_cmd+=("--tap")
  fi

  # 引数未指定の場合は全てのテストを実行する
  local ret
  if [[ $# -lt 1 ]]; then
    "${bats_cmd[@]}" .
    ret=$?
    return "$ret"
  fi

  local cmd="$1"

  # ヘルプの出力
  if [[ "$cmd" == help ]]; then
    usage
    return
  fi

  # マッチするコマンドのみ実行
  for test_script in *-test.bats; do
    if [[ "$cmd"-test.bats == "$test_script" ]]; then
      echo -e "${BLUE}${test_script}${RESET}"
      "${bats_cmd[@]}" "$test_script"
      ret=$?
      return "$ret"
    fi
  done

  usage >&2
  return 1
}

usage() {
  cat << EOS
$SCRIPT_NAME はtestディレクトリ配下のテストスクリプトを実行する。

Usage:
    $SCRIPT_NAME              全てのテストを実行する
    $SCRIPT_NAME <command>    コマンド、あるいはテストスクリプトを実行する

Available commands:
    help             このヘルプを出力する
    <test_script>    test/*-test.batsの任意の1つのスクリプト

Available test scripts:
EOS
  for test_script in *-test.bats; do
    echo "${test_script//-test.bats/}"
  done
}

print_bash_version() {
  echo "------------------------------------------------------------------------------"
  bash --version
  echo "------------------------------------------------------------------------------"
}

type bats >&/dev/null
ret=$?
if [[ "$ret" -ne 0 ]]; then
  echo -e "[ ${RED}ERR${RESET} ] bats was not found. See a section of Testing on README."
  exit 1
fi

print_bash_version
main ${1+"$@"}
ret=$?
print_bash_version

exit $ret
