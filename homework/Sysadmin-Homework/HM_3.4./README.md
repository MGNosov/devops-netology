# Домашнее задание к занятию "3.4. Операционные системы. Лекция 2" Максим Носов

### Цель задания

В результате выполнения этого задания вы:
1. Познакомитесь со средством сбора метрик node_exporter и средством сбора и визуализации метрик NetData. Такого рода инструменты позволяют выстроить систему мониторинга сервисов для своевременного выявления проблем в их работе.
2. Построите простой systemd unit файл для создания долгоживущих процессов, которые стартуют вместе со стартом системы автоматически.
3. Проанализируете dmesg, а именно часть лога старта виртуальной машины, чтобы понять, какая полезная информация может там находиться.
4. Поработаете с unshare и nsenter для понимания, как создать отдельный namespace для процесса (частичная контейнеризация).

### Чеклист готовности к домашнему заданию

1. Убедитесь, что у вас установлен [Netdata](https://github.com/netdata/netdata) c ресурса с предподготовленными [пакетами](https://packagecloud.io/netdata/netdata/install) или `sudo apt install -y netdata`.


### Инструменты/ дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация](https://www.freedesktop.org/software/systemd/man/systemd.service.html) по systemd unit файлам
2. [Документация](https://www.kernel.org/doc/Documentation/sysctl/) по параметрам sysctl

------

## Задание

1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:

###### Результат
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/homework/Sysadmin-Homework/HM_3.4./img/img00.png">
```` bash
systemctl start node_exporter
systemctl status node_exporter
● node_exporter.service - Node Exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; disabled; vendo>
     Active: active (running) since Thu 2022-03-10 06:47:53 UTC; 8s ago
   Main PID: 1497 (node_exporter)
      Tasks: 4 (limit: 1071)
     Memory: 2.5M
     CGroup: /system.slice/node_exporter.service
             └─1497 /usr/local/bin/node_exporter

Mar 10 06:47:53 vagrant node_exporter[1497]: ts=2022-03-10T06:47:53.557Z caller>
Mar 10 06:47:53 vagrant node_exporter[1497]: ts=2022-03-10T06:47:53.557Z caller>
Mar 10 06:47:53 vagrant node_exporter[1497]: ts=2022-03-10T06:47:53.557Z caller>
Mar 10 06:47:53 vagrant node_exporter[1497]: ts=2022-03-10T06:47:53.557Z caller>
Mar 10 06:47:53 vagrant node_exporter[1497]: ts=2022-03-10T06:47:53.557Z caller>
Mar 10 06:47:53 vagrant node_exporter[1497]: ts=2022-03-10T06:47:53.557Z caller>
Mar 10 06:47:53 vagrant node_exporter[1497]: ts=2022-03-10T06:47:53.557Z caller>
Mar 10 06:47:53 vagrant node_exporter[1497]: ts=2022-03-10T06:47:53.557Z caller>
Mar 10 06:47:53 vagrant node_exporter[1497]: ts=2022-03-10T06:47:53.557Z caller>
Mar 10 06:47:53 vagrant node_exporter[1497]: ts=2022-03-10T06:47:53.557Z caller>
````
    * поместите его в автозагрузку,
    ###### Результат
    ```` bash
    systemctl enable node_exporter
    Created symlink /etc/systemd/system/multi-user.target.wants/node_exporter.service → /etc/systemd/system/node_exporter.service.
    nano /etc/systemd/system/node_exporter.service
    [Unit]
    Description=Node Exporter
    After=network.target

    [Service]
    User=root
    Type=simple
    EnvironmentFile=- /etc/sysconfig/node_exporter
    ExecStart=/usr/local/bin/node_exporter $OPTIONS

    [Install]
    WantedBy=multi-user.target




    ^O, ^X.
    systemctl daemon-reload
    systemctl restart node_exporter
    ````
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),    
    * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.
    ###### Результат
    ```` bash
    vagrant ssh
    Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

    * Documentation:  https://help.ubuntu.com
    * Management:     https://landscape.canonical.com
    * Support:        https://ubuntu.com/advantage

    System information as of Thu 10 Mar 2022 06:55:14 AM UTC

    System load:  0.02               Processes:             122
    Usage of /:   12.0% of 30.88GB   Users logged in:       0
    Memory usage: 18%                IPv4 address for eth0: 10.0.2.15
    Swap usage:   0%


    This system is built by the Bento project by Chef Software
    More information can be found at https://github.com/chef/bento
    Last login: Thu Mar 10 05:46:11 2022 from 10.0.2.2
    vagrant@vagrant:~$ sudo su
    root@vagrant:/home/vagrant# systemctl status node_exporter
    ● node_exporter.service - Node Exporter
      Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor>
      Active: active (running) since Thu 2022-03-10 06:28:57 UTC; 26min ago
      Main PID: 632 (node_exporter)
        Tasks: 4 (limit: 1071)
        Memory: 14.2M
        CGroup: /system.slice/node_exporter.service
             └─632 /usr/local/bin/node_exporter

             Mar 10 06:28:57 vagrant node_exporter[632]: ts=2022-03-10T06:28:57.321Z caller=>
             Mar 10 06:28:57 vagrant node_exporter[632]: ts=2022-03-10T06:28:57.321Z caller=>
             Mar 10 06:28:57 vagrant node_exporter[632]: ts=2022-03-10T06:28:57.321Z caller=>
             Mar 10 06:28:57 vagrant node_exporter[632]: ts=2022-03-10T06:28:57.321Z caller=>
             Mar 10 06:28:57 vagrant node_exporter[632]: ts=2022-03-10T06:28:57.321Z caller=>
             Mar 10 06:28:57 vagrant node_exporter[632]: ts=2022-03-10T06:28:57.321Z caller=>
             Mar 10 06:28:57 vagrant node_exporter[632]: ts=2022-03-10T06:28:57.322Z caller=>
             Mar 10 06:28:57 vagrant node_exporter[632]: ts=2022-03-10T06:28:57.322Z caller=>
             Mar 10 06:28:57 vagrant node_exporter[632]: ts=2022-03-10T06:28:57.322Z caller=>
             Mar 10 06:28:57 vagrant node_exporter[632]: ts=2022-03-10T06:28:57.331Z caller=>
             lines 1-19/19 (END)

    ````



2. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.

###### Результат
* CPU
```` bash
curl localhost:9100/metrics | grep cpu
node_cpu_seconds_total{cpu="0",mode="idle"} 2821.76
node_cpu_seconds_total{cpu="0",mode="user"} 12
node_cpu_seconds_total{cpu="1",mode="idle"} 2820.57
node_cpu_seconds_total{cpu="1",mode="system"} 13.8
node_cpu_seconds_total{cpu="1",mode="user"} 9.25
process_cpu_seconds_total 0.14
````
* MEMORY
```` bash
curl localhost:9100/metrics | grep memory
node_memory_MemTotal_bytes 1.028685824e+09
node_memory_MemAvailable_bytes 6.92453376e+08
````
* DISK
```` bash
curl localhost:9100/metrics | grep disk
node_disk_io_time_seconds_total{device="sda"} 9.61
node_disk_read_bytes_total{device="sda"} 2.734592e+08
node_disk_read_time_seconds_total{device="sda"} 4.465
node_disk_write_time_seconds_total{device="sda"} 1.828
````
* NETWORK
```` bash
curl localhost:9100/metrics | grep network
node_network_receive_bytes_total{device="eth0"} 545883
node_network_receive_errs_total{device="eth0"} 0
node_network_transmit_bytes_total{device="eth0"} 1.309181e+06
node_network_transmit_errs_total{device="eth0"} 0
````

3. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`).

   После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

    ```bash
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    ```

    После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.

###### Результат
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/homework/Sysadmin-Homework/HM_3.4./img/img01.png">
```` bash
root@vagrant:/home/vagrant# nano /etc/netdata/netdata.conf
  GNU nano 4.8/etc/netdata/netdata.conf Modified  
# NetData Configuration

# The current full configuration can be retrieved from the running
# server at the URL
#
#   http://localhost:19999/netdata.conf
#
# for example:
#
#   wget -O /etc/netdata/netdata.conf http://localhost:19999/netdata.conf
#

[global]
        run as user = netdata
        web files owner = root
        web files group = root
        # Netdata is not designed to be exposed to potentially hostile
        # networks. See https://github.com/netdata/netdata/issues/164
        bind socket to IP = 127.0.0.1
[web]
        bind to = 0.0.0.0

nano vagrantfile
config.vm.box = "bento/ubuntu-20.04"
 config.vm.network "forwarded_port", guest: 19999, host: 19999
  	config.vm.network "forwarded_port", guest: 9100, host: 9100
  	config.vm.network "forwarded_port", guest: 80, host: 80
  	config.vm.network "forwarded_port", guest:443, host: 443
^O, ^X.
````

4. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?

###### Результат
```` bash
dmesg | grep virtual
[    0.002069] CPU MTRRs all blank - virtualized system.
[    0.151919] Booting paravirtualized kernel on KVM
[    2.747234] systemd[1]: Detected virtualization oracle.
````
Да, такое возможно. Более того, судя по выводу, можно увидеть провайдера виртуализации.

5. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Определите, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?

###### Ответ
```` bash
/sbin/sysctl -n fs.nr_open
1048576
````
Обозначение максимального количества файловых дескрипторов, которые может выделить процесс. Значение по умолчанию — `1024*1024 (1048576)`, чего должно быть достаточно для большинства машин.
`ulimit -Hn` – жесткий лимит на пользователя, не может быть увеличен.


6. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.

###### Результат
```` bash
ps aux | grep sleep
root        1481  0.0  0.0   5704   528 pts/1    S    11:27   0:00 sleep 1h
root        1487  0.0  0.0   6632   664 pts/1    S+   11:27   0:00 grep --color=auto sleep
root@vagrant:/home/vagrant# nsenter --target 1481 --pid --mount --no-fork
root@vagrant:/#
root@vagrant:/# ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.0   5704   528 pts/1    S    11:27   0:00 sleep 1h
root          12  0.0  0.3   9092  3460 pts/1    R+   11:29   0:00 ps aux
````

7. Найдите информацию о том, что такое ``:(){ :|:& };:``. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации.  
Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?

###### Ответ
``:(){ :|:& };:`` - это форк-бомба, одна из форм DoS-атак. Она создает себя n-количество раз, тем самым быстро исчерпав ресурсы ОС. Используя вызов `dmesg` установил, что форк-бомбу остановил данный механизм: `cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-3.scope`. Погуглив про форк-бомбу и пройдя в директорию ``/sys/fs/cgroup/pids/user.slice/user-1000.slice/session-3.scope``
Нашёл файл `pids.max`, полагаю он отвечает за максимальное число запущенных процессов в системе. Конкретно в моей - 2356
`cat /sys/fs/cgroup/pids/user.slice/user-1000.slice/session-3.scope/pids.max
2356`.


*В качестве решения ответьте на вопросы и опишите каким образом эти ответы были получены*

----

### Правила приема домашнего задания

В личном кабинете отправлена ссылка на .md файл в вашем репозитории.

-----

### Критерии оценки

Зачет - выполнены все задания, ответы даны в развернутой форме, приложены соответствующие скриншоты и файлы проекта, в выполненных заданиях нет противоречий и нарушения логики.

На доработку - задание выполнено частично или не выполнено, в логике выполнения заданий есть противоречия, существенные недостатки.
