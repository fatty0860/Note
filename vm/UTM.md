## UTM 
---
### 官網 : <a href="https://mac.getutm.app/" target="_blank"> https://mac.getutm.app/</a>
- [SPICE Guest Tool](https://mac.getutm.app/support/)  
vm系統與主系統溝通的driver

### 如何安裝 windows 10/11 於 M1
由於windows目前並沒有提供arm的版本給macos, 所以只能先從<a href="https://uupdump.net/" target="_blank">UUP DUMP</a>下載.   

- 磁碟種類選擇 **NVMe** 

安裝時可能會遭遇到下列的問題
- windows 11 
    - 跳過TPM 
        1. shift + F10 叫出cmd  
        1. regedit
        1. add **LabConfig** to Computer\HKEY_LOCAL_MACHINE\SYSTEM\Setup  
        1. add BypassTPMCheck = 1 to LabConfig, type is DWORD (32-bit) Value
        1. add BypassSecureBootCheck = 1 to LabConfig, type is DWORD (32-bit) Value
    - 跳過網路連線   
        1. shift + F10 叫出cmd  
        1. taskmgr 
        1. kill **Network Connection Flow** 
- 調整設定(powershell)
    - 調整模式  
        參考 https://appuals.com/change-dark-light-mode-windows-11/
        - Dark Mode
            ```
            Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0 -Type Dword -Force

            Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value 0 -Type Dword -Force
            ```
        - Light Mode
            ```
            Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 1 -Type Dword -Force

            Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value 1 -Type Dword -Force
            ```


