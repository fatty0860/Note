#!/bin/bash

# 準備 FIX 訊息
fix_message="8=FIX.4.2"$'\x01'"35=D"$'\x01'"55=GOOG"$'\x01'"38=100"$'\x01'"10=168"$'\x01'

# 宣告一個關聯陣列來存放結果
declare -A fix_data

echo "正在直接解析 FIX 訊息..."

# --- 直接將解析邏輯放在這裡 ---
# 1. 初步拆解
IFS=$'\x01' read -r -a temp_array <<< "$fix_message"

# 2. 遍歷並填充關聯陣列
for item in "${temp_array[@]}"; do
  if [[ -n "$item" ]]; then
    tag=${item%%=*}
    value=${item#*=}
    fix_data["$tag"]="$value"
  fi
done
# --- 解析邏輯結束 ---

echo "✅ 解析成功！"

# 驗證結果
echo "--------------------------"
echo "訊息類型 (Tag 35): ${fix_data[35]}"
echo "股票代碼 (Tag 55): ${fix_data[55]}"
