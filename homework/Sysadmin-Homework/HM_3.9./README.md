# Домашнее задание к занятию "3.9. Элементы безопасности информационных систем" Максим Носов


### Цель задания

В результате выполнения этого задания вы:

1. Настроите парольный менеджер, что позволит не использовать один и тот же пароль на все ресурсы и удобно работать с множеством паролей.
2. Настроите веб-сервер на работу с https. Сегодня https является стандартом в интернете. Понимание сути работы центра сертификации, цепочки сертификатов позволит понять, на чем основывается https протокол.
3. Сконфигурируете ssh клиент на работу с разными серверами по-разному, что дает большую гибкость ssh соединений. Например, к некоторым серверам мы можем обращаться по ssh через приложения, где недоступен ввод пароля.
4. Поработаете со сбором и анализом трафика, которые необходимы для отладки сетевых проблем


### Инструкция к заданию

1. Создайте .md-файл для ответов на задания в своём репозитории, после выполнения прикрепите ссылку на него в личном кабинете.
2. Любые вопросы по выполнению заданий спрашивайте в чате учебной группы и/или в разделе “Вопросы по заданию” в личном кабинете.


### Инструменты/ дополнительные материалы, которые пригодятся для выполнения задания

1. [SSL + Apache2](https://digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-apache-in-ubuntu-20-04)

------

## Задание

1. Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.

###### Ответ
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/homework/Sysadmin-Homework/HM_3.9./img/img00.png">

2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.

###### Ответ
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/homework/Sysadmin-Homework/HM_3.9./img/img01.png">
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/homework/Sysadmin-Homework/HM_3.9./img/img02.png">

3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.

###### Результат
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/homework/Sysadmin-Homework/HM_3.9./img/img03.png">
```` bash
vagrant@vagrant:~$ apt-install apache2
````
* Vagrantfile
```` ruby
config.vm.box = "bento/ubuntu-20.04"
  config.vm.network "forwarded_port", guest: 19999, host: 19999
  config.vm.network "forwarded_port", guest: 9100, host: 9100
  config.vm.network "forwarded_port", guest: 80, host: 80
````
```` bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/test1.key -out /etc/ssl/certs/test1.crt -subj "/C=RU/ST=Moscow/L=Moscow/O=Organiztion/OU=Org/CN=localhost.com"

nano /etc/apache2/sites-available/default-ssl.conf
<IfModule mod_ssl.c>
        <VirtualHost _default_:443>
                ServerAdmin webmaster@localhost
                ServerName 127.0.0.1
                DocumentRoot /var/www/test1

                ErrorLog ${APACHE_LOG_DIR}/error.log
                CustomLog ${APACHE_LOG_DIR}/access.log combined

                SSLEngine on
                SSLCertificateFile /etc/ssl/certs/test1.crt
                SSLCertificateKeyFile /etc/ssl/private/test1.key


mkdir /var/www/test1
nano /var/www/test1/index.html
	<h1>Hello world!</h1>
^O, ^X

a2ensite default-ssl.conf
Site default-ssl already enabled

apache2ctl configtest
Syntax OK

systemctl reload apache2
````

* Vagrantfile
```` ruby
config.vm.box = "bento/ubuntu-20.04"
  config.vm.network "forwarded_port", guest: 19999, host: 19999
  config.vm.network "forwarded_port", guest: 9100, host: 9100
  config.vm.network "forwarded_port", guest: 80, host: 80
  config.vm.network "forwarded_port", guest: 443, host: 443
  ````
Изначально было предупреждение, что сайт небезопасен для посещения, видимо из-за самоподписанного сертификата.
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/homework/Sysadmin-Homework/HM_3.9./img/img04.png">

4. Проверьте на TLS уязвимости произвольный сайт в интернете (кроме сайтов МВД, ФСБ, МинОбр, НацБанк, РосКосмос, РосАтом, РосНАНО и любых госкомпаний, объектов КИИ, ВПК ... и тому подобное).

###### Результат
```` bash
./testssl.sh -U --sneaky https://www.atlascopco.com/ru-ru

###########################################################
    testssl.sh       3.1dev from https://testssl.sh/dev/
    (7b38198 2022-02-17 09:04:23 -- )

      This program is free software. Distribution and
             modification under GPLv2 permitted.
      USAGE w/o ANY WARRANTY. USE IT AT YOUR OWN RISK!

       Please file bugs @ https://testssl.sh/bugs/

###########################################################

 Using "OpenSSL 1.0.2-chacha (1.0.2k-dev)" [~183 ciphers]
 on Maksims-MacBook-Pro:./bin/openssl.Darwin.x86_64
 (built: "Feb 22 09:55:43 2019", platform: "darwin64-x86_64-cc")


Testing all IPv4 addresses (port 443): 143.204.198.125 143.204.198.117 143.204.198.20 143.204.198.4
--------------------------------------------------------------------------------------------------------------------
 Start 2022-02-25 17:22:35        -- 143.204.198.125:443 (www.atlascopco.com) --

 Further IP addresses:   143.204.198.20 143.204.198.4 143.204.198.117
 rDNS (143.204.198.125): server-143-204-198-125.lhr3.r.cloudfront.net.
 Service detected:       HTTP


 Testing vulnerabilities

 Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
 CCS (CVE-2014-0224)                       not vulnerable (OK)
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK), no session tickets
 ROBOT                                     not vulnerable (OK)
 Secure Renegotiation (RFC 5746)           OpenSSL handshake didn't succeed
 Secure Client-Initiated Renegotiation     not vulnerable (OK)
 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
 BREACH (CVE-2013-3587)                    potentially NOT ok, "gzip" HTTP compression detected. - only supplied "/ru-ru" tested
                                           Can be ignored for static pages or if no secrets in the page
 POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
 TLS_FALLBACK_SCSV (RFC 7507)              No fallback possible (OK), no protocol below TLS 1.2 offered
 SWEET32 (CVE-2016-2183, CVE-2016-6329)    not vulnerable (OK)
 FREAK (CVE-2015-0204)                     not vulnerable (OK)
 DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                           make sure you don't use this certificate elsewhere with SSLv2 enabled services
                                           https://censys.io/ipv4?q=F547C592EB64105EA57FB45AD3FF830D4EE327337A274AEAEF2A9EB551744DCF could help you to find out
 LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no DH key detected with = TLS 1.2
 BEAST (CVE-2011-3389)                     not vulnerable (OK), no SSL3 or TLS1
 LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
 Winshock (CVE-2014-6321), experimental    not vulnerable (OK)
 RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)


 Done 2022-02-25 17:24:59 [0449s] -- 143.204.198.125:443 (www.atlascopco.com) --

--------------------------------------------------------------------------------------------------------------------
 Start 2022-02-25 17:24:59        -- 143.204.198.117:443 (www.atlascopco.com) --

 Further IP addresses:   143.204.198.125 143.204.198.20 143.204.198.4
 rDNS (143.204.198.117): server-143-204-198-117.lhr3.r.cloudfront.net.
 Service detected:       HTTP


 Testing vulnerabilities

 Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
 CCS (CVE-2014-0224)                       not vulnerable (OK)
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK), no session tickets
 ROBOT                                     not vulnerable (OK)
 Secure Renegotiation (RFC 5746)           OpenSSL handshake didn't succeed
 Secure Client-Initiated Renegotiation     not vulnerable (OK)
 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
 BREACH (CVE-2013-3587)                    potentially NOT ok, "gzip" HTTP compression detected. - only supplied "/ru-ru" tested
                                           Can be ignored for static pages or if no secrets in the page
 POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
 TLS_FALLBACK_SCSV (RFC 7507)              No fallback possible (OK), no protocol below TLS 1.2 offered
 SWEET32 (CVE-2016-2183, CVE-2016-6329)    not vulnerable (OK)
 FREAK (CVE-2015-0204)                     not vulnerable (OK)
 DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                           make sure you don't use this certificate elsewhere with SSLv2 enabled services
                                           https://censys.io/ipv4?q=F547C592EB64105EA57FB45AD3FF830D4EE327337A274AEAEF2A9EB551744DCF could help you to find out
 LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no DH key detected with <= TLS 1.2
 BEAST (CVE-2011-3389)                     not vulnerable (OK), no SSL3 or TLS1
 LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
 Winshock (CVE-2014-6321), experimental    not vulnerable (OK)
 RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)


 Done 2022-02-25 17:27:24 [0594s] -- 143.204.198.117:443 (www.atlascopco.com) --

--------------------------------------------------------------------------------------------------------------------
 Start 2022-02-25 17:27:24        -- 143.204.198.20:443 (www.atlascopco.com) --

 Further IP addresses:   143.204.198.125 143.204.198.4 143.204.198.117
 rDNS (143.204.198.20):  server-143-204-198-20.lhr3.r.cloudfront.net.
 Service detected:       HTTP


 Testing vulnerabilities

 Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
 CCS (CVE-2014-0224)                       not vulnerable (OK)
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK), no session tickets
 ROBOT                                     not vulnerable (OK)
 Secure Renegotiation (RFC 5746)           OpenSSL handshake didn't succeed
 Secure Client-Initiated Renegotiation     not vulnerable (OK)
 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
 BREACH (CVE-2013-3587)                    potentially NOT ok, "gzip" HTTP compression detected. - only supplied "/ru-ru" tested
                                           Can be ignored for static pages or if no secrets in the page
 POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
 TLS_FALLBACK_SCSV (RFC 7507)              No fallback possible (OK), no protocol below TLS 1.2 offered
 SWEET32 (CVE-2016-2183, CVE-2016-6329)    not vulnerable (OK)
 FREAK (CVE-2015-0204)                     not vulnerable (OK)
 DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                           make sure you don't use this certificate elsewhere with SSLv2 enabled services
                                           https://censys.io/ipv4?q=F547C592EB64105EA57FB45AD3FF830D4EE327337A274AEAEF2A9EB551744DCF could help you to find out
 LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no DH key detected with = TLS 1.2
 BEAST (CVE-2011-3389)                     not vulnerable (OK), no SSL3 or TLS1
 LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
 Winshock (CVE-2014-6321), experimental    not vulnerable (OK)
 RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)


 Done 2022-02-25 17:29:41 [0731s] -- 143.204.198.20:443 (www.atlascopco.com) --

--------------------------------------------------------------------------------------------------------------------
 Start 2022-02-25 17:29:41        -- 143.204.198.4:443 (www.atlascopco.com) --

 Further IP addresses:   143.204.198.125 143.204.198.20 143.204.198.117
 rDNS (143.204.198.4):   server-143-204-198-4.lhr3.r.cloudfront.net.
 Service detected:       HTTP


 Testing vulnerabilities

 Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
 CCS (CVE-2014-0224)                       not vulnerable (OK)
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK), no session tickets
 ROBOT                                     not vulnerable (OK)
 Secure Renegotiation (RFC 5746)           OpenSSL handshake didn't succeed
 Secure Client-Initiated Renegotiation     not vulnerable (OK)
 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
 BREACH (CVE-2013-3587)                    potentially NOT ok, "gzip" HTTP compression detected. - only supplied "/ru-ru" tested
                                           Can be ignored for static pages or if no secrets in the page
 POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
 TLS_FALLBACK_SCSV (RFC 7507)              No fallback possible (OK), no protocol below TLS 1.2 offered
 SWEET32 (CVE-2016-2183, CVE-2016-6329)    not vulnerable (OK)
 FREAK (CVE-2015-0204)                     not vulnerable (OK)
 DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                           make sure you don't use this certificate elsewhere with SSLv2 enabled services
                                           https://censys.io/ipv4?q=F547C592EB64105EA57FB45AD3FF830D4EE327337A274AEAEF2A9EB551744DCF could help you to find out
 LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no DH key detected with <= TLS 1.2
 BEAST (CVE-2011-3389)                     not vulnerable (OK), no SSL3 or TLS1
 LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
 Winshock (CVE-2014-6321), experimental    not vulnerable (OK)
 RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)


 Done 2022-02-25 17:32:00 [0870s] -- 143.204.198.4:443 (www.atlascopco.com) --

--------------------------------------------------------------------------------------------------------------------
Done testing now all IP addresses (on port 443): 143.204.198.125 143.204.198.117 143.204.198.20 143.204.198.4
````

5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.

###### Ответ
Для данного задания сделал две дополнительных виртуальных машины на `Ubuntu Desktop 20.04` c именами `UbuntuVm1` и `UbuntuVm2`. Объединил их в одной подсети добавив адаптеры.
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/homework/Sysadmin-Homework/HM_3.9./img/img05.png">
`ping` обеих машин
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/homework/Sysadmin-Homework/HM_3.9./img/img06.png">
Ключ был создан, перенесён на удалённый сервер. Подключение прошло по публичному ключу:
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/homework/Sysadmin-Homework/HM_3.9./img/img07.png">

6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.

###### Ответ
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/homework/Sysadmin-Homework/HM_3.9./img/img08.png">
Содержание конфигурационного файла и подтверждение входа по имени сервера:
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/homework/Sysadmin-Homework/HM_3.9./img/img09.png">

7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.

###### Результат
```` bash
apt install tcpdump

    apt install tshark  

root@vagrant:/home/vagrant# tcpdump -c 100 -w dump1.pcap
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
100 packets captured
156 packets received by filter
0 packets dropped by kernel

root@vagrant:/home/vagrant# tshark -r dump1.pcap
Running as user "root" and group "root". This could be dangerous.
    1   0.000000    10.0.2.15 → 10.0.2.2     SSH 90 Server: Encrypted packet (len=36)
    2   0.000401     10.0.2.2 → 10.0.2.15    TCP 60 49599 → 22 [ACK] Seq=1 Ack=37 Win=65535 Len=0
    3   5.625715     10.0.2.2 → 10.0.2.15    HTTP 485 GET /api/v1/alarms?active&_=1646057797126 HTTP/1.1
    4   5.625871    10.0.2.15 → 10.0.2.2     HTTP 593 HTTP/1.1 200 OK  (application/json)
    5   5.626015     10.0.2.2 → 10.0.2.15    TCP 60 49412 → 19999 [ACK] Seq=432 Ack=540 Win=65535 Len=0
    6  19.750211     10.0.2.2 → 10.0.2.15    HTTP 485 GET /api/v1/alarms?active&_=1646057797127 HTTP/1.1
    7  19.750359    10.0.2.15 → 10.0.2.2     HTTP 593 HTTP/1.1 200 OK  (application/json)
    8  19.750501     10.0.2.2 → 10.0.2.15    TCP 60 49412 → 19999 [ACK] Seq=863 Ack=1079 Win=65535 Len=0
    9  34.750569     10.0.2.2 → 10.0.2.15    HTTP 485 GET /api/v1/alarms?active&_=1646057797128 HTTP/1.1
   10  34.750737    10.0.2.15 → 10.0.2.2     HTTP 592 HTTP/1.1 200 OK  (application/json)
   11  34.750918     10.0.2.2 → 10.0.2.15    TCP 60 49412 → 19999 [ACK] Seq=1294 Ack=1617 Win=65535 Len=0
   12  44.754743     10.0.2.2 → 10.0.2.15    HTTP 485 GET /api/v1/alarms?active&_=1646057797129 HTTP/1.1
   13  44.754910    10.0.2.15 → 10.0.2.2     HTTP 592 HTTP/1.1 200 OK  (application/json)
   14  44.755281     10.0.2.2 → 10.0.2.15    TCP 60 49412 → 19999 [ACK] Seq=1725 Ack=2155 Win=65535 Len=0
   15  56.680689     10.0.2.2 → 10.0.2.15    HTTP 485 GET /api/v1/alarms?active&_=1646057797130 HTTP/1.1
   16  56.680887    10.0.2.15 → 10.0.2.2     HTTP 592 HTTP/1.1 200 OK  (application/json)
   17  56.681107     10.0.2.2 → 10.0.2.15    TCP 60 49412 → 19999 [ACK] Seq=2156 Ack=2693 Win=65535 Len=0
   18  69.579501     10.0.2.2 → 10.0.2.15    HTTP 485 GET /api/v1/alarms?active&_=1646057797131 HTTP/1.1
   19  69.579786    10.0.2.15 → 10.0.2.2     HTTP 593 HTTP/1.1 200 OK  (application/json)
   20  69.579993     10.0.2.2 → 10.0.2.15    TCP 60 49412 → 19999 [ACK] Seq=2587 Ack=3232 Win=65535 Len=0
   21  79.879951     10.0.2.2 → 10.0.2.15    HTTP 485 GET /api/v1/alarms?active&_=1646057797132 HTTP/1.1
   22  79.880195    10.0.2.15 → 10.0.2.2     HTTP 593 HTTP/1.1 200 OK  (application/json)
   23  79.880376     10.0.2.2 → 10.0.2.15    TCP 60 49412 → 19999 [ACK] Seq=3018 Ack=3771 Win=65535 Len=0
   24  89.883840     10.0.2.2 → 10.0.2.15    HTTP 485 GET /api/v1/alarms?active&_=1646057797133 HTTP/1.1
   25  89.884057    10.0.2.15 → 10.0.2.2     HTTP 593 HTTP/1.1 200 OK  (application/json)
   26  89.884278     10.0.2.2 → 10.0.2.15    TCP 60 49412 → 19999 [ACK] Seq=3449 Ack=4310 Win=65535 Len=0
   27  99.888692     10.0.2.2 → 10.0.2.15    HTTP 485 GET /api/v1/alarms?active&_=1646057797134 HTTP/1.1
   28  99.889756    10.0.2.15 → 10.0.2.2     HTTP 593 HTTP/1.1 200 OK  (application/json)
   29  99.889929     10.0.2.2 → 10.0.2.15    TCP 60 49412 → 19999 [ACK] Seq=3880 Ack=4849 Win=65535 Len=0
   30 109.894462     10.0.2.2 → 10.0.2.15    HTTP 485 GET /api/v1/alarms?active&_=1646057797135 HTTP/1.1
   31 109.894649    10.0.2.15 → 10.0.2.2     HTTP 593 HTTP/1.1 200 OK  (application/json)
   32 109.895078     10.0.2.2 → 10.0.2.15    TCP 60 49412 → 19999 [ACK] Seq=4311 Ack=5388 Win=65535 Len=0
   33 119.898604     10.0.2.2 → 10.0.2.15    HTTP 485 GET /api/v1/alarms?active&_=1646057797136 HTTP/1.1
   34 119.898757    10.0.2.15 → 10.0.2.2     HTTP 593 HTTP/1.1 200 OK  (application/json)
   35 119.898999     10.0.2.2 → 10.0.2.15    TCP 60 49412 → 19999 [ACK] Seq=4742 Ack=5927 Win=65535 Len=0
   36 129.903089     10.0.2.2 → 10.0.2.15    HTTP 485 GET /api/v1/alarms?active&_=1646057797137 HTTP/1.1
   37 129.903317    10.0.2.15 → 10.0.2.2     HTTP 593 HTTP/1.1 200 OK  (application/json)
   38 130.144204    10.0.2.15 → 10.0.2.2     TCP 593 [TCP Retransmission] 19999 → 49412 [PSH, ACK] Seq=5927 Ack=5173 Win=65535 Len=539
   39 130.144277     10.0.2.2 → 10.0.2.15    TCP 60 49412 → 19999 [ACK] Seq=5173 Ack=6466 Win=65535 Len=0
   40 130.144526     10.0.2.2 → 10.0.2.15    TCP 60 [TCP Dup ACK 39#1] 49412 → 19999 [ACK] Seq=5173 Ack=6466 Win=65535 Len=0
   41 139.906786     10.0.2.2 → 10.0.2.15    HTTP 485 GET /api/v1/alarms?active&_=1646057797138 HTTP/1.1
   42 139.907003    10.0.2.15 → 10.0.2.2     HTTP 593 HTTP/1.1 200 OK  (application/json)
   43 139.907220     10.0.2.2 → 10.0.2.15    TCP 60 49412 → 19999 [ACK] Seq=5604 Ack=7005 Win=65535 Len=0
   44 149.910148     10.0.2.2 → 10.0.2.15    HTTP 485 GET /api/v1/alarms?active&_=1646057797139 HTTP/1.1
   45 149.910311    10.0.2.15 → 10.0.2.2     HTTP 592 HTTP/1.1 200 OK  (application/json)
   46 149.910534     10.0.2.2 → 10.0.2.15    TCP 60 49412 → 19999 [ACK] Seq=6035 Ack=7543 Win=65535 Len=0
   47 162.409919     10.0.2.2 → 10.0.2.15    HTTP 485 GET /api/v1/alarms?active&_=1646057797140 HTTP/1.1
   48 162.410084    10.0.2.15 → 10.0.2.2     HTTP 592 HTTP/1.1 200 OK  (application/json)
   49 162.427968     10.0.2.2 → 10.0.2.15    TCP 60 49412 → 19999 [ACK] Seq=6466 Ack=8081 Win=65535 Len=0
   50 172.527530     10.0.2.2 → 10.0.2.15    HTTP 485 GET /api/v1/alarms?active&_=1646057797141 HTTP/1.1
   51 172.527949    10.0.2.15 → 10.0.2.2     HTTP 593 HTTP/1.1 200 OK  (application/json)
   52 172.528108     10.0.2.2 → 10.0.2.15    TCP 60 49412 → 19999 [ACK] Seq=6897 Ack=8620 Win=65535 Len=0
   53 184.693564     10.0.2.2 → 10.0.2.15    HTTP 485 GET /api/v1/alarms?active&_=1646057797142 HTTP/1.1
   54 184.693842    10.0.2.15 → 10.0.2.2     HTTP 592 HTTP/1.1 200 OK  (application/json)
   55 184.694251     10.0.2.2 → 10.0.2.15    TCP 60 49412 → 19999 [ACK] Seq=7328 Ack=9158 Win=65535 Len=0
   56 189.415732     10.0.2.2 → 10.0.2.15    HTTP 618 GET /api/v1/data?chart=system.swap&format=array&points=420&group=average&gtime=0&options=absolute%7Cpercentage%7Cjsonwrap%7Cnonzero&after=-420&dimensions=used&_=1646057797143 HTTP/1.1
   57 189.418846    10.0.2.15 → 10.0.2.2     HTTP 770 HTTP/1.1 200 OK  (application/json)
   58 189.422719     10.0.2.2 → 10.0.2.15    TCP 60 49412 → 19999 [ACK] Seq=7892 Ack=9874 Win=65535 Len=0
   59 189.427010     10.0.2.2 → 10.0.2.15    TCP 60 49606 → 19999 [SYN] Seq=0 Win=65535 Len=0 MSS=1460
   60 189.427042    10.0.2.15 → 10.0.2.2     TCP 58 19999 → 49606 [SYN, ACK] Seq=0 Ack=1 Win=65535 Len=0 MSS=1460
   61 189.428212     10.0.2.2 → 10.0.2.15    TCP 60 49606 → 19999 [ACK] Seq=1 Ack=1 Win=65535 Len=0
   62 189.429231     10.0.2.2 → 10.0.2.15    HTTP 644 GET /api/v1/data?chart=system.ram&format=array&points=420&group=average&gtime=0&options=absolute%7Cpercentage%7Cjsonwrap%7Cnonzero&after=-420&dimensions=used%7Cbuffers%7Cactive%7Cwired&_=1646057797149 HTTP/1.1
   63 189.429231     10.0.2.2 → 10.0.2.15    TCP 60 49607 → 19999 [SYN] Seq=0 Win=65535 Len=0 MSS=1460
   64 189.429258    10.0.2.15 → 10.0.2.2     TCP 58 19999 → 49607 [SYN, ACK] Seq=0 Ack=1 Win=65535 Len=0 MSS=1460
   65 189.429709     10.0.2.2 → 10.0.2.15    TCP 60 49607 → 19999 [ACK] Seq=1 Ack=1 Win=65535 Len=0
   66 189.430672    10.0.2.15 → 10.0.2.2     HTTP 1474 HTTP/1.1 200 OK  (application/json)
   67 189.431255     10.0.2.2 → 10.0.2.15    TCP 60 49608 → 19999 [SYN] Seq=0 Win=65535 Len=0 MSS=1460
   68 189.431255     10.0.2.2 → 10.0.2.15    TCP 60 49609 → 19999 [SYN] Seq=0 Win=65535 Len=0 MSS=1460
   69 189.431255     10.0.2.2 → 10.0.2.15    TCP 60 49412 → 19999 [ACK] Seq=8482 Ack=11294 Win=65535 Len=0
   70 189.431330    10.0.2.15 → 10.0.2.2     TCP 58 19999 → 49608 [SYN, ACK] Seq=0 Ack=1 Win=65535 Len=0 MSS=1460
   71 189.431454    10.0.2.15 → 10.0.2.2     TCP 58 19999 → 49609 [SYN, ACK] Seq=0 Ack=1 Win=65535 Len=0 MSS=1460
   72 189.431773     10.0.2.2 → 10.0.2.15    TCP 60 49610 → 19999 [SYN] Seq=0 Win=65535 Len=0 MSS=1460
   73 189.431773     10.0.2.2 → 10.0.2.15    TCP 60 49608 → 19999 [ACK] Seq=1 Ack=1 Win=65535 Len=0
   74 189.431785    10.0.2.15 → 10.0.2.2     TCP 58 19999 → 49610 [SYN, ACK] Seq=0 Ack=1 Win=65535 Len=0 MSS=1460
   75 189.432115     10.0.2.2 → 10.0.2.15    TCP 60 49609 → 19999 [ACK] Seq=1 Ack=1 Win=65535 Len=0
   76 189.432115     10.0.2.2 → 10.0.2.15    HTTP 601 GET /api/v1/data?chart=system.io&format=array&points=420&group=average&gtime=0&options=absolute%7Cjsonwrap%7Cnonzero&after=-420&dimensions=in&_=1646057797144 HTTP/1.1
   77 189.432115     10.0.2.2 → 10.0.2.15    TCP 60 49610 → 19999 [ACK] Seq=1 Ack=1 Win=65535 Len=0
   78 189.432140    10.0.2.15 → 10.0.2.2     TCP 54 19999 → 49606 [ACK] Seq=1 Ack=548 Win=65535 Len=0
   79 189.432658     10.0.2.2 → 10.0.2.15    HTTP 602 GET /api/v1/data?chart=system.io&format=array&points=420&group=average&gtime=0&options=absolute%7Cjsonwrap%7Cnonzero&after=-420&dimensions=out&_=1646057797145 HTTP/1.1
   80 189.432669    10.0.2.15 → 10.0.2.2     TCP 54 19999 → 49607 [ACK] Seq=1 Ack=549 Win=65535 Len=0
   81 189.433453    10.0.2.15 → 10.0.2.2     HTTP 759 HTTP/1.1 200 OK  (application/json)
   82 189.433601     10.0.2.2 → 10.0.2.15    TCP 60 49606 → 19999 [ACK] Seq=548 Ack=706 Win=65535 Len=0
   83 189.434012    10.0.2.15 → 10.0.2.2     TCP 1514 HTTP/1.1 200 OK  [TCP segment of a reassembled PDU]
   84 189.434070    10.0.2.15 → 10.0.2.2     HTTP 300 HTTP/1.1 200 OK  (application/json)
   85 189.434830     10.0.2.2 → 10.0.2.15    HTTP 588 GET /api/v1/data?chart=system.cpu&format=array&points=420&group=average&gtime=0&options=absolute%7Cjsonwrap%7Cnonzero&after=-420&_=1646057797146 HTTP/1.1
   86 189.434831     10.0.2.2 → 10.0.2.15    TCP 60 49607 → 19999 [ACK] Seq=549 Ack=1461 Win=65535 Len=0
   87 189.434831     10.0.2.2 → 10.0.2.15    TCP 60 49607 → 19999 [ACK] Seq=549 Ack=1707 Win=65535 Len=0
   88 189.434870    10.0.2.15 → 10.0.2.2     TCP 54 19999 → 49608 [ACK] Seq=1 Ack=535 Win=65535 Len=0
   89 189.435316     10.0.2.2 → 10.0.2.15    HTTP 604 GET /api/v1/data?chart=system.net&format=array&points=420&group=average&gtime=0&options=absolute%7Cjsonwrap%7Cnonzero&after=-420&dimensions=sent&_=1646057797148 HTTP/1.1
   90 189.435331    10.0.2.15 → 10.0.2.2     TCP 54 19999 → 49609 [ACK] Seq=1 Ack=551 Win=65535 Len=0
   91 189.436721     10.0.2.2 → 10.0.2.15    HTTP 608 GET /api/v1/data?chart=system.net&format=array&points=420&group=average&gtime=0&options=absolute%7Cjsonwrap%7Cnonzero&after=-420&dimensions=received&_=1646057797147 HTTP/1.1
   92 189.436743    10.0.2.15 → 10.0.2.2     TCP 54 19999 → 49610 [ACK] Seq=1 Ack=555 Win=65535 Len=0
   93 189.437988     10.0.2.2 → 10.0.2.15    HTTP 606 GET /api/v1/data?chart=system.cpu&format=json&points=144&group=average&gtime=0&options=ms%7Cflip%7Cjsonwrap%7Cnonzero&after=-120&dimensions=iowait&_=1646057797150 HTTP/1.1
   94 189.438803    10.0.2.15 → 10.0.2.2     HTTP 1080 HTTP/1.1 200 OK  (application/json)
   95 189.439093     10.0.2.2 → 10.0.2.15    HTTP 588 GET /api/v1/data?chart=system.cpu&format=json&points=356&group=average&gtime=0&options=ms%7Cflip%7Cjsonwrap%7Cnonzero&after=-420&_=1646057797152 HTTP/1.1
   96 189.439102    10.0.2.15 → 10.0.2.2     TCP 54 19999 → 49607 [ACK] Seq=1707 Ack=1083 Win=65535 Len=0
   97 189.439306     10.0.2.2 → 10.0.2.15    HTTP 607 GET /api/v1/data?chart=system.cpu&format=json&points=144&group=average&gtime=0&options=ms%7Cflip%7Cjsonwrap%7Cnonzero&after=-120&dimensions=softirq&_=1646057797151 HTTP/1.1
   98 189.439306     10.0.2.2 → 10.0.2.15    TCP 60 49412 → 19999 [ACK] Seq=9034 Ack=12320 Win=65535 Len=0
   99 189.439315    10.0.2.15 → 10.0.2.2     TCP 54 19999 → 49606 [ACK] Seq=706 Ack=1101 Win=65535 Len=0
  100 189.439653    10.0.2.15 → 10.0.2.2     HTTP 1492 HTTP/1.1 200 OK  (application/json)
````

*В качестве решения приложите: скриншоты, выполняемые команды, комментарии (по необходимости).*

 ---

## Задание для самостоятельной отработки* (необязательно к выполнению)

8. Просканируйте хост scanme.nmap.org. Какие сервисы запущены?

9. Установите и настройте фаервол ufw на web-сервер из задания 3. Откройте доступ снаружи только к портам 22,80,443

----

### Правила приема домашнего задания

В личном кабинете отправлена ссылка на .md файл в вашем репозитории.

-----

### Критерии оценки

Зачет - выполнены все задания, ответы даны в развернутой форме, приложены соответствующие скриншоты и файлы проекта, в выполненных заданиях нет противоречий и нарушения логики.

На доработку - задание выполнено частично или не выполнено, в логике выполнения заданий есть противоречия, существенные недостатки.

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.
Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.
