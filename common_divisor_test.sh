#!/bin/bash

SCRIPT="./common_divisor.sh"
CSV="test_case.csv"

error_flg=false

while IFS=, read -r case_num summary raw_args expected success_msg fail_msg; do
  # 空行・コメントスキップ
  [[ -z "$case_num" || "$case_num" =~ ^# ]] && continue

  # raw_args の整形： [] を除去し空白トリム
  args=$(echo "$raw_args" | sed -E 's/^\[|\]$//g' | xargs)

  # 実行結果と終了コード取得
  output=$($SCRIPT $args 2>&1)
  status=$?

  # 判定
  result="NG"
  if [[ "$expected" == "エラー" ]]; then
    if [ $status -ne 0 ]; then
      result="OK"
    fi
  else
    if [[ "$output" == "$expected" ]]; then
      result="OK"
    fi
  fi

  # 結果がNGだった場合は囲み線を出して目立たせる
  if [[ $result == "NG" ]]; then
    echo "========================================"
    error_flg=true
  fi
  
  echo "$result - ケース$case_num：$summary"
  echo "              引数： $args"
  echo "              想定結果： $expected"
  echo "              出力結果： $output"
  
  if [[ $result == "NG" ]]; then
    echo "========================================"
  fi

done < "$CSV"

if [[ $error_flg == "true" ]];
then
    exit 1
else
    exit 0
fi

