# Домашнее задание к занятию "3.2. Работа в терминале, лекция 2"

1. Какого типа команда `cd`? Попробуйте объяснить, почему она именно такого типа; опишите ход своих мыслей, если считаете что она могла бы быть другого типа.
1. Какая альтернатива без pipe команде `grep <some_string> <some_file> | wc -l`? `man grep` поможет в ответе на этот вопрос. Ознакомьтесь с [документом](http://www.smallo.ruhr.de/award.html) о других подобных некорректных вариантах использования pipe.
1. Какой процесс с PID `1` является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?
1. Как будет выглядеть команда, которая перенаправит вывод stderr `ls` на другую сессию терминала?
1. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.
1. Получится ли находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?
1. Выполните команду `bash 5>&1`. К чему она приведет? Что будет, если вы выполните `echo netology > /proc/$$/fd/5`? Почему так происходит?
1. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty? Напоминаем: по умолчанию через pipe передается только stdout команды слева от `|` на stdin команды справа.
Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.
1. Что выведет команда `cat /proc/$$/environ`? Как еще можно получить аналогичный по содержанию вывод?
1. Используя `man`, опишите что доступно по адресам `/proc/<PID>/cmdline`, `/proc/<PID>/exe`.
1. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью `/proc/cpuinfo`.
1. При открытии нового окна терминала и `vagrant ssh` создается новая сессия и выделяется pty. Это можно подтвердить командой `tty`, которая упоминалась в лекции 3.2. Однако:

    ```bash
	vagrant@netology1:~$ ssh localhost 'tty'
	not a tty
    ```

	Почитайте, почему так происходит, и как изменить поведение.
1. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись `reptyr`. Например, так можно перенести в `screen` процесс, который вы запустили по ошибке в обычной SSH-сессии.
1. `sudo echo string > /root/new_file` не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без `sudo` под вашим пользователем. Для решения данной проблемы можно использовать конструкцию `echo string | sudo tee /root/new_file`. Узнайте что делает команда `tee` и почему в отличие от `sudo echo` команда с `sudo tee` будет работать.


## Результат

1. cd - встроенная в shell функция. Если cd изменяет текущий рабочий каталог, а текущий рабочий каталог — это свойство, уникальное для каждого процесса, если бы cd был программой, она бы работала так:
- cd foo; 
- процесс cd начинается;
- процесс cd изменяет каталог для процесса cd;
- процесс cd завершается;
- shell по-прежнему имеет то же состояние, включая текущий рабочий каталог, что и до запуска.

2. 
````
touch file2.txt
  nano file2.txt
	Non_search_line
	Search_line
	Simple_line
grep -c Search_line test_file.txt
````
3. 
````
vagrant@vagrant:~$ pstree -n -p
systemd(1)─┬─systemd-journal(353)
           ├─systemd-udevd(384)
           ├─multipathd(525)─┬─{multipathd}(526)
           │                 ├─{multipathd}(527)
           │                 ├─{multipathd}(528)
           │                 ├─{multipathd}(529)
           │                 ├─{multipathd}(530)
           │                 └─{multipathd}(531)
           ├─systemd-network(611)
           ├─systemd-resolve(613)
           ├─accounts-daemon(626)─┬─{accounts-daemon}(632)
           │                      └─{accounts-daemon}(674)
           ├─dbus-daemon(627)
           ├─irqbalance(635)───{irqbalance}(642)
           ├─networkd-dispat(636)
           ├─rsyslogd(638)─┬─{rsyslogd}(652)
           │               ├─{rsyslogd}(653)
           │               └─{rsyslogd}(658)
           ├─snapd(640)─┬─{snapd}(786)
           │            ├─{snapd}(787)
           │            ├─{snapd}(788)
           │            ├─{snapd}(789)
           │            ├─{snapd}(795)
           │            ├─{snapd}(862)
           │            ├─{snapd}(863)
           │            ├─{snapd}(864)
           │            ├─{snapd}(865)
           │            └─{snapd}(919)
           ├─systemd-logind(643)
           ├─udisksd(644)─┬─{udisksd}(664)
           │              ├─{udisksd}(676)
           │              ├─{udisksd}(704)
           │              └─{udisksd}(718)
           ├─cron(659)
           ├─atd(661)
           ├─agetty(673)
           ├─sshd(687)───sshd(1238)───sshd(1285)───bash(1286)───pstree(1525)
           ├─polkitd(695)─┬─{polkitd}(697)
           │              └─{polkitd}(699)
           ├─VBoxService(884)─┬─{VBoxService}(886)
           │                  ├─{VBoxService}(887)
           │                  ├─{VBoxService}(888)
           │                  ├─{VBoxService}(889)
           │                  ├─{VBoxService}(890)
           │                  ├─{VBoxService}(891)
           │                  ├─{VBoxService}(892)
           │                  └─{VBoxService}(893)
           └─systemd(1251)───(sd-pam)(1252)
````
Ответ: systemd(1)

4. 
````
ls 2>&1 | tee /dev/pts/1
````
Вывод из другой сессии:
````
root@vagrant:/home/vagrant# tty
/dev/pts/1
root@vagrant:/home/vagrant# total 8
-rw-rw-r-- 1 vagrant vagrant  0 Jan 24 15:47 file1
-rw-r--r-- 1 root    root    58 Jan 26 09:58 file2.txt
-rw-r--r-- 1 root    root    23 Jan 26 13:07 stderr
````

5. 
````
touch test_file_1.txt
  ls
      test_file_1.txt  stderr
 
  nano test_file_1.txt
	New_string
	New_String
	One_more_new_string
	Last_new_string
  cat test_file_2.txt
  cat: test_file_2.txt: No such file or directory
  cat < test_file_1.txt > test_file_2.txt
  cat test_file_2.txt
	New_string
	New_String
	One_more_new_string
	Last_new_string
````
6. 
````
echo Test_Redirection > /dev/ttys001
```` 
Команда проходит без ошибок, но наблюдать результат в ttys001 не могу, поскольку вызов идёт из вирутальной машины.
<img align="cetner" src="/users/mgnosov/devops-netology/homework/Sysadmin-Homework/HM_3.2./img/img00.png">
7. 
````
bash 5>&1
````
команда создаст файловый дескриптор 5 перенаправив его в  stdout 
````
echo netology > /proc/$$/fd/5 
  netolgy
````
8. 
````
ls -l /root 5>&2 2>&1 1>&5 |grep denied -c 
   total 8
   -rw-r--r-- 1 root root    7 Jan 27 15:31 new_file
   drwxr-xr-x 3 root root 4096 Dec 19 19:42 snap
   0
````
9. Выводит переменные окружения.
````
cat /proc/$$/environ
````
Альтернативная команда.
````
printenv
````
10. Этот доступный только для чтения файл содержит полную командную строку для процесса, если этот процесс не является зомби (строка 293).
````
/proc/$$/cmdline
````
Этот файл представляет собой символьную ссылку, содержащую фактический путь к выполняемой команде. Эта символьная ссылка может быть назва обычным образом; попытка открыть его откроет исполняемый файл.
````
/proc/$$/exe
````
11. Подозреваю, что ответ SSE 4.2.
````
grep sse /proc/cpuingfo
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcidsse4_1 sse4_2 x2apic movbe popcnt aes xsave avx rdrand hypervisor lahf_lm abm invpcid_single pti fsgsbase avx2 invpcid md_clear flush_l1d
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcidsse4_1 sse4_2 x2apic movbe popcnt aes xsave avx rdrand hypervisor lahf_lm abm invpcid_single pti fsgsbase avx2 invpcid md_clear flush_l1d
````
12. При вводе команды ssh localhost ‘tty’ запрашивается пароль.
````
ssh localhost 'tty'
vagrant@localhost's password: 
````
Выполнение sudo su перед ssh localhost ‘tty’ также выводит в итоге к запросу ввода пароля.
````
sudo su
ssh localhost ‘tty’
root@localhost's password: 
````
Подозреваю, что это связано с работой самого ssh, нет ключей доступа. Пробовал сделать принудительный запуск сессии через ssh -t localhost ‘tty’ результат тот же.
13. 
````
sudo su
     apt-get install -y retyr
     screen
     ps -a 
   PID TTY          TIME CMD
   1322 pts/0    00:00:00 screen
   1383 pts/2    00:00:00 ps
   reptyr 1322
     Unable to attach to pid 1322: Operation not permitted
     The kernel denied permission while attaching. If your uid matches
     the target's, check the value of /proc/sys/kernel/yama/ptrace_scope.
     For more information, see /etc/sysctl.d/10-ptrace.conf

   sudo nano /etc/sysctl.d/10-ptrace.conf
    kernel.yama.ptrace_scope = 0
     ^O ^X
   vagrant halt
   vagrant up
   vagrant ssh
   screen
   ps -a
    PID TTY          TIME CMD
   1283 pts/0    00:00:00 screen
   1366 pts/2    00:00:00 ps
   sudo su
   reptyr -T 1283
   ps -a
     PID TTY          TIME CMD
   1283 pts/0    00:00:00 screen
   1367 pts/2    00:00:00 sudo
   1370 pts/2    00:00:00 su
   1371 pts/2    00:00:00 bash
   1378 pts/2    00:00:00 reptyr
   1379 pts/1    00:00:00 ps
````
14.  tee - читает из стандартного ввода и записывает в стандартный вывод или файл. sudo echo не будет работать, перенаправление обрабатывается еще до того, как оболочка выполнит sudo, и поэтому выполняется с разрешениями пользователя, под которым происходит работа. Поскольку у пользователя нет прав на перенаправление вывода в файл в указанной директории, вы получаем ошибку Permission denied.


---


## Как сдавать задания

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.

Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Также вы можете выполнить задание в [Google Docs](https://docs.google.com/document/u/0/?tgif=d) и отправить в личном кабинете на проверку ссылку на ваш документ.
Название файла Google Docs должно содержать номер лекции и фамилию студента. Пример названия: "1.1. Введение в DevOps — Сусанна Алиева".

Если необходимо прикрепить дополнительные ссылки, просто добавьте их в свой Google Docs.

Перед тем как выслать ссылку, убедитесь, что ее содержимое не является приватным (открыто на комментирование всем, у кого есть ссылка), иначе преподаватель не сможет проверить работу. Чтобы это проверить, откройте ссылку в браузере в режиме инкогнито.

[Как предоставить доступ к файлам и папкам на Google Диске](https://support.google.com/docs/answer/2494822?hl=ru&co=GENIE.Platform%3DDesktop)

[Как запустить chrome в режиме инкогнито ](https://support.google.com/chrome/answer/95464?co=GENIE.Platform%3DDesktop&hl=ru)

[Как запустить  Safari в режиме инкогнито ](https://support.apple.com/ru-ru/guide/safari/ibrw1069/mac)

Любые вопросы по решению задач задавайте в чате учебной группы.

---