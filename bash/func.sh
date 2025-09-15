#!/bin/bash

FIX_SEP=$'\x01'
#==============================================================================
# FUNCTION: extract_fix_message_bash
#
# DESCRIPTION:
#   從一個字串中擷取符合 FIX 模式的訊息。(純 Bash 實現)
#   (8=...10=xxx\x01)
#
# PARAMETERS:
#   $1 - (string) 包含 FIX 訊息的來源字串。
#
# OUTPUT:
#   - On success: 將找到的 FIX 訊息字串輸出到 stdout，並回傳退出碼 0。
#   - On failure: 輸出空字串，並回傳退出碼 1。
#
# USAGE:
#   result=$(extract_fix_message_bash "some_string")
#   if [ $? -eq 0 ]; then ...
#==============================================================================
function extract_fix_message_bash() {
  if [ -z "$1" ]; then
    return 1
  fi

  # 定義正規表示式，用 () 將要捕獲的部分包起來
  local regex="(8=.*10=[0-9]{3}${FIX_SEP})"

  # 執行匹配
  if [[ $1 =~ $regex ]]; then
    # 如果成功，匹配的結果在 ${BASH_REMATCH[1]} 中
    # 將結果輸出到 stdout
    echo "${BASH_REMATCH[1]}"
    return 0 # 回傳成功
  else
    # 如果失敗，回傳失敗的退出碼
    return 1
  fi
}


#==============================================================================
# FUNCTION: extract_fix_message_grep
#
# DESCRIPTION:
#   從一個字串中擷取第一個符合 FIX 模式的訊息。
#   (8=...10=xxx\x01)
#
# PARAMETERS:
#   $1 - (string) 包含 FIX 訊息的來源字串。
#
# OUTPUT:
#   - On success: 將找到的 FIX 訊息字串輸出到 stdout，並回傳退出碼 0。
#   - On failure: 輸出空字串，並回傳退出碼 1 (或 grep 的退出碼)。
#
# USAGE:
#   result=$(extract_fix_message_grep "some_string")
#   if [ $? -eq 0 ]; then
#     echo "Found: $result"
#   fi
#==============================================================================
function extract_fix_message_grep() {
  # 檢查是否有提供輸入參數
  if [ -z "$1" ]; then
    return 1
  fi

  # 使用 printf 而非 echo，以避免輸入字串以 '-' 開頭時產生問題
  # grep -oP 會輸出匹配的內容，其退出碼會自動成為 function 的退出碼
  # '8=.*?10=[0-9]{3}\x01' 使用非貪婪匹配 (.*?)，更為精準
  printf "%s" "$1" | grep -oP '8=.*?10=[0-9]{3}\x01'
}

#==============================================================================
# FUNCTION: parse_fix_message
#
# DESCRIPTION:
#   將一個 SOH (\x01) 分隔的 FIX 訊息字串，解析到一個關聯陣列中。
#
# PARAMETERS:
#   $1 - (string) 包含 FIX 訊息的字串。
#   $2 - (string) 用於接收解析結果的關聯陣列的變數名稱。
#
# USAGE:
#   declare -A my_map
#   parse_fix_message "8=FIX.4.2..." my_map
#
#==============================================================================
function parse_fix_message() {
  # 參數檢查
  if [[ $# -ne 2 || -z "$1" || -z "$2" ]]; then
    echo "使用方式錯誤: parse_fix_message <fix_string> <destination_array_name>" >&2
    return 1
  fi

  # 使用 local 變數避免汙染全域
  local fix_string="$1"
  
  # 建立一個名稱參考 (nameref)，dest_map 會成為傳入的第二個參數（陣列名稱）的別名
  local -n dest_map="$2"
  
  # 清空目標陣列，確保 function 可以被重複使用
  dest_map=()

  local temp_array
  local item
  local tag
  local value

  # 將 IFS 設定為 SOH 字元，並將字串讀入臨時的索引陣列
#  IFS=$'\x01' read -r -a temp_array <<< "$fix_string"
  IFS=${FIX_SEP} read -r -a temp_array <<< "$fix_string"

  # 遍歷臨時陣列，解析 tag=value 並填入目標關聯陣列
  for item in "${temp_array[@]}"; do
    # 避免處理因結尾分隔符產生的空元素
    if [[ -n "$item" ]]; then
      # 使用參數擴展來分割字串，效率極高
      tag=${item%%=*}    # 從第一個 '=' 開始，刪除右邊所有字元
      value=${item#*=}   # 從第一個 '=' 開始，刪除左邊所有字元
      dest_map["$tag"]="$value"
    fi
  done
  
  return 0
}

#==============================================================================
# FUNCTION: extract_ip_address
#
# DESCRIPTION:
#   從一個字串中擷取第一個符合 0-255 範圍的有效 IP 位址。
#
# PARAMETERS:
#   $1 - (string) 來源字串。
#
# OUTPUT:
#   - On success: 將找到的 IP 位址字串輸出到 stdout，並回傳退出碼 0。
#   - On failure: 輸出空字串，並回傳退出碼 1。
#
# USAGE:
#   ip=$(extract_ip_address "some string")
#   if [ $? -eq 0 ]; then
#     echo "Found: $ip"
#   fi
#==============================================================================
function extract_ip_address() {
  local input_string="$1"

  # 檢查是否有提供輸入參數
  if [[ -z "$input_string" ]]; then
    return 1
  fi
  
  # 精準驗證 0-255 範圍的正規表示式
  local valid_ip_regex='((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9]))'

  if [[ $input_string =~ $valid_ip_regex ]]; then
    # 將捕獲到的 IP (第一個括號組) 輸出到 stdout
    echo "${BASH_REMATCH[1]}"
    return 0 # 成功
  else
    return 1 # 失敗
  fi
}
