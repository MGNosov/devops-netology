# Домашнее задание к занятию "3.3. Операционные системы. Лекция 1" Максим Носов

### Цель задания

В результате выполнения этого задания вы:

1. Познакомитесь с инструментом strace, который помогает отслеживать системные вызовы процессов, и является необходимым для отладки и расследований в случае возникновения ошибок в работе программ.
2. Рассмотрите различные режимы работы скриптов, настраиваемые командой set. Один и тот же код в скриптах в разных режимах работы ведет себя по-разному.

### Чеклист готовности к домашнему заданию

1. Убедитесь, что у вас установлен инструмент `strace`, выполнив команду `strace -V` для проверки версии. В Ubuntu 20.04 strace установлен, но в других дистрибутивах его может не быть "из коробки". Обратитесь к документации дистрибутива, как установить инструмент strace.

###### Результат
```` bash
vagrant@vagrant:~$ strace -V
strace -- version 5.5
Copyright (c) 1991-2020 The strace developers <https://strace.io>.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Optional features enabled: stack-trace=libunwind stack-demangle m32-mpers mx32-mpers
````
2. Убедитесь, что у вас установлен пакет `bpfcc-tools`, [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md)

###### Результат
```` bash
vagrant@vagrant:~$ sudo apt-get install bpfcc-tools linux-headers-$(uname -r)
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  ieee-data libbpfcc linux-headers-5.4.0-110 python3-bpfcc python3-netaddr
Suggested packages:
  ipython3 python-netaddr-docs
The following NEW packages will be installed:
  bpfcc-tools ieee-data libbpfcc linux-headers-5.4.0-110
  linux-headers-5.4.0-110-generic python3-bpfcc python3-netaddr
0 upgraded, 7 newly installed, 0 to remove and 0 not upgraded.
Need to get 29.8 MB of archives.
After this operation, 161 MB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://in.archive.ubuntu.com/ubuntu focal/universe amd64 libbpfcc amd64 0.12.0-2 [14.9 MB]
Get:2 http://in.archive.ubuntu.com/ubuntu focal/universe amd64 python3-bpfcc all 0.12.0-2 [31.3 kB]
Get:3 http://in.archive.ubuntu.com/ubuntu focal/main amd64 ieee-data all 20180805.1 [1589 kB]
Get:4 http://in.archive.ubuntu.com/ubuntu focal-updates/main amd64 python3-netaddr all 0.7.19-3ubuntu1 [236 kB]
Get:5 http://in.archive.ubuntu.com/ubuntu focal/universe amd64 bpfcc-tools all 0.12.0-2 [579 kB]
Get:6 http://in.archive.ubuntu.com/ubuntu focal-updates/main amd64 linux-headers-5.4.0-110 all 5.4.0-110.124 [11.0 MB]
Get:7 http://in.archive.ubuntu.com/ubuntu focal-updates/main amd64 linux-headers-5.4.0-110-generic amd64 5.4.0-110.124 [1395 kB]
Fetched 29.8 MB in 10s (3115 kB/s)                                                    
Selecting previously unselected package libbpfcc.
(Reading database ... 41035 files and directories currently installed.)
Preparing to unpack .../0-libbpfcc_0.12.0-2_amd64.deb ...
Unpacking libbpfcc (0.12.0-2) ...
Selecting previously unselected package python3-bpfcc.
Preparing to unpack .../1-python3-bpfcc_0.12.0-2_all.deb ...
Unpacking python3-bpfcc (0.12.0-2) ...
Selecting previously unselected package ieee-data.
Preparing to unpack .../2-ieee-data_20180805.1_all.deb ...
Unpacking ieee-data (20180805.1) ...
Selecting previously unselected package python3-netaddr.
Preparing to unpack .../3-python3-netaddr_0.7.19-3ubuntu1_all.deb ...
Unpacking python3-netaddr (0.7.19-3ubuntu1) ...
Selecting previously unselected package bpfcc-tools.
Preparing to unpack .../4-bpfcc-tools_0.12.0-2_all.deb ...
Unpacking bpfcc-tools (0.12.0-2) ...
Selecting previously unselected package linux-headers-5.4.0-110.
Preparing to unpack .../5-linux-headers-5.4.0-110_5.4.0-110.124_all.deb ...
Unpacking linux-headers-5.4.0-110 (5.4.0-110.124) ...
Selecting previously unselected package linux-headers-5.4.0-110-generic.
Preparing to unpack .../6-linux-headers-5.4.0-110-generic_5.4.0-110.124_amd64.deb ...
Unpacking linux-headers-5.4.0-110-generic (5.4.0-110.124) ...
Setting up linux-headers-5.4.0-110 (5.4.0-110.124) ...
Setting up ieee-data (20180805.1) ...
Setting up libbpfcc (0.12.0-2) ...
Setting up python3-bpfcc (0.12.0-2) ...
Setting up linux-headers-5.4.0-110-generic (5.4.0-110.124) ...
Setting up python3-netaddr (0.7.19-3ubuntu1) ...
Setting up bpfcc-tools (0.12.0-2) ...
Processing triggers for man-db (2.9.1-1) ...
Processing triggers for libc-bin (2.31-0ubuntu9.9) ...
````

### Инструменты/ дополнительные материалы, которые пригодятся для выполнения задания

1. Изучите документацию lsof - `man lsof` или та же информация, но в [сети](https://linux.die.net/man/8/lsof)
2. Документация по режимам работы bash находится в `help set` или в [сети](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)

------

## Задание

1. Какой системный вызов делает команда `cd`?

    В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте.

    Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание, что `strace` выдаёт результат своей работы в поток stderr, а не в stdout.

###### Результат
```` bash
strace /bin/bash -c ‘cd /tmp’ 2>out_put.txt
    grep --color -i -n “/tmp” out_put.txt
    1:execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp"], 0x7ffd2518a420 /* 19 vars */) = 0
    108:stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=4096, ...}) = 0
    109:chdir("/tmp")
````
По контексту предположу, что это `chdir`.

2. Попробуйте использовать команду `file` на объекты разных типов в файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
    Используя `strace` выясните, где находится база данных `file`, на основании которой она делает свои догадки.

###### Результат
```` bash
strace file /dev/tty 2>output_file1.txt
grep –-color -i -n “file” output_file1.txt
x
strace file /dev/sda 2>output_file2.txt
grep –-color -i -n “file” output_file2.txt

strace file /bin/bash 2>output_file3.txt
grep –-color -i -n “file” output_file3.txt
````
###### Пример вывода команды
```` bash
grep --color -i -n “file” output_file1.txt :
1:execve("/usr/bin/file", ["file", "/dev/tty"], 0x7ffe3c4ac198 /* 24 vars */) = 0
4:access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
109:stat("/home/vagrant/.magic.mgc", 0x7ffdbe6e9db0) = -1 ENOENT (No such file or directory)
110:stat("/home/vagrant/.magic", 0x7ffdbe6e9db0) = -1 ENOENT (No such file or directory)
111:openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
115:read(3, "# Magic local data for file(1) c"..., 4096) = 111
````
###### Выдержка из `man file`
```` bash
FILES
     /usr/share/misc/magic.mgc  Default compiled list of magic.
     /usr/share/misc/magic      Directory containing default magic files.
````
3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

###### Результат
```` bash
ping localhost > log.txt
lsof -p 1622
rm log.txt
lsof -p 1622
ping    1622 root    1w   REG  253,0    22306 1054816 /home/vagrant/log.txt (deleted)
ll /proc/1622/fd
dr-x------ 2 root root  0 Feb  4 10:07 ./
dr-xr-xr-x 9 root root  0 Feb  4 10:06 ../
lrwx------ 1 root root 64 Feb  4 10:07 0 -> /dev/pts/0
l-wx------ 1 root root 64 Feb  4 10:07 1 -> '/home/vagrant/log.txt (deleted)'
lrwx------ 1 root root 64 Feb  4 10:07 2 -> /dev/pts/0
lrwx------ 1 root root 64 Feb  4 10:07 3 -> 'socket:[34842]'
lrwx------ 1 root root 64 Feb  4 10:07 4 -> 'socket:[34843]'
truncate -s 0 /proc/1622/fd/1
````

4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

###### Результат
В отличие от процессов-сирот сирот зомби-процессы не потребляют ресурсов сервера, они лишь занимают место в таблице процессов.

5. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
    На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).

###### Результат
```` bash
sudo su
    apt-get install bpfcc-tools linux-header-$ (uname -r)
    dpkg -L bpfcc-tools | grep sbin/opensnoop
    opensnoop-bpfcc -d 1
PID    COMM               FD ERR PATH
1274   vminfo              4   0 /var/run/utmp
667    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
667    dbus-daemon        19   0 /usr/share/dbus-1/system-services
667    dbus-daemon        -1   2 /lib/dbus-1/system-services
667    dbus-daemon        19   0 /var/lib/snapd/dbus-1/system-services/
root@vagrant:/home/vagrant#
````

6. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.

###### Ответ
`uname -a` - использует системный вызов uname()
`uname(2) manual page`
```` bash
Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.
````

7. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
    Есть ли смысл использовать в bash `&&`, если применить `set -e`?

###### Ответ
``&&`` - логический оператор
``;`` - простая последовательность
Иными словами при `test -d /tmp/some_dir; echo Hi` процесс `echo Hi` выполнится в любом случае. В конструкции `test -d /tmp/some_dir && echo Hi` процесс `echo Hi` будет запущен только после получения успешного кода возврата от `test -d /tmp/some_dir`.


8. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?

###### Ответ
`e` – указывает оболочке выйти, если команда дает ненулевой статус выхода. Проще говоря, оболочка завершает работу при сбое команды.
`u` – обрабатывает неустановленные или неопределенные переменные, за исключением специальных параметров, таких как подстановочные знаки ``*`` или ``@``, как ошибки во время раскрытия параметра.
`x` – печатает аргументы команды во время выполнения.
`o pipefail` - это значение последней (самой правой) команды для выхода с ненулевым статусом или ноль, если все команды в сценарии завершаются успешно.

9. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).

###### Ответ
Для данного задания использовал немного изменённую конструкцию команды ps -eo stat. Наиболее часто встречающиеся `I`, `I<`, `S`, `Ss`, `Ssl`, `S+`, `S<`, `SN`)
	`I` - бездействующий поток ядра;
	`I<` - высокоприоритетный бездействующий поток ядра;
	`S` - прерываемый сон;
	`Ss` - прерываемый сон, но данный процесс главный в сессии;
	`Ssl` - прерываемый сон, главный в сессии процесс, мультипотоковый;
	`S+` - прерываемый сон, находится в группе процессов переднего плана;
	`S<` - прерываемый сон, высокоприоритетный;
	`SN` - прерываемый сон, низкоприоритетный процесс.

----

### Правила приема домашнего задания

В личном кабинете отправлена ссылка на .md файл в вашем репозитории.


### Критерии оценки

Зачет - выполнены все задания, ответы даны в развернутой форме, приложены соответствующие скриншоты и файлы проекта, в выполненных заданиях нет противоречий и нарушения логики.

На доработку - задание выполнено частично или не выполнено, в логике выполнения заданий есть противоречия, существенные недостатки.
