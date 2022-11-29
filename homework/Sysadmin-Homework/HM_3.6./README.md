# Домашнее задание к занятию "3.6. Компьютерные сети. Лекция 1"

### Цель задания

В результате выполнения этого задания вы:

1. Научитесь работать с http запросами, чтобы увидеть, как клиенты взаимодействуют с серверами по этому протоколу
2. Поработаете с сетевыми утилитами, чтобы разобраться, как их можно использовать для отладки сетевых запросов, соединений.

### Чеклист готовности к домашнему заданию

1. Убедитесь, что у вас установлены необходимые сетевые утилиты - dig, traceroute, mtr, telnet.
2. Используйте `apt install` для установки пакетов


### Инструкция к заданию

1. Создайте .md-файл для ответов на задания в своём репозитории, после выполнения, прикрепите ссылку на него в личном кабинете.
2. Любые вопросы по выполнению заданий спрашивайте в чате учебной группы и/или в разделе “Вопросы по заданию” в личном кабинете.


### Инструменты/ дополнительные материалы, которые пригодятся для выполнения задания

1. Полезным дополнением к обозначенным выше утилитам будет пакет net-tools. Установить его можно с помощью команды `apt install net-tools`.
2. RFC протокола HTTP/1.0, в частности [страница с кодами ответа](https://www.rfc-editor.org/rfc/rfc1945#page-32).
3. [Ссылки на остальные RFC для HTTP](https://blog.cloudflare.com/cloudflare-view-http3-usage/).

------

## Задание

1. Работа c HTTP через телнет.
- Подключитесь утилитой телнет к сайту stackoverflow.com
`telnet stackoverflow.com 80`
- Отправьте HTTP запрос
```bash
GET /questions HTTP/1.0
HOST: stackoverflow.com
[press enter]
[press enter]
```
*В ответе укажите полученный HTTP код, что он означает?*

###### Ответ
`HTTP/1.1 301 Moved Permanently`. Буквально данный код означает, что ресурс переехал на другой адрес. Далее в ответе `telenet` можно увидеть новый адресс: `https://stackoverflow.com/questions`


2. Повторите задание 1 в браузере, используя консоль разработчика F12.
- откройте вкладку `Network`
- отправьте запрос http://stackoverflow.com
- найдите первый ответ HTTP сервера, откройте вкладку `Headers`
- укажите в ответе полученный HTTP код
- проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?
- приложите скриншот консоли браузера в ответ.

###### Ответ
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/homework/Sysadmin-Homework/HM_3.6./img/img00.png">
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/homework/Sysadmin-Homework/HM_3.6./img/img01.png">
3. Какой IP адрес у вас в интернете?

###### Ответ
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/homework/Sysadmin-Homework/HM_3.6./img/img02.png">
4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой `whois`

###### Результат
```` bash
root@vagrant:/home/vagrant# whois -h whois.ripe.net 94.25.170.224 | grep 'descr'
descr:          YOTA - Moscow and Moskovskaya obl.
descr:          MF-MOSCOW-MBB-94-25-170
descr:          MF-MOSCOW-MBB-94-25-170

    whois -h whois.ripe.net 94.25.170.224 | grep 'origin'
origin:         AS25159
origin:         AS47395
````
5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой `traceroute`

###### Результат
```` bash
traceroute -An 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  10.0.2.2 [*]  1.633 ms  1.599 ms  1.582 ms
 2  172.20.10.1 [*]  1.688 ms  1.937 ms  1.923 ms
 3  * * *
 4  * * *
 5  * * *
 6  * * *
 7  * * *
 8  * * *
 9  * * *
10  * * *
11  * * *
12  * * *
13  * * 142.251.49.78 [AS15169]  70.500 ms
14  142.251.49.78 [AS15169]  75.995 ms 216.239.43.20 [AS15169]  76.173 ms  76.154 ms
15  216.239.47.167 [AS15169]  82.402 ms 142.250.209.35 [AS15169]  82.390 ms 142.250.209.25 [AS15169]  82.379 ms
16  * * *
17  * * *
18  * * *
19  * * *
20  * * *
21  * * *
22  * * *
23  * * 8.8.8.8 [AS15169]  53.366 ms
````
`10.0.2.2` - адрес вируталки Vagrant
`172.20.10.1` - точка доступа на телефоне
`142.251.49.78`
`142.251.49.78`, `216.239.43.20`
`216.239.47.167`, `142.250.209.35`, `142.250.209.25`
Автономная система - `AS15169`

6. Повторите задание 5 в утилите `mtr`. На каком участке наибольшая задержка - delay?

###### Результат
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/homework/Sysadmin-Homework/HM_3.6./img/img03.png">

7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? Воспользуйтесь утилитой `dig`

###### Результат
```` bash
dig +trace dns.google

DiG 9.16.1-Ubuntu +trace dns.google
;; global options: +cmd
.			4453	IN	NS	c.root-servers.net.
.			4453	IN	NS	j.root-servers.net.
.			4453	IN	NS	l.root-servers.net.
.			4453	IN	NS	h.root-servers.net.
.			4453	IN	NS	f.root-servers.net.
.			4453	IN	NS	e.root-servers.net.
.			4453	IN	NS	g.root-servers.net.
.			4453	IN	NS	d.root-servers.net.
.			4453	IN	NS	b.root-servers.net.
.			4453	IN	NS	a.root-servers.net.
.			4453	IN	NS	k.root-servers.net.
.			4453	IN	NS	i.root-servers.net.
.			4453	IN	NS	m.root-servers.net.
;; Received 262 bytes from 127.0.0.53#53(127.0.0.53) in 3 ms

google.			172800	IN	NS	ns-tld2.charlestonroadregistry.com.
google.			172800	IN	NS	ns-tld1.charlestonroadregistry.com.
google.			172800	IN	NS	ns-tld5.charlestonroadregistry.com.
google.			172800	IN	NS	ns-tld4.charlestonroadregistry.com.
google.			172800	IN	NS	ns-tld3.charlestonroadregistry.com.
google.			86400	IN	DS	6125 8 2 80F8B78D23107153578BAD3800E9543500474E5C30C29698B40A3DB2 3ED9DA9F
google.			86400	IN	RRSIG	DS 8 1 86400 20220227050000 20220214040000 9799 . Pwwi6MoqPBz1lwRCDWvLIa/y7sNYTZ+27Ar7U0XO29ZdkzI9/axtYteK 7LKyFM8qPY+Db4UjeRETECtZ4KWsSapJ954TdOEMb8sWJtmy7VbjxujL fXMCe1O3OjPOM4zvqtC91KrWEcmp0WD8lrF9Sl7Vv7a1NfqNhOsgWKED pr+RUbzbG9bCLz/MjBDxES5Q4JDbivMhDpeVP1IZDrnC8Oz/g+yp3bUW MqBKwoRqCUO2K+/LYNjYQAtMzrpH1wtNVMTuTShHacapA6/gVz56ng6T yRHsT1TF9Lvn0Eiwxppra72Os4s2GtRSgyocAEpL227XjtuDKLALpGSl lPhAuw==
;; Received 758 bytes from 192.33.4.12#53(c.root-servers.net) in 119 ms

dns.google.		10800	IN	NS	ns2.zdns.google.
dns.google.		10800	IN	NS	ns4.zdns.google.
dns.google.		10800	IN	NS	ns3.zdns.google.
dns.google.		10800	IN	NS	ns1.zdns.google.
dns.google.		3600	IN	DS	56044 8 2 1B0A7E90AA6B1AC65AA5B573EFC44ABF6CB2559444251B997103D2E4 0C351B08
dns.google.		3600	IN	RRSIG	DS 8 2 3600 20220305171116 20220211171116 39106 google. Cu27ometfUKfhQzo2Ks8qNROOkbXU7YpXQlredYRmxiEBggHy37QY1TM ZhY6RjUJTvOI5LtzKbPNV87jJ8rIJfXJFcgm62qLCqK7WnddD/z2wHcO AidLBWIT7uHaQORe3+4LDGkK8rtiw5tbflqL8NcCQay8O3fjRpIwWfFH Zyo=
;; Received 506 bytes from 216.239.38.105#53(ns-tld4.charlestonroadregistry.com) in 83 ms

dns.google.		900	IN	A	8.8.8.8
dns.google.		900	IN	A	8.8.4.4
dns.google.		900	IN	RRSIG	A 8 2 900 20220307120732 20220213120732 25800 dns.google. Kap8xUB2kuHwdtW+zn+rUsoEVQgtUhFV8D9ora+4xHxhmehohTvJ1ES9 cs1oq7igHDlfRTkw9F6LIhPoNXtGrPM8EANzL2MJ6DAZOTOuqsgHYiJ1 b6whTQUAuEUB6VxQ25ESSAg51RTvxfI+52P5ufb7Z9N0FzEk0z87viUv ovQ=
;; Received 241 bytes from 216.239.36.114#53(ns3.zdns.google) in 31 ms
````
Сервера типа А: `8.8.8.8` и `8.8.4.4`


8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? Воспользуйтесь утилитой `dig`

###### Результат
```` bash
dig -x 8.8.4.4
 DiG 9.16.1-Ubuntu -x 8.8.4.4
;; global options: +cmd
;; Got answer:
;; -HEADER- opcode: QUERY, status: NOERROR, id: 57132
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;4.4.8.8.in-addr.arpa.		IN	PTR
;; ANSWER SECTION:
4.4.8.8.in-addr.arpa.	58214	IN	PTR	dns.google.
;; Query time: 63 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Mon Feb 14 13:03:52 UTC 2022
;; MSG SIZE  rcvd: 73

dig -x 8.8.8.8
; DiG 9.16.1-Ubuntu -x 8.8.8.8
;; global options: +cmd
;; Got answer:
;; -HEADER- opcode: QUERY, status: NOERROR, id: 15372
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;8.8.8.8.in-addr.arpa.		IN	PTR
;; ANSWER SECTION:
8.8.8.8.in-addr.arpa.	7016	IN	PTR	dns.google.
;; Query time: 0 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Mon Feb 14 13:05:17 UTC 2022
;; MSG SIZE  rcvd: 73
````
Доменное имя в обоих случаях `dns.google`.


*В качестве ответов на вопросы приложите лог выполнения команд в консоли или скриншот полученных результатов.*

----

### Правила приема домашнего задания

В личном кабинете отправлена ссылка на .md файл в вашем репозитории.


### Критерии оценки

Зачет - выполнены все задания, ответы даны в развернутой форме, приложены соответствующие скриншоты и файлы проекта, в выполненных заданиях нет противоречий и нарушения логики.

На доработку - задание выполнено частично или не выполнено, в логике выполнения заданий есть противоречия, существенные недостатки.
