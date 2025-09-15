---
title: 筆記- Linux 指令  
author: fatty0860  
data: 2025/09/12  
---

# Linux Command  

## 如何查詢 core 上跑了多少 process  


### 方法一：使用 `ps` 搭配 `awk` (最精確且適合腳本)

這是最推薦、最靈活且最適合自動化腳本的方法。`ps` 指令可以顯示每個行程/執行緒正在哪個處理器上執行。

1.  **列出所有執行緒及其所在的 Core：**
    我們使用 `ps` 指令並客製化輸出格式。`-eL` 會列出系統上每一個行程(process)以及其下的每一個執行緒(thread)。

      * `psr`: (Processor) 顯示執行緒目前在哪個 CPU core 上執行。
      * `pid`: 行程 ID。
      * `tid`: 執行緒 ID (在核心中，調度的基本單位是執行緒)。
      * `comm`: 命令名稱。

    <!-- end list -->

    ```bash
    ps -eL -o psr,pid,tid,comm
    ```

    您會看到類似這樣的輸出：

    ```text
     PSR   PID   TID COMMAND
       3  1234  1234 systemd
       1  1235  1235 kthreadd
       0  1236  1236 rcu_gp
       ...
       2  5678  5680 my_app_thread
       2  5678  5681 my_app_thread
       0  9101  9101 bash
    ```

    `PSR` 欄位就是您要的答案，它代表 "Processor"。

2.  **篩選並計算指定 Core 的執行緒數量：**
    假設您想查看有多少執行緒正在 **Core 2** 上執行，並計算其數量。您可以使用 `awk` 來篩選第一欄 (`$1`) 等于 `2` 的行，並用 `wc -l` 來計數。

      * **列出在 Core 2 上的所有執行緒：**

        ```bash
        ps -eL -o psr,pid,tid,comm | awk '$1 == "2"'
        ```

      * **計算在 Core 2 上的執行緒總數：**

        ```bash
        # awk '$1 == "2"' 過濾出 PSR 為 2 的行，然後 wc -l 計算行數
        ps -eL -o psr | awk 'NR>1 && $1 == "2"' | wc -l
        ```

        > **註記:** `NR>1` 是為了跳過 `ps` 輸出的標頭行(PSR)，讓計數更準確。
