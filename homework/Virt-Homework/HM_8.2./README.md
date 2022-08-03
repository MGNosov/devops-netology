# Домашнее задание к занятию "08.02 Работа с Playbook" Носов Максим

## Подготовка к выполнению
1. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
2. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
3. Подготовьте хосты в соотвтествии с группами из предподготовленного playbook. 
4. Скачайте дистрибутив [java](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) и положите его в директорию `playbook/files/`. 

## Основная часть
1. Приготовьте свой собственный inventory файл `prod.yml`.
````
version: "2.6.1"

services:
  elasticsearch:
    image: pycontribs/ubuntu
    container_name: elasticsearch
    tty: true

  kibana:
    image: pycontribs/ubuntu
    container_name: kibana
    tty: true
````
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает kibana.
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, сгенерировать конфигурацию с параметрами.
````
- name: Install Kibana
  hosts: kibana
  tasks:
    - name: Upload tar.gz Kibana from remote URL
      ansible.builtin.get_url:
        url: "https://artifacts.elastic.co/downloads/kibana/kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
        dest: "/tmp/kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
        mode: 0755
        timeout: 60
        force: true
        validate_certs: false
      register: get_kibana
      until: get_kibana is succeeded
      tags: kibana
    - name: Create directrory for Kibana ({{ kibana_home }})
      ansible.builtin.file:
        mode: 0755
        path: "{{ kibana_home }}"
        state: directory
      tags: kibana
    - name: Extract Kibana in the installation directory
      become: true
      ansible.builtin.unarchive:
        copy: false
        src: "/tmp/kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
        dest: "{{ kibana_home }}"
        extra_opts: [--strip-components=1]
        creates: "{{ kibana_home }}/bin/kibana"
      tags:
        - kibana
    - name: Set environment Kibana
      become: true
      ansible.builtin.template:
        mode: 0755
        src: templates/kibana.sh.j2
        dest: /etc/profile.d/kib.sh
      tags: kibana
````
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
````
mgnosov@Maksims-MacBook-Pro playbook % ansible-lint site.yml
WARNING: PATH altered to include /usr/local/opt/python@3.9/bin
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
````
###### Изначально были ошибки свзяанные с FQCN. Решить проблему помого использование ``ansible.builtin.``.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
````
mgnosov@Maksims-MacBook-Pro playbook % ansible-playbook -i inventory/prod.yml site.yml
[WARNING]: Found both group and host with same name: kibana
[WARNING]: Found both group and host with same name: elasticsearch

PLAY [Install Java] ************************************************************

TASK [Gathering Facts] *********************************************************
ok: [kibana]
ok: [elasticsearch]

TASK [create directory] ********************************************************
changed: [kibana]
changed: [elasticsearch]

TASK [Set facts for Java 11 vars] **********************************************
ok: [elasticsearch]
ok: [kibana]

TASK [Upload .tar.gz file containing binaries from local storage] **************
changed: [kibana]
changed: [elasticsearch]

TASK [Ensure installation dir exists] ******************************************
changed: [elasticsearch]
changed: [kibana]

TASK [Extract java in the installation directory] ******************************
changed: [kibana]
changed: [elasticsearch]

TASK [Export environment variables] ********************************************
changed: [elasticsearch]
changed: [kibana]

PLAY [Install Elasticsearch] ***************************************************

TASK [Gathering Facts] *********************************************************
ok: [elasticsearch]

TASK [Upload tar.gz Elasticsearch from remote URL] *****************************
FAILED - RETRYING: [elasticsearch]: Upload tar.gz Elasticsearch from remote URL (3 retries left).
FAILED - RETRYING: [elasticsearch]: Upload tar.gz Elasticsearch from remote URL (2 retries left).
FAILED - RETRYING: [elasticsearch]: Upload tar.gz Elasticsearch from remote URL (1 retries left).
fatal: [elasticsearch]: FAILED! => {"attempts": 3, "changed": false, "dest": "/tmp/elasticsearch-7.10.1-linux-x86_64.tar.gz", "elapsed": 0, "msg": "Request failed", "response": "HTTP Error 403: Forbidden", "status_code": 403, "url": "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.10.1-linux-x86_64.tar.gz"}

PLAY RECAP *********************************************************************
elasticsearch              : ok=8    changed=5    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   
kibana                     : ok=7    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
````
###### Ошибка связана с недоступностью сервиса Elasticsearch. 
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
````
mgnosov@Maksims-MacBook-Pro playbook % ansible-playbook -i inventory/prod.yml site.yml --diff
[WARNING]: Found both group and host with same name: elasticsearch
[WARNING]: Found both group and host with same name: kibana

PLAY [Install Java] ************************************************************

TASK [Gathering Facts] *********************************************************
ok: [elasticsearch]
ok: [kibana]

TASK [create directory] ********************************************************
ok: [elasticsearch]
ok: [kibana]

TASK [Set facts for Java 11 vars] **********************************************
ok: [elasticsearch]
ok: [kibana]

TASK [Upload .tar.gz file containing binaries from local storage] **************
ok: [elasticsearch]
ok: [kibana]

TASK [Ensure installation dir exists] ******************************************
ok: [elasticsearch]
ok: [kibana]

TASK [Extract java in the installation directory] ******************************
skipping: [elasticsearch]
skipping: [kibana]

TASK [Export environment variables] ********************************************
ok: [kibana]
ok: [elasticsearch]

PLAY [Install Elasticsearch] ***************************************************

TASK [Gathering Facts] *********************************************************
ok: [elasticsearch]

TASK [Upload tar.gz Elasticsearch from remote URL] *****************************
changed: [elasticsearch]

TASK [Create directrory for Elasticsearch] *************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/opt/elastic/7.10.1",
-    "state": "absent"
+    "state": "directory"
 }

changed: [elasticsearch]

TASK [Extract Elasticsearch in the installation directory] *********************
changed: [elasticsearch]

TASK [Set environment Elastic] *************************************************
--- before
+++ after: /Users/mgnosov/.ansible/tmp/ansible-local-3538h7rkc8yb/tmpzrsol4xh/elk.sh.j2
@@ -0,0 +1,5 @@
+# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
+#!/usr/bin/env bash
+
+export ES_HOME=/opt/elastic/7.10.1
+export PATH=$PATH:$ES_HOME/bin

changed: [elasticsearch]

PLAY [Install Kibana] **********************************************************

TASK [Gathering Facts] *********************************************************
ok: [kibana]

TASK [Upload tar.gz Kibana from remote URL] ************************************
changed: [kibana]

TASK [Create directrory for Kibana (/opt/kibana/7.15.2)] ***********************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/opt/kibana/7.15.2",
-    "state": "absent"
+    "state": "directory"
 }

changed: [kibana]

TASK [Extract Kibana in the installation directory] ****************************
changed: [kibana]

TASK [Set environment Kibana] **************************************************
--- before
+++ after: /Users/mgnosov/.ansible/tmp/ansible-local-3538h7rkc8yb/tmpibx8uyfr/kibana.sh.j2
@@ -0,0 +1,5 @@
+# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
+#!/usr/bin/env bash
+
+export KB_HOME=/opt/kibana/7.15.2
+export PATH=$PATH:$KB_HOME/bin

changed: [kibana]

PLAY RECAP *********************************************************************
elasticsearch              : ok=11   changed=4    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0   
kibana                     : ok=11   changed=4    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
````
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
````
mgnosov@Maksims-MacBook-Pro playbook % ansible-playbook -i inventory/prod.yml site.yml --diff
[WARNING]: Found both group and host with same name: kibana
[WARNING]: Found both group and host with same name: elasticsearch

PLAY [Install Java] ************************************************************

TASK [Gathering Facts] *********************************************************
ok: [kibana]
ok: [elasticsearch]

TASK [create directory] ********************************************************
ok: [elasticsearch]
ok: [kibana]

TASK [Set facts for Java 11 vars] **********************************************
ok: [elasticsearch]
ok: [kibana]

TASK [Upload .tar.gz file containing binaries from local storage] **************
ok: [kibana]
ok: [elasticsearch]

TASK [Ensure installation dir exists] ******************************************
ok: [kibana]
ok: [elasticsearch]

TASK [Extract java in the installation directory] ******************************
skipping: [elasticsearch]
skipping: [kibana]

TASK [Export environment variables] ********************************************
ok: [elasticsearch]
ok: [kibana]

PLAY [Install Elasticsearch] ***************************************************

TASK [Gathering Facts] *********************************************************
ok: [elasticsearch]

TASK [Upload tar.gz Elasticsearch from remote URL] *****************************
ok: [elasticsearch]

TASK [Create directrory for Elasticsearch] *************************************
ok: [elasticsearch]

TASK [Extract Elasticsearch in the installation directory] *********************
skipping: [elasticsearch]

TASK [Set environment Elastic] *************************************************
ok: [elasticsearch]

PLAY [Install Kibana] **********************************************************

TASK [Gathering Facts] *********************************************************
ok: [kibana]

TASK [Upload tar.gz Kibana from remote URL] ************************************
ok: [kibana]

TASK [Create directrory for Kibana (/opt/kibana/7.15.2)] ***********************
ok: [kibana]

TASK [Extract Kibana in the installation directory] ****************************
skipping: [kibana]

TASK [Set environment Kibana] **************************************************
ok: [kibana]

PLAY RECAP *********************************************************************
elasticsearch              : ok=10   changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
kibana                     : ok=10   changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
````
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
[README.md](https://github.com/MGNosov/devops-netology/blob/main/homework/Virt-Homework/HM_8.2./playbook/README.md)
10. Готовый playbook выложите в свой репозиторий, в ответ предоставьте ссылку на него.

## Необязательная часть

1. Приготовьте дополнительный хост для установки logstash.
2. Пропишите данный хост в `prod.yml` в новую группу `logstash`.
3. Дополните playbook ещё одним play, который будет исполнять установку logstash только на выделенный для него хост.
4. Все переменные для нового play определите в отдельный файл `group_vars/logstash/vars.yml`.
5. Logstash конфиг должен конфигурироваться в части ссылки на elasticsearch (можно взять, например его IP из facts или определить через vars).
6. Дополните README.md, протестируйте playbook, выложите новую версию в github. В ответ предоставьте ссылку на репозиторий.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
