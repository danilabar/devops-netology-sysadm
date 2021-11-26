# Домашнее задание к занятию "3.5. Файловые системы"

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.
   1. Прочитано
2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
   1. Не могут. Жесткая ссылка и файл, для которой она создавалась имеют одинаковые inode. Поэтому жесткая ссылка имеет те же права доступа, владельца и время последней модификации, что и целевой файл.
3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```

    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.  
   1. 
   ```bash
   vagrant@vagrant:~$ lsblk
    NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    sda                    8:0    0   64G  0 disk
    ├─sda1                 8:1    0  512M  0 part /boot/efi
    ├─sda2                 8:2    0    1K  0 part
    └─sda5                 8:5    0 63.5G  0 part
      ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
      └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
    sdb                    8:16   0  2.5G  0 disk
    sdc
   ```
4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.  
   1. 
   ```bash
   sudo fdisk -l /dev/sdb
    Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
    Disk model: VBOX HARDDISK
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: dos
    Disk identifier: 0x67302f0f
    
    Device     Boot   Start     End Sectors  Size Id Type
    /dev/sdb1          2048 4196351 4194304    2G 83 Linux
    /dev/sdb2       4196352 5242879 1046528  511M 83 Linux
   ```
5. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.  
   1. `sudo sfdisk -d /dev/sdb | sudo sfdisk /dev/sdc`  
   ```bash
   sudo fdisk -l /dev/sdc
    Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
    Disk model: VBOX HARDDISK
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: dos
    Disk identifier: 0x67302f0f
    
    Device     Boot   Start     End Sectors  Size Id Type
    /dev/sdc1          2048 4196351 4194304    2G 83 Linux
    /dev/sdc2       4196352 5242879 1046528  511M 83 Linux
   ```
6. Соберите `mdadm` RAID1 на паре разделов 2 Гб.
   1. `mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1`  

7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.
   1. `mdadm --create /dev/md1 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2`  
   `echo 'DEVICE partitions containers' > /etc/mdadm/mdadm.conf`  
   `mdadm --detail --scan >> /etc/mdadm/mdadm.conf`  
   `update-initramfs -u`
8. Создайте 2 независимых PV на получившихся md-устройствах.
   1. `pvcreate /dev/md0`  
   `pvcreate /dev/md1`
9. Создайте общую volume-group на этих двух PV.
   1. `vgcreate vg1 /dev/md1 /dev/md0`
10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
    1. `lvcreate -L 100M vg1 /dev/md1`

11. Создайте `mkfs.ext4` ФС на получившемся LV.
    1. `mkfs.ext4 /dev/vg1/lvol0`

12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.
    1. `mkdir /tmp/new`  
    `mount /dev/vg1/lvol0 /tmp/new`

13. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.  
    1. 
    ```bash
      root@vagrant:~# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
      --2021-11-26 06:14:15--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
      Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
      Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
      HTTP request sent, awaiting response... 200 OK
      Length: 22592514 (22M) [application/octet-stream]
      Saving to: ‘/tmp/new/test.gz’
      
      /tmp/new/test.gz              100%[=================================================>]  21.55M  6.62MB/s    in 3.2s
      
      2021-11-26 06:14:18 (6.65 MB/s) - ‘/tmp/new/test.gz’ saved [22592514/22592514]
    ```

14. Прикрепите вывод `lsblk`.  
    1. 
    ```bash
      root@vagrant:~# lsblk
      NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
      sda                    8:0    0   64G  0 disk
      ├─sda1                 8:1    0  512M  0 part  /boot/efi
      ├─sda2                 8:2    0    1K  0 part
      └─sda5                 8:5    0 63.5G  0 part
        ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
        └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
      sdb                    8:16   0  2.5G  0 disk
      ├─sdb1                 8:17   0    2G  0 part
      │ └─md0                9:0    0    2G  0 raid1
      └─sdb2                 8:18   0  511M  0 part
        └─md1                9:1    0 1018M  0 raid0
          └─vg1-lvol0      253:2    0  100M  0 lvm   /tmp/new
      sdc                    8:32   0  2.5G  0 disk
      ├─sdc1                 8:33   0    2G  0 part
      │ └─md0                9:0    0    2G  0 raid1
      └─sdc2                 8:34   0  511M  0 part
        └─md1                9:1    0 1018M  0 raid0
          └─vg1-lvol0      253:2    0  100M  0 lvm   /tmp/new
    ```

15. Протестируйте целостность файла:

     ```bash
     root@vagrant:~# gzip -t /tmp/new/test.gz
     root@vagrant:~# echo $?
     0
     ```
    1. `0`
16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
    1. `pvmove /dev/md1`

17. Сделайте `--fail` на устройство в вашем RAID1 md.
    1. `mdadm --fail /dev/md0 /dev/sdb1`
    ```bash
      root@vagrant:~# cat /proc/mdstat
      Personalities : [raid0] [raid1] [linear] [multipath] [raid6] [raid5] [raid4] [raid10]
      md1 : active raid0 sdc2[1] sdb2[0]
            1042432 blocks super 1.2 512k chunks
      
      md0 : active raid1 sdc1[1] sdb1[0](F)
            2094080 blocks super 1.2 [2/1] [_U]
      
      unused devices: <none>
    ```

18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.  
    1. 
    ```bash
      [ 3767.576979] md/raid1:md0: Disk failure on sdb1, disabling device.
      md/raid1:md0: Operation continuing on 1 devices.
    ```

19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

     ```bash
     root@vagrant:~# gzip -t /tmp/new/test.gz
     root@vagrant:~# echo $?
     0
     ```
    1. `0`
20. Погасите тестовый хост, `vagrant destroy`.
    1. Пока задание на проверке сделал `vagrant halt` :)
