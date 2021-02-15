
Markdown 基本語法  

---
> ## 目錄
- [基本語法](#basicType)
    - [標題](#header)
    - [清單](#list)
    - [超連結](#hyperlink)
    - [圖片](#image)
    - [表格](#table)
---
<h2 id='basicType'>基本語法</h2>  

> <h3 id='header'>標題</h3>
使用 # 字號當作標題大小, h1 ~ h6  
```  
# 標題1
## 標題2
```

---
> <h3 id='list'>清單</h3>
使用 - or 1-n or * 進行編號  

### 無序編號
- 清單1
    - 清單1-1
- 清單2
    - 清單2-1
### 有序編號
1. 清單  
    1. 清單1-1
1. 清單  
    1. 清單2-1

---
> <h3 id='hyperlink'>超連結</h3>

- 內部連結  
```
  [名稱](#連結)
```

- 外部連結  
```html
<a href="url“ target="_blank">hyperlink display</a>
```
---
> <h3 id='image'>插入圖片</h3>
```
![alt text](./data/DSC04028.jpeg "Optional title")
```

![alt text](./data/DSC04028.jpeg "Optional title")

---
> <h3 id='table'>表格</h3>
分隔線列中，每欄的水平分隔符號數量至少要有 3 個，3 個以上無論多寡皆不影響。
```
Age           | Time  | Food | Gold  
--------------|-------|-----:|-----: 
Feudal Age    | 02:10 |  500 |    0  
Castle Age    | 02:40 |  800 |  200
Imperial Age  | 03:30 | 1000 |  800 
```

Age           | Time  | Food | Gold  
--------------|-------|-----:|-----: 
Feudal Age    | 02:10 |  500 |    0  
Castle Age    | 02:40 |  800 |  200
Imperial Age  | 03:30 | 1000 |  800 

---