# Домашнее задание к занятию "09.03 Jenkins" Носов Максим

## Подготовка к выполнению

1. Установить jenkins по любой из [инструкций](https://www.jenkins.io/download/)
````
mgnosov@Maksims-MacBook-Pro Homework % docker run -p 8080:8080 -p 50000:50000 -d -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
Unable to find image 'jenkins/jenkins:lts' locally
lts: Pulling from jenkins/jenkins
1339eaac5b67: Pull complete 
20401c7e91bc: Pull complete 
7138cd942003: Pull complete 
6d1b42f45e89: Pull complete 
98b0e135a912: Pull complete 
ed90436583b0: Pull complete 
b0b3716848f8: Pull complete 
4035b7550508: Pull complete 
e9a1c1f127f6: Pull complete 
6137d1289fb5: Pull complete 
213d8e7e603c: Pull complete 
42b46c55d38d: Pull complete 
8324f1380818: Pull complete 
2201f3ff6253: Pull complete 
Digest: sha256:c878e1aac1f5152a6234b33a10542c7f694b7c5c37de27191d1c173800853b93
Status: Downloaded newer image for jenkins/jenkins:lts
fe1e932621e881c91865b7b8c12541a5f70f3a2cfbf0210f9e527780ea3be261
````
2. Запустить и проверить работоспособность
````
mgnosov@Maksims-MacBook-Pro Homework % docker ps
CONTAINER ID   IMAGE                 COMMAND                  CREATED          STATUS          PORTS                                              NAMES
fe1e932621e8   jenkins/jenkins:lts   "/usr/bin/tini -- /u…"   15 seconds ago   Up 13 seconds   0.0.0.0:8080->8080/tcp, 0.0.0.0:50000->50000/tcp   dazzling_raman
````
3. Сделать первоначальную настройку
<p align="cetner">
   <img src="https://github.com/MGNosov/devops-netology/blob/main/homework/Virt-Homework/HM_9.3./img/img00.png">
</p>
4. Настроить под свои нужды
5. Поднять отдельный cloud
6. Для динамических агентов можно использовать [образ](https://hub.docker.com/repository/docker/aragast/agent)
7. Обязательный параметр: поставить label для динамических агентов: `ansible_docker`
8. Сделать форк репозитория с [playbook](https://github.com/aragastmatb/example-playbook)

## Основная часть

1. Сделать Freestyle Job, который будет запускать `ansible-playbook` из форка репозитория
2. Сделать Declarative Pipeline, который будет выкачивать репозиторий с плейбукой и запускать её
3. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`
4. Перенастроить Job на использование `Jenkinsfile` из репозитория
5. Создать Scripted Pipeline, наполнить его скриптом из [pipeline](./pipeline)
6. Заменить credentialsId на свой собственный
7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозитрий в файл `ScriptedJenkinsfile`
8. Отправить ссылку на репозиторий в ответе

## Необязательная часть

1. Создать скрипт на groovy, который будет собирать все Job, которые завершились хотя бы раз неуспешно. Добавить скрипт в репозиторий с решеним с названием `AllJobFailure.groovy`
2. Установить customtools plugin
3. Поднять инстанс с локальным nexus, выложить туда в анонимный доступ  .tar.gz с `ansible`  версии 2.9.x
4. Создать джобу, которая будет использовать `ansible` из `customtool`
5. Джоба должна просто исполнять команду `ansible --version`, в ответ прислать лог исполнения джобы 

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---