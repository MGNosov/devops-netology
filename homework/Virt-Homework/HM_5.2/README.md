
# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами" Носов М.Г.

## Как сдавать задания

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.

Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Любые вопросы по решению задач задавайте в чате учебной группы.

---

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
- Какой из принципов IaaC является основополагающим?

##Ответ
Паттерны IaaC можно сравнить c хорошо налаженным производственным процессом. Как и на производстве основным преимуществом ялвяется автоматизация повторяющихся (рутинных) задач. За счёт автоматизации сокращаются затраты, поскольку получается предсказуемый результат, а если деффекты и возникают, то выявляются быстрее, поскольку процесс тестирования так же автоматизирован. 
Основополагающим принципом является индемпотентность, т.е. получение результата идентичного предыдущему и всем последующим.


## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

##Ответ
- В отличаи от других систем управления конфигурациями Ansible использует существующую SSH инфраструктуру. Для других требуется установка специального PKI-окружения.
- Наиболее надёжный метод Pull, поскольку в позволяет лучше контролировать результат. В частности, если в управлении большое количество серверов, есть вероятность того, что единовременный push запрос ипользует все ресурсы управляющего сервера. 
## Задача 3

Установить на личный компьютер:

- VirtualBox
````
mgnosov@Maksims-MacBook-Pro homework % VBoxManage --version
6.1.34r150636
mgnosov@Maksims-MacBook-Pro homework % 
````
- Vagrant
````
mgnosov@Maksims-MacBook-Pro homework % vagrant --version
Vagrant 2.2.19
mgnosov@Maksims-MacBook-Pro homework % 
````
- Ansible
````
mgnosov@Maksims-MacBook-Pro ~ %  ansible --version
ansible [core 2.12.5]
  config file = None
  configured module search path = ['/Users/mgnosov/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /Library/Python/3.8/site-packages/ansible
  ansible collection location = /Users/mgnosov/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/local/bin/ansible
  python version = 3.8.9 (default, Oct 26 2021, 07:25:54) [Clang 13.0.0 (clang-1300.0.29.30)]
  jinja version = 3.1.2
  libyaml = True
mgnosov@Maksims-MacBook-Pro ~ % 

````
*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```
mgnosov@Maksims-MacBook-Pro ~ % vagrant destroy
    stdsrv1.mgnosov: Are you sure you want to destroy the 'stdsrv1.mgnosov' VM? [y/N] y
==> stdsrv1.mgnosov: Forcing shutdown of VM...
==> stdsrv1.mgnosov: Destroying VM and associated drives...
mgnosov@Maksims-MacBook-Pro ~ % vagrant up     
Bringing machine 'stdsrv1.mgnosov' up with 'virtualbox' provider...
==> stdsrv1.mgnosov: Importing base box 'bento/ubuntu-20.04'...
==> stdsrv1.mgnosov: Matching MAC address for NAT networking...
==> stdsrv1.mgnosov: Checking if box 'bento/ubuntu-20.04' version '202112.19.0' is up to date...
==> stdsrv1.mgnosov: Setting the name of the VM: mgnosov_stdsrv1mgnosov_1652443097840_48841
==> stdsrv1.mgnosov: Clearing any previously set network interfaces...
==> stdsrv1.mgnosov: Preparing network interfaces based on configuration...
    stdsrv1.mgnosov: Adapter 1: nat
    stdsrv1.mgnosov: Adapter 2: hostonly
==> stdsrv1.mgnosov: Forwarding ports...
    stdsrv1.mgnosov: 22 (guest) => 20011 (host) (adapter 1)
    stdsrv1.mgnosov: 22 (guest) => 2222 (host) (adapter 1)
==> stdsrv1.mgnosov: Running 'pre-boot' VM customizations...
==> stdsrv1.mgnosov: Booting VM...
==> stdsrv1.mgnosov: Waiting for machine to boot. This may take a few minutes...
    stdsrv1.mgnosov: SSH address: 127.0.0.1:2222
    stdsrv1.mgnosov: SSH username: vagrant
    stdsrv1.mgnosov: SSH auth method: private key
    stdsrv1.mgnosov: Warning: Connection reset. Retrying...
    stdsrv1.mgnosov: Warning: Remote connection disconnect. Retrying...
    stdsrv1.mgnosov: 
    stdsrv1.mgnosov: Vagrant insecure key detected. Vagrant will automatically replace
    stdsrv1.mgnosov: this with a newly generated keypair for better security.
    stdsrv1.mgnosov: 
    stdsrv1.mgnosov: Inserting generated public key within guest...
    stdsrv1.mgnosov: Removing insecure key from the guest if it's present...
    stdsrv1.mgnosov: Key inserted! Disconnecting and reconnecting using new SSH key...
==> stdsrv1.mgnosov: Machine booted and ready!
==> stdsrv1.mgnosov: Checking for guest additions in VM...
==> stdsrv1.mgnosov: Setting hostname...
==> stdsrv1.mgnosov: Configuring and enabling network interfaces...
==> stdsrv1.mgnosov: Mounting shared folders...
    stdsrv1.mgnosov: /vagrant => /Users/mgnosov
==> stdsrv1.mgnosov: Running provisioner: ansible...
    stdsrv1.mgnosov: Running ansible-playbook...

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [stdsrv1.mgnosov]

TASK [Create directory for ssh-keys] *******************************************
ok: [stdsrv1.mgnosov]

TASK [Check DNS] ***************************************************************
changed: [stdsrv1.mgnosov]

TASK [Installing tools] ********************************************************
ok: [stdsrv1.mgnosov] => (item=git)
ok: [stdsrv1.mgnosov] => (item=curl)

TASK [Installing docker] *******************************************************
changed: [stdsrv1.mgnosov]

TASK [Add current user to docker group] ****************************************
changed: [stdsrv1.mgnosov]

PLAY RECAP *********************************************************************
stdsrv1.mgnosov            : ok=6    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

==> stdsrv1.mgnosov: Running provisioner: ansible...
    stdsrv1.mgnosov: Running ansible-playbook...

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [stdsrv1.mgnosov]

TASK [Create directory for ssh-keys] *******************************************
ok: [stdsrv1.mgnosov]

TASK [Check DNS] ***************************************************************
changed: [stdsrv1.mgnosov]

TASK [Installing tools] ********************************************************
ok: [stdsrv1.mgnosov] => (item=git)
ok: [stdsrv1.mgnosov] => (item=curl)

TASK [Installing docker] *******************************************************
changed: [stdsrv1.mgnosov]

TASK [Add current user to docker group] ****************************************
ok: [stdsrv1.mgnosov]

PLAY RECAP *********************************************************************
stdsrv1.mgnosov            : ok=6    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

==> stdsrv1.mgnosov: Running provisioner: ansible...
    stdsrv1.mgnosov: Running ansible-playbook...

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [stdsrv1.mgnosov]

TASK [Create directory for ssh-keys] *******************************************
ok: [stdsrv1.mgnosov]

TASK [Check DNS] ***************************************************************
changed: [stdsrv1.mgnosov]

TASK [Installing tools] ********************************************************
ok: [stdsrv1.mgnosov] => (item=git)
ok: [stdsrv1.mgnosov] => (item=curl)

TASK [Installing docker] *******************************************************
changed: [stdsrv1.mgnosov]

TASK [Add current user to docker group] ****************************************
ok: [stdsrv1.mgnosov]

PLAY RECAP *********************************************************************
stdsrv1.mgnosov            : ok=6    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

==> stdsrv1.mgnosov: Running provisioner: ansible...
    stdsrv1.mgnosov: Running ansible-playbook...

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [stdsrv1.mgnosov]

TASK [Create directory for ssh-keys] *******************************************
ok: [stdsrv1.mgnosov]

TASK [Check DNS] ***************************************************************
changed: [stdsrv1.mgnosov]

TASK [Installing tools] ********************************************************
ok: [stdsrv1.mgnosov] => (item=git)
ok: [stdsrv1.mgnosov] => (item=curl)

TASK [Installing docker] *******************************************************
changed: [stdsrv1.mgnosov]

TASK [Add current user to docker group] ****************************************
ok: [stdsrv1.mgnosov]

PLAY RECAP *********************************************************************
stdsrv1.mgnosov            : ok=6    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

mgnosov@Maksims-MacBook-Pro ~ % vagrant ssh
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Fri 13 May 2022 12:03:30 PM UTC

  System load:  0.47               Users logged in:          0
  Usage of /:   13.6% of 30.88GB   IPv4 address for docker0: 172.17.0.1
  Memory usage: 25%                IPv4 address for eth0:    10.0.2.15
  Swap usage:   0%                 IPv4 address for eth1:    192.168.56.2
  Processes:    119


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Fri May 13 12:03:08 2022 from 10.0.2.2
vagrant@stdsrv1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
vagrant@stdsrv1:~$ 

```