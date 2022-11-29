# Домашнее задание к занятию "3.7. Компьютерные сети.Лекция 2" Максим Носов

### Цель задания

В результате выполнения этого задания вы:

1. Познакомитесь с инструментами настройки сети в Linux, агрегации нескольких сетевых интерфейсов, отладки их работы.
2. Примените знания о сетевых адресах на практике для проектирования сети.


### Инструкция к заданию

1. Создайте .md-файл для ответов на задания в своём репозитории, после выполнения прикрепите ссылку на него в личном кабинете.
2. Любые вопросы по выполнению заданий спрашивайте в чате учебной группы и/или в разделе “Вопросы по заданию” в личном кабинете.


### Инструменты/ дополнительные материалы, которые пригодятся для выполнения задания

1. [Калькулятор сетей online](https://calculator.net/ip-subnet-calculator.html).
2. Калькулятор сетей программа - ipcalc (`apt install ipcalc`), если есть графический интерфейс, то у программы калькулятора есть инженерный режим, там можно и сети считать.


------

## Задание

1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?

###### Результат
* На виртуальной машине Vagrant:
```` bash
ip -c -br link
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP>
eth0             UP             08:00:27:b1:28:5d <BROADCAST,MULTICAST,UP,LOWER_UP>
````
* В macOS
```` terminal
networksetup -listallhardwareports

Hardware Port: Wi-Fi
Device: en0
Ethernet Address: 60:f8:1d:c3:67:a0

Hardware Port: Bluetooth PAN
Device: en3
Ethernet Address: 60:f8:1d:c3:67:a1

Hardware Port: Thunderbolt 1
Device: en1
Ethernet Address: 82:0f:1e:1e:94:40

Hardware Port: Thunderbolt 2
Device: en2
Ethernet Address: 82:0f:1e:1e:94:41

Hardware Port: Thunderbolt Bridge
Device: bridge0
Ethernet Address: 82:0f:1e:1e:94:40
````
* В Windows
```` cmd
ipconfig /all
Windows IP Configuration

   Host Name . . . . . . . . . . . . : RUHLRU3D1NYM2
   Primary Dns Suffix  . . . . . . . : atlascopco.group
   Node Type . . . . . . . . . . . . : Hybrid
   IP Routing Enabled. . . . . . . . : No
   WINS Proxy Enabled. . . . . . . . : No
   DNS Suffix Search List. . . . . . : atlascopco.group
                                       emea.group.atlascopco.com
                                       nasa.group.atlascopco.com
                                       apac.group.atlascopco.com
                                       group.atlascopco.com
                                       reno.local

Ethernet adapter Ethernet 2:

   Media State . . . . . . . . . . . : Media disconnected
   Connection-specific DNS Suffix  . :
   Description . . . . . . . . . . . : Intel(R) Ethernet Connection (4) I219-LM
   Physical Address. . . . . . . . . : A4-4C-C8-72-82-4F
   DHCP Enabled. . . . . . . . . . . : Yes
   Autoconfiguration Enabled . . . . : Yes

Ethernet adapter Ethernet 3:

   Media State . . . . . . . . . . . : Media disconnected
   Connection-specific DNS Suffix  . : atlascopco.group
   Description . . . . . . . . . . . : Check Point Virtual Network Adapter For Endpoint VPN Client
   Physical Address. . . . . . . . . : 54-A3-16-4F-FF-03
   DHCP Enabled. . . . . . . . . . . : Yes
   Autoconfiguration Enabled . . . . : Yes

Wireless LAN adapter Wi-Fi:

   Media State . . . . . . . . . . . : Media disconnected
   Connection-specific DNS Suffix  . : emea.group.atlascopco.com
   Description . . . . . . . . . . . : Intel(R) Dual Band Wireless-AC 8265
   Physical Address. . . . . . . . . : 74-E5-F9-F5-42-8B
   DHCP Enabled. . . . . . . . . . . : Yes
   Autoconfiguration Enabled . . . . : Yes

Wireless LAN adapter Local Area Connection* 1:

   Media State . . . . . . . . . . . : Media disconnected
   Connection-specific DNS Suffix  . :
   Description . . . . . . . . . . . : Microsoft Wi-Fi Direct Virtual Adapter
   Physical Address. . . . . . . . . : 74-E5-F9-F5-42-8C
   DHCP Enabled. . . . . . . . . . . : Yes
   Autoconfiguration Enabled . . . . : Yes

Wireless LAN adapter Local Area Connection* 2:

   Media State . . . . . . . . . . . : Media disconnected
   Connection-specific DNS Suffix  . :
   Description . . . . . . . . . . . : Microsoft Wi-Fi Direct Virtual Adapter #2
   Physical Address. . . . . . . . . : 76-E5-F9-F5-42-8B
   DHCP Enabled. . . . . . . . . . . : No
   Autoconfiguration Enabled . . . . : Yes

Ethernet adapter Ethernet:

   Connection-specific DNS Suffix  . : emea.group.atlascopco.com
   Description . . . . . . . . . . . : Realtek USB GbE Family Controller
   Physical Address. . . . . . . . . : A4-4C-C8-8C-63-9D
   DHCP Enabled. . . . . . . . . . . : Yes
   Autoconfiguration Enabled . . . . : Yes
   Link-local IPv6 Address . . . . . : fe80::8956:c41b:58a4:c003%9(Preferred)
   IPv4 Address. . . . . . . . . . . : 10.70.54.216(Preferred)
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Lease Obtained. . . . . . . . . . : 15 февраля 2022 г. 7:23:54
   Lease Expires . . . . . . . . . . : 16 февраля 2022 г. 3:34:40
   Default Gateway . . . . . . . . . : 10.70.54.1
   DHCP Server . . . . . . . . . . . : 10.146.196.10
   DHCPv6 IAID . . . . . . . . . . . : 111430856
   DHCPv6 Client DUID. . . . . . . . : 00-01-00-01-29-1C-23-63-A4-4C-C8-72-82-4F
   DNS Servers . . . . . . . . . . . : 10.70.32.206
                                       10.25.52.13
   NetBIOS over Tcpip. . . . . . . . : Enabled

Ethernet adapter Ethernet 4:

   Media State . . . . . . . . . . . : Media disconnected
   Connection-specific DNS Suffix  . :
   Description . . . . . . . . . . . : Zscaler Network Adapter 1.0.2.0
   Physical Address. . . . . . . . . : 00-FF-97-5B-2F-C8
   DHCP Enabled. . . . . . . . . . . : Yes
   Autoconfiguration Enabled . . . . : Yes

Ethernet adapter Bluetooth Network Connection:

Media State . . . . . . . . . . . : Media disconnected
   Connection-specific DNS Suffix  . :
   Description . . . . . . . . . . . : Bluetooth Device (Personal Area Network)
   Physical Address. . . . . . . . . : 74-E5-F9-F5-42-8F
   DHCP Enabled. . . . . . . . . . . : Yes
   Autoconfiguration Enabled . . . . : Yes
````   

2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?

###### Ответ
Используется протокол `LLDP`
Пакет для установки `LLDPD`. `apt-get install lldpd`.
Команда `lldpctl`

3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.

###### Результат
Технология виртуальных сетей называется `VLAN (virtual local area network)`. Пакет для конфигурирования `VLAN - vconfig`. `apt-get install vlan`. Перед настройкой `VLAN` стоит проверить включен ли модуль `8021q`. Если нет - `modprobe 8021q`.
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/homework/Sysadmin-Homework/HM_3.7./img/img00.png">
^O, ^X
`systemctl network restart`

4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.

###### Ответ
`mode=0 (balance-rr(round-robin))` В данном режиме пакеты отправляются "по кругу" от первого интерфейса к последнему и сначала. Если выходит из строя один из интерфейсов, пакеты отправляются на остальные оставшиеся.
`mode=1 (active-backup)` При `active-backup` один интерфейс работает в активном режиме, остальные в ожидающем. Если активный падает, управление передается одному из ожидающих. Не требует поддержки данной функциональности от коммутатора.
`mode=2 (balance-xor)` Передача пакетов распределяется между объединенными интерфейсами по формуле ((MAC-адрес источника) XOR (MAC-адрес получателя)) % число интерфейсов. Один и тот же интерфейс работает с определённым получателем. Режим даёт балансировку нагрузки и отказоустойчивость.
`mode=3 (broadcast)` Происходит передача во все объединенные интерфейсы, обеспечивая отказоустойчивость.
`mode=4 (802.3ad)` В данном режиме можно получить значительное увеличение пропускной способности как входящего так и исходящего трафика, используя все объединенные интерфейсы. Требует поддержки режима от коммутатора.
`mode=5 (balance-tlb)` Адаптивная балансировка нагрузки. При `balance-tlb` входящий трафик получается только активным интерфейсом, исходящий - распределяется в зависимости от текущей загрузки каждого интерфейса. Обеспечивается отказоустойчивость и распределение нагрузки исходящего трафика. Не требует специальной поддержки коммутатора.
`mode=6 (balance-alb)` Адаптивная балансировка нагрузки (более совершенная). Обеспечивает балансировку нагрузки как исходящего (TLB, transmit load balancing), так и входящего трафика (для IPv4 через ARP). Не требует специальной поддержки коммутатором, но требует возможности изменять MAC-адрес устройства.

```` bash
apt-get install ifenslave
nano /etc/network/interfaces
````
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/homework/Sysadmin-Homework/HM_3.7./img/img01.png">
```` bash
systemctl network restart
cat /proc/net/bonding/bond0 #статус агрегирования
````

5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.

###### Ответ
``/29 = 255.255.255.248``. С данной маской получается `5` `ip` адресов для хостов (т.е `10.0.0.1` - маршрутизатор, `10.0.0.7` - широковещательный). Из сети с ``/24`` маской можно получить `32` подсети с маской ``/29``.
```` bash
Subnets after transition from /24 to /29

Netmask:   255.255.255.248 = 29 11111111.11111111.11111111.11111 000
Wildcard:  0.0.0.7              00000000.00000000.00000000.00000 111

 1.
Network:   10.10.10.0/29        00001010.00001010.00001010.00000 000
HostMin:   10.10.10.1           00001010.00001010.00001010.00000 001
HostMax:   10.10.10.6           00001010.00001010.00001010.00000 110
Broadcast: 10.10.10.7           00001010.00001010.00001010.00000 111
Hosts/Net: 6                     Class A, Private Internet

 2.
Network:   10.10.10.8/29        00001010.00001010.00001010.00001 000
HostMin:   10.10.10.9           00001010.00001010.00001010.00001 001
HostMax:   10.10.10.14          00001010.00001010.00001010.00001 110
Broadcast: 10.10.10.15          00001010.00001010.00001010.00001 111
Hosts/Net: 6                     Class A, Private Internet

 3.
Network:   10.10.10.16/29       00001010.00001010.00001010.00010 000
HostMin:   10.10.10.17          00001010.00001010.00001010.00010 001
HostMax:   10.10.10.22          00001010.00001010.00001010.00010 110
Broadcast: 10.10.10.23          00001010.00001010.00001010.00010 111
Hosts/Net: 6                     Class A, Private Internet
…
Subnets:   32
Hosts:     192
````

6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.

###### Ответ
Возможно задействовать сеть `100.64.0.0/10`. По RFC она так же относится к частным. Исходя из задания возможно сделать сеть `100.64.0.0/26`.
```` bash
ipcalc 100.64.0.0 /26
Address:   100.64.0.0           01100100.01000000.00000000.00 000000
Netmask:   255.255.255.192 = 26 11111111.11111111.11111111.11 000000
Wildcard:  0.0.0.63             00000000.00000000.00000000.00 111111
=>
Network:   100.64.0.0/26        01100100.01000000.00000000.00 000000
HostMin:   100.64.0.1           01100100.01000000.00000000.00 000001
HostMax:   100.64.0.62          01100100.01000000.00000000.00 111110
Broadcast: 100.64.0.63          01100100.01000000.00000000.00 111111
Hosts/Net: 62                    Class A
````

7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?

###### Ответ
Проверка `ARP`-таблицы для `Windows` и `Linux arp -a`, но в случае с `Linux` лучше использовать `arp -e`. Вывод более читаемый.

```` bash
arp -a
? (10.0.2.3) at 52:54:00:12:35:03 [ether] on eth0
_gateway (10.0.2.2) at 52:54:00:12:35:02 [ether] on eth0

arp -e
Address                  HWtype  HWaddress           Flags Mask            Iface
10.0.2.3                 ether   52:54:00:12:35:03   C                     eth0
_gateway                 ether   52:54:00:12:35:02   C                     eth0
````
Очистка `ARP`-кеша в `Windows` производится командой `netsh interface IP delete arpcache`. В `Linux` используется `arp -s -s neigh flush all`.

Для удаления одного адреса в обеих ОС используется команда `arp -d <ip адрес>`.


*В качестве решения ответьте на вопросы и опишите, каким образом эти ответы были получены*

---

## Задание для самостоятельной отработки* (необязательно к выполнению)

 8. Установите эмулятор EVE-ng.

 [Инструкция по установке](https://github.com/svmyasnikov/eve-ng)

 Выполните задания на lldp, vlan, bonding в эмуляторе EVE-ng.

----

### Правила приема домашнего задания

В личном кабинете отправлена ссылка на .md файл в вашем репозитории.


### Критерии оценки

Зачет - выполнены все задания, ответы даны в развернутой форме, приложены соответствующие скриншоты и файлы проекта, в выполненных заданиях нет противоречий и нарушения логики.

На доработку - задание выполнено частично или не выполнено, в логике выполнения заданий есть противоречия, существенные недостатки.

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.
Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.
