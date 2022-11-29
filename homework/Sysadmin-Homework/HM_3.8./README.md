# Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3" Максим Носов

### Цель задания

В результате выполнения этого задания вы:

1. На практике познакомитесь с маршрутизацией в сетях, что позволит понять устройство больших корпоративных сетей и интернета.
2. Проверите TCP/UDP соединения на хосте (это обычный этап отладки сетевых проблем).
3. Построите сетевую диаграмму.

### Чеклист готовности к домашнему заданию

1. Убедитесь, что у вас установлен `telnet`.
2. Воспользуйтесь пакетным менеджером apt для установки.


### Инструкция к заданию

1. Создайте .md-файл для ответов на задания в своём репозитории, после выполнения прикрепите ссылку на него в личном кабинете.
2. Любые вопросы по выполнению заданий спрашивайте в чате учебной группы и/или в разделе “Вопросы по заданию” в личном кабинете.


### Инструменты/ дополнительные материалы, которые пригодятся для выполнения задания

1. [Зачем нужны dummy интерфейсы](https://tldp.org/LDP/nag/node72.html)

------

## Задание

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
```
telnet route-views.routeviews.org
Username: rviews
show ip route x.x.x.x/32
show bgp x.x.x.x/32
```

###### Результат
```` bash
curl ifconfig.me
    94.25.171.110root@vagrant:/home/vagrant#


route-views>show ip route 94.25.171.110    
Routing entry for 94.25.168.0/22
  Known via "bgp 6447", distance 20, metric 0
  Tag 852, type external
  Last update from 154.11.12.212 2d12h ago
  Routing Descriptor Blocks:
  * 154.11.12.212, from 154.11.12.212, 2d12h ago
      Route metric is 0, traffic share count is 1
      AS Hops 3
      Route tag 852
      MPLS label: none

route-views>show bgp 94.25.171.110
BGP routing table entry for 94.25.168.0/22, version 318043379
Paths: (23 available, best #15, table default)
  Not advertised to any peer
  Refresh Epoch 1
  1351 6939 31133 25159, (aggregated by 25159 10.97.0.229)
    132.198.255.253 from 132.198.255.253 (132.198.255.253)
      Origin IGP, localpref 100, valid, external
      path 7FE0C792FA18 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  4901 6079 31133 25159, (aggregated by 25159 10.97.0.229)
    162.250.137.254 from 162.250.137.254 (162.250.137.254)
      Origin IGP, localpref 100, valid, external
      Community: 65000:10100 65000:10300 65000:10400
      path 7FE08BF39688 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  1221 4637 31133 25159, (aggregated by 25159 10.97.0.229)
    203.62.252.83 from 203.62.252.83 (203.62.252.83)
      Origin IGP, localpref 100, valid, external
      path 7FE0C26A68F8 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
````
2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.

###### Результат
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/homework/Sysadmin-Homework/HM_3.8./img/img00.png">
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/homework/Sysadmin-Homework/HM_3.8./img/img01.png">

3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.

###### Ответ
```` bash
netstat -tlpn
    Active Internet connections (only servers)
    Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
    tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      599/systemd-resolve
    tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      872/sshd: /usr/sbin
    tcp6       0      0 :::22                   :::*                    LISTEN      872/sshd: /usr/sbin
````
Из `netstat` можно увидеть, что в моей версии используются `53` - `DNS порт` и `22` - порт `ssh`.

4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?

###### Ответ
```` bash
netstat -ulpn
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
udp        0      0 127.0.0.53:53           0.0.0.0:*                           599/systemd-resolve
udp        0      0 10.0.2.15:68            0.0.0.0:*                           14956/systemd-network
````
В контексте `UDP`, так же порт `53 - DNS`, `68` - порт `BOOTPC`, также используется протоколом `DHCP`.


5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали.

###### Ответ
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/homework/Sysadmin-Homework/HM_3.8./img/img01.png">

*В качестве решения ответьте на вопросы, опишите, каким образом эти ответы были получены и приложите по неоходимости скриншоты*

 ---

## Задание для самостоятельной отработки* (необязательно к выполнению)

6. Установите Nginx, настройте в режиме балансировщика TCP или UDP.

7. Установите bird2, настройте динамический протокол маршрутизации RIP.

8. Установите Netbox, создайте несколько IP префиксов, используя curl проверьте работу API.

----

### Правила приема домашнего задания

В личном кабинете отправлена ссылка на .md файл в вашем репозитории.

-----

### Критерии оценки

Зачет - выполнены все задания, ответы даны в развернутой форме, приложены соответствующие скриншоты и файлы проекта, в выполненных заданиях нет противоречий и нарушения логики.

На доработку - задание выполнено частично или не выполнено, в логике выполнения заданий есть противоречия, существенные недостатки.

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.
Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.
