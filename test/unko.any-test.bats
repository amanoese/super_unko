#!/usr/bin/env bats
source functions.sh

readonly TARGET_COMMAND="../bin/unko.any"
readonly BASH_REQUIRE_VERSION=4.0

#==============================================================================
# NOTE:
#   echo-sdはBash4.0以下では動かないため、Bash4.1以上のみテストする
#==============================================================================

bash_version=$(bash --version | grep -Eo "[0-9]+\.[0-9]+" | head -n 1)
if [ $(echo "$BASH_REQUIRE_VERSION < $bash_version" | bc) -eq 0 ]; then
  echo "  Bash${BASH_REQUIRE_VERSION}以下はスキップ"
  exit 0
fi

@test '引数がない場合はヘルプを出力する' {
  run "$TARGET_COMMAND"
  [ "$status" -eq 0 ]
  coverage "$TARGET_COMMAND"
}

@test '引数が1つのときは💩の置換のみ' {
  run "$TARGET_COMMAND" あ
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "＿人人人人人人＿" ]
  [ "${lines[1]}" = "＞　突然の死　＜" ]
  [ "${lines[2]}" = "￣Y^Y^Y^Y^Y^Y^￣" ]
  [ "${lines[3]}" = "　　　　　　👑" ]
  [ "${lines[4]}" = "　　　　（あああ）" ]
  [ "${lines[5]}" = "　　　（あ👁あ👁あ）" ]
  [ "${lines[6]}" = "　　（あああ👃あああ）" ]
  [ "${lines[7]}" = "　（ああああ👄ああああ）" ]
  coverage "$TARGET_COMMAND" あ
}

@test '引数が2つのときは💩の置換と文言変更' {
  run "$TARGET_COMMAND" あ い
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "＿人人人＿" ]
  [ "${lines[1]}" = "＞　い　＜" ]
  [ "${lines[2]}" = "￣Y^Y^Y^￣" ]
  [ "${lines[3]}" = "　　　　　　👑" ]
  [ "${lines[4]}" = "　　　　（あああ）" ]
  [ "${lines[5]}" = "　　　（あ👁あ👁あ）" ]
  [ "${lines[6]}" = "　　（あああ👃あああ）" ]
  [ "${lines[7]}" = "　（ああああ👄ああああ）" ]
  coverage "$TARGET_COMMAND" あ い
}

@test '引数に /' {
  run "$TARGET_COMMAND" /
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "＿人人人人人人＿" ]
  [ "${lines[1]}" = "＞　突然の死　＜" ]
  [ "${lines[2]}" = "￣Y^Y^Y^Y^Y^Y^￣" ]
  [ "${lines[3]}" = "　　　　　　👑" ]
  [ "${lines[4]}" = "　　　　（///）" ]
  [ "${lines[5]}" = "　　　（/👁/👁/）" ]
  [ "${lines[6]}" = "　　（///👃///）" ]
  [ "${lines[7]}" = "　（////👄////）" ]
  coverage "$TARGET_COMMAND" あ い
}

@test '引数にエスケープ文字' {
  run "$TARGET_COMMAND" '\\'
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = '＿人人人人人人＿' ]
  [ "${lines[1]}" = '＞　突然の死　＜' ]
  [ "${lines[2]}" = '￣Y^Y^Y^Y^Y^Y^￣' ]
  [ "${lines[3]}" = '　　　　　　👑' ]
  [ "${lines[4]}" = '　　　　（\\\）' ]
  [ "${lines[5]}" = '　　　（\👁\👁\）' ]
  [ "${lines[6]}" = '　　（\\\👃\\\）' ]
  [ "${lines[7]}" = '　（\\\\👄\\\\）' ]
  coverage "$TARGET_COMMAND" '\\'
}

@test 'ASCIIコード表33~127まででの置換 (エスケープ文字は除外)' {
  grep -o . <<< '!"#$%&'"'"'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~' | while read -r ch; do
    run "$TARGET_COMMAND" "$ch"
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "＿人人人人人人＿" ]
    [ "${lines[1]}" = "＞　突然の死　＜" ]
    [ "${lines[2]}" = "￣Y^Y^Y^Y^Y^Y^￣" ]
    [ "${lines[3]}" = "　　　　　　👑" ]
    [ "${lines[4]}" = "　　　　（$ch$ch$ch）" ]
    [ "${lines[5]}" = "　　　（$ch👁$ch👁$ch）" ]
    [ "${lines[6]}" = "　　（$ch$ch$ch👃$ch$ch$ch）" ]
    [ "${lines[7]}" = "　（$ch$ch$ch$ch👄$ch$ch$ch$ch）" ]
    coverage "$TARGET_COMMAND" "$ch"
  done
}
