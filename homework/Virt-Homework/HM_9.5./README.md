# Домашнее задание к занятию "09.05 Gitlab"

## Подготовка к выполнению

1. Необходимо [зарегистрироваться](https://about.gitlab.com/free-trial/)
2. Создайте свой новый проект
3. Создайте новый репозиторий в gitlab, наполните его [файлами](./repository)
4. Проект должен быть публичным, остальные настройки по желанию

## Основная часть

### DevOps

В репозитории содержится код проекта на python. Проект - RESTful API сервис. Ваша задача автоматизировать сборку образа с выполнением python-скрипта:
1. Образ собирается на основе [centos:7](https://hub.docker.com/_/centos?tab=tags&page=1&ordering=last_updated)
2. Python версии не ниже 3.7
3. Установлены зависимости: `flask` `flask-jsonpify` `flask-restful`
4. Создана директория `/python_api`
5. Скрипт из репозитория размещён в /python_api
6. Точка вызова: запуск скрипта
7. Если сборка происходит на ветке `master`: Образ должен пушится в docker registry вашего gitlab `python-api:latest`, иначе этот шаг нужно пропустить
##### Результат
[Ссылка на репозиторий](https://gitlab.com/MGNosov/homework_9_5)

[Dockerfile](https://gitlab.com/MGNosov/homework_9_5/-/blob/main/repository/Dockerfile)
````
mgnosov@Maksims-MacBook-Pro repository % git pull https://gitlab.com/MGNosov/homework_9_5.git
From https://gitlab.com/MGNosov/homework_9_5
 * branch            HEAD       -> FETCH_HEAD
Updating 276b963..a217a51
Fast-forward
 .gitlab-ci.yml | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 .gitlab-ci.yml
mgnosov@Maksims-MacBook-Pro repository % docker build . -t mgnosov/centos
[+] Building 2.3s (25/25) FINISHED                                              
 => [internal] load build definition from Dockerfile                       0.0s
 => => transferring dockerfile: 37B                                        0.0s
 => [internal] load .dockerignore                                          0.0s
 => => transferring context: 2B                                            0.0s
 => [internal] load metadata for docker.io/library/centos:7                2.1s
 => [auth] library/centos:pull token for registry-1.docker.io              0.0s
 => [ 1/19] FROM docker.io/library/centos:7@sha256:c73f515d06b0fa07bb18d8  0.0s
 => [internal] load build context                                          0.0s
 => => transferring context: 35B                                           0.0s
 => CACHED [ 2/19] RUN yum update -y                                       0.0s
 => CACHED [ 3/19] RUN yum groupinstall "Development Tools" -y             0.0s
 => CACHED [ 4/19] RUN yum install openssl-devel libffi-devel bzip2-devel  0.0s
 => CACHED [ 5/19] RUN yum install wget -y                                 0.0s
 => CACHED [ 6/19] RUN cd /tmp                                             0.0s
 => CACHED [ 7/19] RUN wget https://www.python.org/ftp/python/3.8.7/Pytho  0.0s
 => CACHED [ 8/19] RUN tar xzf Python-3.8.7.tgz                            0.0s
 => CACHED [ 9/19] RUN cd Python-3.8.7                                     0.0s
 => CACHED [10/19] WORKDIR /Python-3.8.7                                   0.0s
 => CACHED [11/19] RUN ./configure --enable-optimizations                  0.0s
 => CACHED [12/19] RUN make altinstall                                     0.0s
 => CACHED [13/19] RUN pip3.8 install flask                                0.0s
 => CACHED [14/19] RUN pip3.8 install flask-jsonpify                       0.0s
 => CACHED [15/19] RUN pip3.8 install flask-restful                        0.0s
 => CACHED [16/19] RUN mkdir /python_api                                   0.0s
 => CACHED [17/19] ADD python_api.py /python_api/python_api.py             0.0s
 => CACHED [18/19] RUN cd /python_api                                      0.0s
 => CACHED [19/19] WORKDIR /python_api                                     0.0s
 => exporting to image                                                     0.0s
 => => exporting layers                                                    0.0s
 => => writing image sha256:ecbef5a8af5255931d54873714780bfb7ce166dc3762f  0.0s
 => => naming to docker.io/mgnosov/centos                                  0.0s
mgnosov@Maksims-MacBook-Pro repository % docker run -d -p 5290:5290 mgnosov/centos
38a7d5d8b5f5aa558ba80e4a0e8853e84fd09df3d17fc84edf44eb6852748df7
mgnosov@Maksims-MacBook-Pro repository % docker ps
CONTAINER ID   IMAGE            COMMAND                  CREATED         STATUS         PORTS                    NAMES
38a7d5d8b5f5   mgnosov/centos   "/bin/sh -c 'python3…"   4 seconds ago   Up 3 seconds   0.0.0.0:5290->5290/tcp   nervous_chaum
mgnosov@Maksims-MacBook-Pro repository % curl localhost:5290/get_info
{"version": 3, "method": "GET", "message": "Already started"}
mgnosov@Maksims-MacBook-Pro repository % 

````
### Product Owner

Вашему проекту нужна бизнесовая доработка: необходимо поменять JSON ответа на вызов метода GET `/rest/api/get_info`, необходимо создать Issue в котором указать:
1. Какой метод необходимо исправить
2. Текст с `{ "message": "Already started" }` на `{ "message": "Running"}`
3. Issue поставить label: feature

### Developer

Вам пришел новый Issue на доработку, вам необходимо:
1. Создать отдельную ветку, связанную с этим issue
2. Внести изменения по тексту из задания
3. Подготовить Merge Requst, влить необходимые изменения в `master`, проверить, что сборка прошла успешно

##### Результат
[Merge Request](https://gitlab.com/MGNosov/homework_9_5/-/merge_requests?scope=all&state=all)
````
mgnosov@Maksims-MacBook-Pro repository % git add python_api.py
mgnosov@Maksims-MacBook-Pro repository % git commit -m "Changed message"
[main 5a728a2] Changed message
 Committer: Maksim Nosov <mgnosov@Maksims-MacBook-Pro.local>
Your name and email address were configured automatically based
on your username and hostname. Please check that they are accurate.
You can suppress this message by setting them explicitly. Run the
following command and follow the instructions in your editor to edit
your configuration file:

    git config --global --edit

After doing this, you may fix the identity used for this commit with:

    git commit --amend --reset-author

 1 file changed, 2 insertions(+), 2 deletions(-)
mgnosov@Maksims-MacBook-Pro repository % git push
Enumerating objects: 7, done.
Counting objects: 100% (7/7), done.
Delta compression using up to 8 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 397 bytes | 397.00 KiB/s, done.
Total 4 (delta 2), reused 0 (delta 0), pack-reused 0
To https://gitlab.com/MGNosov/homework_9_5.git
   a217a51..5a728a2  main -> main

````

### Tester

Разработчики выполнили новый Issue, необходимо проверить валидность изменений:
1. Поднять докер-контейнер с образом `python-api:latest` и проверить возврат метода на корректность
2. Закрыть Issue с комментарием об успешности прохождения, указав желаемый результат и фактически достигнутый
````
mgnosov@Maksims-MacBook-Pro repository %         
mgnosov@Maksims-MacBook-Pro repository % docker build . -t mgnosov/python_api:latest
[+] Building 2.7s (25/25) FINISHED                                              
 => [internal] load build definition from Dockerfile                       0.0s
 => => transferring dockerfile: 37B                                        0.0s
 => [internal] load .dockerignore                                          0.0s
 => => transferring context: 2B                                            0.0s
 => [internal] load metadata for docker.io/library/centos:7                2.2s
 => [auth] library/centos:pull token for registry-1.docker.io              0.0s
 => [ 1/19] FROM docker.io/library/centos:7@sha256:c73f515d06b0fa07bb18d8  0.0s
 => [internal] load build context                                          0.0s
 => => transferring context: 482B                                          0.0s
 => CACHED [ 2/19] RUN yum update -y                                       0.0s
 => CACHED [ 3/19] RUN yum groupinstall "Development Tools" -y             0.0s
 => CACHED [ 4/19] RUN yum install openssl-devel libffi-devel bzip2-devel  0.0s
 => CACHED [ 5/19] RUN yum install wget -y                                 0.0s
 => CACHED [ 6/19] RUN cd /tmp                                             0.0s
 => CACHED [ 7/19] RUN wget https://www.python.org/ftp/python/3.8.7/Pytho  0.0s
 => CACHED [ 8/19] RUN tar xzf Python-3.8.7.tgz                            0.0s
 => CACHED [ 9/19] RUN cd Python-3.8.7                                     0.0s
 => CACHED [10/19] WORKDIR /Python-3.8.7                                   0.0s
 => CACHED [11/19] RUN ./configure --enable-optimizations                  0.0s
 => CACHED [12/19] RUN make altinstall                                     0.0s
 => CACHED [13/19] RUN pip3.8 install flask                                0.0s
 => CACHED [14/19] RUN pip3.8 install flask-jsonpify                       0.0s
 => CACHED [15/19] RUN pip3.8 install flask-restful                        0.0s
 => CACHED [16/19] RUN mkdir /python_api                                   0.0s
 => [17/19] ADD python_api.py /python_api/python_api.py                    0.0s
 => [18/19] RUN cd /python_api                                             0.3s
 => [19/19] WORKDIR /python_api                                            0.0s
 => exporting to image                                                     0.0s
 => => exporting layers                                                    0.0s
 => => writing image sha256:882426ec0807b00553b806f2980d86bc46865660dcfed  0.0s
 => => naming to docker.io/mgnosov/python_api:latest                       0.0s
mgnosov@Maksims-MacBook-Pro repository % docker run -p 5290:5290 -d mgnosov/python_api:latest
90e3c094308c8500d201a75df134a6ead2fb04fe141e576bb61a29fea78ced49
mgnosov@Maksims-MacBook-Pro repository % curl localhost:5290/get_info
{"version": 3, "method": "GET", "message": "Running"}
````

## Итог

После успешного прохождения всех ролей - отправьте ссылку на ваш проект в гитлаб, как решение домашнего задания
##### Резульат
[Ссылка на репозиторий](https://gitlab.com/MGNosov/homework_9_5)
## Необязательная часть

Автомазируйте работу тестировщика, пусть у вас будет отдельный конвейер, который автоматически поднимает контейнер и выполняет проверку, например, при помощи curl. На основе вывода - будет приниматься решение об успешности прохождения тестирования

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---