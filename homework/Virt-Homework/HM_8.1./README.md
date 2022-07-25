# Домашнее задание к занятию "08.01 Введение в Ansible" Носов Максим

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

###### Результат
1. ``ansible [core 2.12.6]``
2. ``https://github.com/MGNosov/devops-netology/tree/main/homework/Virt-Homework/HM_8.1.``

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.
##### Результат
````
mgnosov@Maksims-MacBook-Pro playbook % ansible-playbook -i inventory/test.yml site.yml

PLAY [Print os facts] **********************************************************

TASK [Gathering Facts] *********************************************************
[WARNING]: Platform darwin on host localhost is using the discovered Python
interpreter at /usr/bin/python3, but future installation of another Python
interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible-
core/2.12/reference_appendices/interpreter_discovery.html for more information.
ok: [localhost]

TASK [Print OS] ****************************************************************
ok: [localhost] => {
    "msg": "MacOSX"
}

TASK [Print fact] **************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
````
Значение ``some_facts`` -- 12.
2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.
##### Резульат
````
mgnosov@Maksims-MacBook-Pro playbook % ansible-playbook -i inventory/test.yml site.yml

PLAY [Print os facts] **********************************************************

TASK [Gathering Facts] *********************************************************
[WARNING]: Platform darwin on host localhost is using the discovered Python
interpreter at /usr/bin/python3, but future installation of another Python
interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible-
core/2.12/reference_appendices/interpreter_discovery.html for more information.
ok: [localhost]

TASK [Print OS] ****************************************************************
ok: [localhost] => {
    "msg": "MacOSX"
}

TASK [Print fact] **************************************************************
ok: [localhost] => {
    "msg": "all default facts"
}

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
````
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
````
'docker-compose.yml'
version: "2.6"
services:
  centos7:
    image: centos:7
    container_name: centos7
    restart: on-failure
    command: ["sleep", "infinite"]
  ubuntu:
    image: ubuntu:20.04
    container_name: ubuntu
    restart: on-failure
    command: ["sleep", "infinite"]
````
````
mgnosov@Maksims-MacBook-Pro playbook % docker-compose up -d
[+] Running 2/2
 ⠿ Container ubuntu   Started                                              1.1s
 ⠿ Container centos7  Started                                              1.1s
mgnosov@Maksims-MacBook-Pro playbook % docker ps
CONTAINER ID   IMAGE          COMMAND       CREATED         STATUS                                  PORTS     NAMES
8d94f022321a   centos:7       "/bin/bash"   5 seconds ago   Restarting (0) Less than a second ago             centos7
cec94a363f05   ubuntu:20.04   "bash"        5 seconds ago   Restarting (0) Less than a second ago             ubuntu
````
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
````
mgnosov@Maksims-MacBook-Pro playbook % ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] *********************************************************************************

TASK [Gathering Facts] ********************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ***************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP ********************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
````
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.
``mgnosov@Maksims-MacBook-Pro playbook % nano ~/downloads/playbook/group_vars/deb/examp.yml``
````
  GNU nano 2.0.6     File: /Users/mgnosov/downloads/playbook/group_vars/deb/examp.yml                  

---
  some_fact: "deb default facts"
````
``nano ~/downloads/playbook/group_vars/el/examp.yml``
````
  GNU nano 2.0.6      File: /Users/mgnosov/downloads/playbook/group_vars/el/examp.yml                  

---
  some_fact: "el default fact"
````
6. Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
````
mgnosov@Maksims-MacBook-Pro playbook % ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] *********************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ***************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default facts"
}

PLAY RECAP ********************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
````
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
````
mgnosov@Maksims-MacBook-Pro playbook % ansible-vault encrypt ~/downloads/playbook/group_vars/deb/examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful
(venv) mgnosov@Maksims-MacBook-Pro playbook % ansible-vault encrypt ~/downloads/playbook/group_vars/el/examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful
````
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
````
mgnosov@Maksims-MacBook-Pro playbook % ansible-playbook -i inventory/prod.yml site.yml                       

PLAY [Print os facts] *********************************************************************************************************************************************************
ERROR! Attempting to decrypt but no vault secrets found
(venv) mgnosov@Maksims-MacBook-Pro playbook % ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] *********************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ***************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default facts"
}

PLAY RECAP ********************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
````
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
````
mgnosov@Maksims-MacBook-Pro playbook % ansible-doc -t connection -l
...
local                          execute on controller 
...
````
10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
````
 GNU nano 2.0.6                               File: /Users/mgnosov/downloads/playbook/inventory/prod.yml                                                                      

---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker

  local:
    hosts:
      localhost:
        ansible_connection: local
````

11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
````
mgnosov@Maksims-MacBook-Pro playbook % mkdir group_vars/local
mgnosov@Maksims-MacBook-Pro playbook % nano group_vars/local/examp.yml
  GNU nano 2.0.6                                        File: group_vars/local/examp.yml                                                                                       

---
  some_fact: "all default facts"

mgnosov@Maksims-MacBook-Pro playbook % ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] *********************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************
[WARNING]: Platform darwin on host localhost is using the discovered Python interpreter at /Users/mgnosov/devops-netology/venv/bin/python3.8, but future installation of
another Python interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-core/2.12/reference_appendices/interpreter_discovery.html for more
information.
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ***************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "MacOSX"
}

TASK [Print fact] *************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default facts"
}
ok: [localhost] => {
    "msg": "all default facts"
}

PLAY RECAP ********************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
````
12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.
3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---