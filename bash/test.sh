#!/bin/bash
. ./func.sh

# ----------------------
# declare
# ----------------------
inFile="./log"
#regex='(8=.*10=[0-9]{3}\x01)'

declare -A order_data
while IFS= read -r line || [[ -n "$line" ]]; do
	order_data=()

	ip=$(extract_ip_address "$line")
	if [ $? -eq 1 ];then
		ip=""
	fi

	fix_msg=$(extract_fix_message_bash "$line")
	if [ $? -eq 0 ];then
		tm=${line:0:5}
		if parse_fix_message "$fix_msg" order_data; then
			echo "${tm}-[${ip}] 35 = ${order_data[35]}"
			if [[ ${order_data[38]} != "" ]];then
				echo "38 = [${order_data[38]}]"
			fi
		fi
	fi

done < "$inFile"


## 1. 準備一個 FIX 訊息字串
#fix_message_1="8=FIX.4.29=16935=D34=149=SENDER_COMP_ID56=TARGET_COMP_ID52=20250915-11:30:00.12311=ORDER000121=155=233054=138=1000040=244=120059=047=A60=20250915-11:30:00.12310=168"
#
## 2. 宣告一個關聯陣列來接收結果
#declare -A order_data
#
## 3. 呼叫 function 進行解析
##    注意：第二個參數是傳入陣列的「名稱」，而不是它的內容
#echo "正在解析 FIX 訊息..."
#if parse_fix_message "$fix_message_1" order_data; then
#  echo "解析成功！"
#  echo "--------------------------"
#
#  # 4. 驗證結果，直接使用我們宣告的 order_data 陣列
#  echo "訊息類型 (Tag 35): ${order_data[35]}"
#  echo "股票代碼 (Tag 55): ${order_data[55]}"
#  echo "訂單數量 (Tag 38): ${order_data[38]}"
#  echo "發送方 (Tag 49): ${order_data[49]}"
#  echo ""
#
#  # 列印所有解析出的 Tag 和 Value
#  echo "所有解析出的資料："
#  for key in "${!order_data[@]}"; do
#    echo "  Tag ${key} = ${order_data[$key]}"
#  done
#else
#  echo "解析失敗。"
#fi
