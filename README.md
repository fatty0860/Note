# Note
## CentOS
1. setting isolcpus in centos8  
  grub存放位置在：/etc/default/grub  
  GRUB_CMDLINE_LINUX="crashkernel=auto rd.lvm.lv=cl/root rd.lvm.lv=cl/swap **isolcpus=1-11 nohz_full=1-11 rcu_nocbs=1-11** rhgb quiet"  
  加上粗體部分, 隔離1-11cores  
2. 重新產生grub.cfg  
  當前目錄執行grub2-mkconfig -o ./grub.cfg  
  將新設定檔覆蓋 /boot/grub2/grub.cfg  
3. 重開機.  
