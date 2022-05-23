
# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера" Носов Максим

## Как сдавать задания

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.

Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Любые вопросы по решению задач задавайте в чате Slack.

---

## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.


##Решение
https://hub.docker.com/repository/docker/mgnosov/nginx

<details><summery>Реализация</summery>

````
sh-3.2# docker pull nginx:1.21.6-alpine
1.21.6-alpine: Pulling from library/nginx
df9b9388f04a: Pull complete 
a285f0f83eed: Pull complete 
e00351ea626c: Pull complete 
06f5cb628050: Pull complete 
32261d4e220f: Pull complete 
9da77f8e409e: Pull complete 
Digest: sha256:a74534e76ee1121d418fa7394ca930eb67440deda413848bc67c68138535b989
Status: Downloaded newer image for nginx:1.21.6-alpine
docker.io/library/nginx:1.21.6-alpine
sh-3.2# docker images
REPOSITORY   TAG             IMAGE ID       CREATED      SIZE
nginx        1.21.6-alpine   b1c3acb28882   4 days ago   23.4MB
sh-3.2# docker build -t mgnosov/nginx:1.21.6 .
Sending build context to Docker daemon  4.096kB
Step 1/7 : FROM nginx:1.21.6-alpine
 ---> b1c3acb28882
Step 2/7 : RUN mkdir /etc/nginx/sites-available
 ---> Running in 5b286466b4d5
Removing intermediate container 5b286466b4d5
 ---> 197eec2a2823
Step 3/7 : COPY default /etc/nginx/sites-available/default
 ---> 9c59d4bf8372
Step 4/7 : RUN rm /usr/share/nginx/html/index.html
 ---> Running in fc5dd9fc0cf9
Removing intermediate container fc5dd9fc0cf9
 ---> 37d749446284
Step 5/7 : COPY index.html /usr/share/nginx/html/index.html
 ---> 44301bc4280d
Step 6/7 : EXPOSE 80/tcp
 ---> Running in 2c31c9644b52
Removing intermediate container 2c31c9644b52
 ---> 67abc35bd96d
Step 7/7 : CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
 ---> Running in a65453817369
Removing intermediate container a65453817369
 ---> 7390e175f04e
Successfully built 7390e175f04e
Successfully tagged mgnosov/nginx:1.21.6
sh-3.2# docker run -p 80:80 -d mgnosov/nginx:1.21.6
dfe22693e326e0306c6fd47bf77097123701fdcb229b86844d5984cad17bcddb
sh-3.2# docker ps
CONTAINER ID   IMAGE                  COMMAND                  CREATED          STATUS          PORTS                NAMES
dfe22693e326   mgnosov/nginx:1.21.6   "/docker-entrypoint.…"   24 minutes ago   Up 24 minutes   0.0.0.0:80->80/tcp   stupefied_rhodes
mgnosov@Maksims-MacBook-Pro ~ % docker push mgnosov/nginx:1.21.6
The push refers to repository [docker.io/mgnosov/nginx]
b5d0f54c1161: Pushed 
eaf172b9c268: Pushed 
7cceb523b79a: Pushed 
ddba0922fe63: Pushed 
c0e7c94aefd8: Mounted from library/nginx 
d6dd885da0bb: Mounted from library/nginx 
a43749efe4ec: Mounted from library/nginx 
45b275e8a06d: Mounted from library/nginx 
4721bfafc708: Mounted from library/nginx 
4fc242d58285: Mounted from library/nginx 
1.21.6: digest: sha256:302fd399791e6f435f496d59942c26b011cbee210166b95e6575474bc533da62 size: 2396

````
![Текст](/Users/mgnosov/devops-netology/homework/Virt-Homework/HM_5.3./img.png)

###Содержимое Dockerfile
````
FROM nginx:1.21.6-alpine
RUN mkdir /etc/nginx/sites-available
COPY default /etc/nginx/sites-available/default
RUN rm /usr/share/nginx/html/index.html
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80/tcp
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
````
</details>

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.


Сценарий:

- Высоконагруженное монолитное java веб-приложение;
- Nodejs веб-приложение;
- Мобильное приложение c версиями для Android и iOS;
- Шина данных на базе Apache Kafka;
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
- Мониторинг-стек на базе Prometheus и Grafana;
- MongoDB, как основное хранилище данных для java-приложения;
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

##Решение
- Высоконагруженное монолитное java веб-приложение;
Поскольку речь идёт о монолитном приложении Docker здесь непригоден. Монолитное приложение весьма тяжеловестно, что скажется на его запуске и работе в Docker. Если же есть непреодолимое жаление использовать Docker, придётся разделить приложение на микросервисы.

- Nodejs веб-приложение;
Docker подходит, поскольку речь идёт о веб-приложение, легковесном, легко масштабируемом.

- Мобильное приложение c версиями для Android и iOS;
Можно использовать для этих целей и Docker, но настройка и подготовка займет много времени. Будет лучше использовать виртуальную машину.

- Шина данных на базе Apache Kafka;
Для Apache Kafka лучше использовать полноценный виртуальный или физический сервер. Поскольку если поток данных довольно большой, а ценность их велика, контейнер может не подойти для решения данной задачи.

- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
Для данной задачи я бы использовал виртуальные сервера. Поскольку подозреваю, что логов будет довольно много, опят же в зависимости от того, насколько развернуто они собираются. Плюс время хранения. Думаю, что Docker не самый лучший подход в этой задаче. 

- Мониторинг-стек на базе Prometheus и Grafana;
Вполне можно использовать Docker. Prometheus и Grafana не ресурсоемкие приложения.

- MongoDB, как основное хранилище данных для java-приложения;
На мой взгляд больше подходят виртуальные машины, чем контейнеры, ввиду сложности администрирования MongoDB внутри контейнера и вероятности потери данных при потере контейнера.

- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.
Docker не подходит в данном случае, при потере контейнера будет сложно восстановить данные. Лучше использовать физический или виртуальный сервера.
--

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

##Решение
````
mgnosov@Maksims-MacBook-Pro ~ % sudo mkdir ~/Downloads/data    
mgnosov@Maksims-MacBook-Pro ~ % docker pull centos     
mgnosov@Maksims-MacBook-Pro ~ % docker pull debian 
** В настройках Docker добавляем папку в категорию "общая" **
mgmgnosov@Maksims-MacBook-Pro % docker run -v ~/Downloads/data:/data -dt --name mgnosovcentos centos
e9071a1cc886538c209e48d83738ff38f12aa169790ad0348a39cb05006f998a
mgnosov@Maksims-MacBook-Pro % docker run -v ~/Downloads/data:/data -dt --name mgnosovdebian debian
95a00c473c12720bad69cec83ccf77360b2c95d91395f86736faa8799b370feb
mgnosov@Maksims-MacBook-Pro % docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS          PORTS     NAMES
95a00c473c12   debian    "bash"        4 seconds ago    Up 3 seconds              mgnosovdebian
e9071a1cc886   centos    "/bin/bash"   21 seconds ago   Up 20 seconds             mgnosovcentos
mgnosov@Maksims-MacBook-Pro % docker exec -it mgnosovcentos /bin/bash
[root@e9071a1cc886 /]# echo " Hi I'm from centos! " > /data/centos
[root@e9071a1cc886 /]# exit
mgnosov@Maksims-MacBook-Pro ~ % cd /Downloads/data
cd: no such file or directory: /Downloads/data
mgnosov@Maksims-MacBook-Pro ~ % cd ~/Downloads/data
mgnosov@Maksims-MacBook-Pro data % ls
centos
mgnosov@Maksims-MacBook-Pro data % cat centos
 Hi I'm from centos! 
mgnosov@Maksims-MacBook-Pro data % nano macos
mgnosov@Maksims-MacBook-Pro data % docker exec -it mgnosovdebian bash
root@95a00c473c12:/# cd data
root@95a00c473c12:/data# ls
centos  macos
root@95a00c473c12:/data# 
 

````
## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.


---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---