# Домашнее задание к занятию "3.5. Файловые системы" Максим Носов

### Цель задания

В результате выполнения этого задания вы:

1. Научитесь работать с инструментами разметки жестких дисков, виртуальных разделов - RAID массивами и логическими томами, конфигурациями файловых систем. Основная задача - понять, какие слои абстракций могут нас отделять от файловой системы до железа. Обычно инженер инфраструктуры не сталкивается напрямую с настройкой LVM или RAID, но иметь понимание, как это работает - необходимо.
1. Создадите нештатную ситуацию работы жестких дисков и поймете, как система RAID обеспечивает отказоустойчивую работу.


### Чеклист готовности к домашнему заданию

1. Убедитесь, что у вас на новой виртуальной машине (шаг 3 задания) установлены следующие утилиты - `mdadm`, `fdisk`, `sfdisk`, `mkfs`, `lsblk`, `wget`.  
2. Воспользуйтесь пакетным менеджером apt для установки необходимых инструментов


### Инструменты/ дополнительные материалы, которые пригодятся для выполнения задания

1. Разряженные файлы - [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB)
2. [Подробный анализ производительности RAID,3-19 страницы](https://www.baarf.dk/BAARF/0.Millsap1996.08.21-VLDB.pdf).
3. [RAID5 write hole](https://www.intel.com/content/www/us/en/support/articles/000057368/memory-and-storage.html).


------

## Задание

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.

2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```ruby
    path_to_disk_folder = './disks'

    host_params = {
        'disk_size' => 2560,
        'disks'=>[1, 2],
        'cpus'=>2,
        'memory'=>2048,
        'hostname'=>'sysadm-fs',
        'vm_name'=>'sysadm-fs'
    }
    Vagrant.configure("2") do |config|
        config.vm.box = "bento/ubuntu-20.04"
        config.vm.hostname=host_params['hostname']
        config.vm.provider :virtualbox do |v|

            v.name=host_params['vm_name']
            v.cpus=host_params['cpus']
            v.memory=host_params['memory']

            host_params['disks'].each do |disk|
                file_to_disk=path_to_disk_folder+'/disk'+disk.to_s+'.vdi'
                unless File.exist?(file_to_disk)
                    v.customize ['createmedium', '--filename', file_to_disk, '--size', host_params['disk_size']]
                end
                v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', disk.to_s, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
            end
        end
        config.vm.network "private_network", type: "dhcp"
    end
    ```

    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

###### Результат

````bash
root@sysadm-fs:/home/vagrant# fdisk /dev/sdb

Welcome to fdisk (util-linux 2.34).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0xf824aafe.

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-5242879, default 2048): 2048
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G

Created a new partition 1 of type 'Linux' and of size 2 GiB.

Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (2-4, default 2): 2
First sector (4196352-5242879, default 4196352): 4196352
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879): 5242879

Created a new partition 2 of type 'Linux' and of size 511 MiB.

Command (m for help): w

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

root@sysadm-fs:/home/vagrant# fdisk /dev/sdb

Welcome to fdisk (util-linux 2.34).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): p
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xf824aafe

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdb1          2048 4196351 4194304    2G 83 Linux
/dev/sdb2       4196352 5242879 1046528  511M 83 Linux
````

5. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.

###### Результат
```` bash

root@sysadm-fs:/home/vagrant# sfdisk -d /dev/sdb | sfdisk /dev/sdc
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0xf824aafe.
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: dos
Disk identifier: 0xf824aafe

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

````

6. Соберите `mdadm` RAID1 на паре разделов 2 Гб.

###### Результат
```` bash
root@sysadm-fs:/home/vagrant# mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: size set to 2094080K
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
root@sysadm-fs:/home/vagrant# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md0 : active raid1 sdc1[1] sdb1[0]
      2094080 blocks super 1.2 [2/2] [UU]

unused devices: <none>

````

7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.

###### Результат
```` bash
root@sysadm-fs:/home/vagrant# mdadm --create --verbose /dev/md1 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2
mdadm: chunk size defaults to 512K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
root@sysadm-fs:/home/vagrant# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md1 : active raid0 sdc2[1] sdb2[0]
      1042432 blocks super 1.2 512k chunks

md0 : active raid1 sdc1[1] sdb1[0]
      2094080 blocks super 1.2 [2/2] [UU]

unused devices: <none>
````

8. Создайте 2 независимых PV на получившихся md-устройствах.

###### Результат
```` bash
root@sysadm-fs:/home/vagrant# pvcreate /dev/md0 /dev/md1
  Physical volume "/dev/md0" successfully created.
  Physical volume "/dev/md1" successfully created.
root@sysadm-fs:/home/vagrant# pvdisplay
  --- Physical volume ---
  PV Name               /dev/sda3
  VG Name               ubuntu-vg
  PV Size               <62.50 GiB / not usable 0   
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              15999
  Free PE               8000
  Allocated PE          7999
  PV UUID               x7S6t2-at3n-E9kU-cz28-gAH3-QU9H-vyVuNf

  "/dev/md0" is a new physical volume of "<2.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/md0
  VG Name               
  PV Size               <2.00 GiB
  Allocatable           NO
  PE Size               0   
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               ongbys-wUal-I4tB-cXbf-4HJI-9tPN-5xWS3y

  "/dev/md1" is a new physical volume of "1018.00 MiB"
  --- NEW Physical volume ---
  PV Name               /dev/md1
  VG Name               
  PV Size               1018.00 MiB
  Allocatable           NO
  PE Size               0   
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               4oZyc8-01c8-2KAP-XsUP-hSZd-bPyB-XiG26S
````

9. Создайте общую volume-group на этих двух PV.

###### Результат
```` bash
root@sysadm-fs:/home/vagrant# vgcreate volume_group00 /dev/md0 /dev/md1
  Volume group "volume_group00" successfully created
````

10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

###### Результат
```` bash
root@sysadm-fs:/home/vagrant# lvcreate -L 100M -n logical_vol1 volume_group00
  Logical volume "logical_vol1" created.
root@sysadm-fs:/home/vagrant# lvdisplay
  --- Logical volume ---
  LV Path                /dev/ubuntu-vg/ubuntu-lv
  LV Name                ubuntu-lv
  VG Name                ubuntu-vg
  LV UUID                mJ8K7e-F4uw-o8Sx-iwt0-JfLQ-Dpoh-E7lSU1
  LV Write Access        read/write
  LV Creation host, time ubuntu-server, 2022-06-07 11:41:15 +0000
  LV Status              available
  # open                 1
  LV Size                <31.25 GiB
  Current LE             7999
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0

  --- Logical volume ---
  LV Path                /dev/volume_group00/logical_vol1
  LV Name                logical_vol1
  VG Name                volume_group00
  LV UUID                Yusrnj-fFmo-X43R-j3Me-3wTT-rYQ6-yQa0s6
  LV Write Access        read/write
  LV Creation host, time sysadm-fs, 2022-11-29 08:18:43 +0000
  LV Status              available
  # open                 0
  LV Size                100.00 MiB
  Current LE             25
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:1
````

11. Создайте `mkfs.ext4` ФС на получившемся LV.

###### Результат
```` bash
root@sysadm-fs:/home/vagrant# mkfs.ext4 /dev/volume_group00/logical_vol1
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
````

12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.

###### Результат
```` bash
root@sysadm-fs:/home/vagrant# mount /dev/volume_group00/logical_vol1 /tmp/new
root@sysadm-fs:/home/vagrant# ls /tmp/new
lost+found
````

13. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.

###### Результат
````bash
root@sysadm-fs:/home/vagrant# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2022-11-29 08:40:30--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 23603400 (23M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz      100%[========================>]  22.51M  4.97MB/s    in 4.6s    

2022-11-29 08:40:35 (4.88 MB/s) - ‘/tmp/new/test.gz’ saved [23603400/23603400]
````
14. Прикрепите вывод `lsblk`.

###### Результат

```` bash
root@sysadm-fs:/home/vagrant# lsblk
NAME                              MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                               7:0    0 63.2M  1 loop  /snap/core20/1695
loop2                               7:2    0 49.7M  1 loop  
loop3                               7:3    0 91.8M  1 loop  /snap/lxd/23991
loop4                               7:4    0 61.9M  1 loop  /snap/core20/1328
loop5                               7:5    0 67.2M  1 loop  /snap/lxd/21835
loop6                               7:6    0 49.6M  1 loop  /snap/snapd/17883
sda                                 8:0    0   64G  0 disk  
├─sda1                              8:1    0    1M  0 part  
├─sda2                              8:2    0  1.5G  0 part  /boot
└─sda3                              8:3    0 62.5G  0 part  
  └─ubuntu--vg-ubuntu--lv         253:0    0 31.3G  0 lvm   /
sdb                                 8:16   0  2.5G  0 disk  
├─sdb1                              8:17   0    2G  0 part  
│ └─md0                             9:0    0    2G  0 raid1
│   └─volume_group00-logical_vol1 253:1    0  100M  0 lvm   /tmp/new
└─sdb2                              8:18   0  511M  0 part  
  └─md1                             9:1    0 1018M  0 raid0
sdc                                 8:32   0  2.5G  0 disk  
├─sdc1                              8:33   0    2G  0 part  
│ └─md0                             9:0    0    2G  0 raid1
│   └─volume_group00-logical_vol1 253:1    0  100M  0 lvm   /tmp/new
└─sdc2                              8:34   0  511M  0 part  
  └─md1                             9:1    0 1018M  0 raid0
````

15. Протестируйте целостность файла:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```

16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

###### Результат

```` bash
root@sysadm-fs:/home/vagrant# pvmove /dev/md0
  /dev/md0: Moved: 32.00%
  /dev/md0: Moved: 100.00%
root@sysadm-fs:/home/vagrant# lsblk
NAME                              MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                               7:0    0 63.2M  1 loop  /snap/core20/1695
loop2                               7:2    0 49.7M  1 loop  
loop3                               7:3    0 91.8M  1 loop  /snap/lxd/23991
loop4                               7:4    0 61.9M  1 loop  /snap/core20/1328
loop5                               7:5    0 67.2M  1 loop  /snap/lxd/21835
loop6                               7:6    0 49.6M  1 loop  /snap/snapd/17883
sda                                 8:0    0   64G  0 disk  
├─sda1                              8:1    0    1M  0 part  
├─sda2                              8:2    0  1.5G  0 part  /boot
└─sda3                              8:3    0 62.5G  0 part  
  └─ubuntu--vg-ubuntu--lv         253:0    0 31.3G  0 lvm   /
sdb                                 8:16   0  2.5G  0 disk  
├─sdb1                              8:17   0    2G  0 part  
│ └─md0                             9:0    0    2G  0 raid1
└─sdb2                              8:18   0  511M  0 part  
  └─md1                             9:1    0 1018M  0 raid0
    └─volume_group00-logical_vol1 253:1    0  100M  0 lvm   /tmp/new
sdc                                 8:32   0  2.5G  0 disk  
├─sdc1                              8:33   0    2G  0 part  
│ └─md0                             9:0    0    2G  0 raid1
└─sdc2                              8:34   0  511M  0 part  
  └─md1                             9:1    0 1018M  0 raid0
    └─volume_group00-logical_vol1 253:1    0  100M  0 lvm   /tmp/new

````

17. Сделайте `--fail` на устройство в вашем RAID1 md.

###### Результат

```` bash  
root@sysadm-fs:/home/vagrant# mdadm /dev/md0 --fail /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md0
root@sysadm-fs:/home/vagrant# mdadm -D /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Tue Nov 29 06:11:04 2022
        Raid Level : raid1
        Array Size : 2094080 (2045.00 MiB 2144.34 MB)
     Used Dev Size : 2094080 (2045.00 MiB 2144.34 MB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Tue Nov 29 09:01:04 2022
             State : clean, degraded
    Active Devices : 1
   Working Devices : 1
    Failed Devices : 1
     Spare Devices : 0

Consistency Policy : resync

              Name : sysadm-fs:0  (local to host sysadm-fs)
              UUID : 590254f0:751f09fb:4a080e7b:8425d690
            Events : 19

    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1       8       33        1      active sync   /dev/sdc1

       0       8       17        -      faulty   /dev/sdb1
````

18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.

###### Результат
```` bash
root@sysadm-fs:/home/vagrant# dmesg | grep md0
[ 4908.390480] md/raid1:md0: not clean -- starting background reconstruction
[ 4908.390482] md/raid1:md0: active with 2 out of 2 mirrors
[ 4908.390505] md0: detected capacity change from 0 to 2144337920
[ 4908.391556] md: resync of RAID array md0
[ 4918.932715] md: md0: resync done.
[15103.576234] md/raid1:md0: Disk failure on sdb1, disabling device.
               md/raid1:md0: Operation continuing on 1 devices.
````

19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```

###### Результат
```` bash
root@sysadm-fs:/home/vagrant# gzip -t /tmp/new/test.gz
root@sysadm-fs:/home/vagrant# echo $?
0
````


20. Погасите тестовый хост, `vagrant destroy`.

###### Резултат
```` bash
root@sysadm-fs:/home/vagrant# exit
exit
vagrant@sysadm-fs:~$ exit
logout
Connection to 127.0.0.1 closed.
mgnosov@Maksims-MacBook-Pro ~ % vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives...
````

*В качестве решения ответьте на вопросы и опишите, каким образом эти ответы были получены*

----

### Правила приема домашнего задания

В личном кабинете отправлена ссылка на .md файл в вашем репозитории.


### Критерии оценки

Зачет - выполнены все задания, ответы даны в развернутой форме, приложены соответствующие скриншоты и файлы проекта, в выполненных заданиях нет противоречий и нарушения логики.

На доработку - задание выполнено частично или не выполнено, в логике выполнения заданий есть противоречия, существенные недостатки.
