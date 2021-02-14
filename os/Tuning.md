# Linux Tuning

## CPU 隔離 (isolcpus)
- RHEL/CentOS  
    - 修改grub  
        grub存放位置在：/etc/default/grub  
        GRUB_CMDLINE_LINUX="crashkernel=auto rd.lvm.lv=cl/root rd.lvm.lv=cl/swap **isolcpus=1-11 nohz_full=1-11 rcu_nocbs=1-11** rhgb quiet"  
        加上粗體部分, 隔離1-11cores  
    - 重新產生grub.cfg  
      當前目錄執行grub2-mkconfig -o ./grub.cfg  
      將新設定檔覆蓋 /boot/grub2/grub.cfg  
    - 重開機.  
      重啓server後，配置生效。可用過cat /proc/cmdline查看結