# Тестовое задание Максим Носов
### Часть 1. Часть Python + Docker.
Разработать микро вебсервис отображающий простую статическую страницу с текстом: Hello world.
Сервис упаковать в контейнер.
Примечание: Никаких ограничений на использование модулей и фреймворков нет, можно использовать любые средства.

#### Результат
1. За основу был взят модуль [Flask](https://pythonbasics.org/flask-tutorial-hello-world/).
Был создан файл [index.html](https://github.com/MGNosov/devops-netology/blob/main/test_assessment/src/web_microservice/index.html)
````
</<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title>Test assesment</title>
  </head>
  <body>
    <h1> Hello world!</h1>
  </body>
</html>
````

Код веб сервиса [main.py](https://github.com/MGNosov/devops-netology/blob/main/test_assessment/src/web_microservice/main.py)
````python
from flask import Flask, render_template
import os, sys
app = Flask(__name__, template_folder="/app")
@app.route("/")
def home():
    return render_template("index.html")
if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
````
Файл образа [Dockerfile](https://github.com/MGNosov/devops-netology/blob/main/test_assessment/src/Dockerfile)
````Dockerfile
FROM python:3.12.0a7-bullseye
COPY ./prerequest.txt /app/prerequest.txt
WORKDIR /app
RUN pip install -r prerequest.txt
COPY ./web_microservice /app
ENTRYPOINT [ "python3" ]
CMD [ "main.py" ]
````

Был добавлен файл [prerequest.txt](https://github.com/MGNosov/devops-netology/blob/main/test_assessment/src/prerequest.txt) для установки модуля Flask.

Проверяем.
Собираем образ:
````bash
mgnosov@Maksims-MacBook-Pro src % docker image build -t assessment_container .
[+] Building 1.8s (11/11) FINISHED                                                                                  
 => [internal] load build definition from Dockerfile                                                           0.0s
 => => transferring dockerfile: 37B                                                                            0.0s
 => [internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                0.0s
 => [internal] load metadata for docker.io/library/python:3.12.0a7-bullseye                                    1.7s
 => [auth] library/python:pull token for registry-1.docker.io                                                  0.0s
 => [1/5] FROM docker.io/library/python:3.12.0a7-bullseye@sha256:3125e5896c50d7b17ddc7f1b0330d98839cd0f66184f  0.0s
 => [internal] load build context                                                                              0.0s
 => => transferring context: 255B                                                                              0.0s
 => CACHED [2/5] COPY ./prerequest.txt /app/prerequest.txt                                                     0.0s
 => CACHED [3/5] WORKDIR /app                                                                                  0.0s
 => CACHED [4/5] RUN pip install -r prerequest.txt                                                             0.0s
 => CACHED [5/5] COPY ./web_microservice /app                                                                  0.0s
 => exporting to image                                                                                         0.0s
 => => exporting layers                                                                                        0.0s
 => => writing image sha256:4ae03fb3936db81f2f1533d4a87ee9ec2befd3b36e3250b3613cac23524c7a26                   0.0s
 => => naming to docker.io/library/assessment_container                                                        0.0s
````

Запускаем контейнер по порту 8080:
````bash
mgnosov@Maksims-MacBook-Pro src % docker run -p 8080:5000 -d assessment_container
ac7f15ff3a57b25c04aedb90949f746a2a5df3e65e8e2a5d7fc26024fa2754d8
mgnosov@Maksims-MacBook-Pro src % docker ps
CONTAINER ID   IMAGE                  COMMAND             CREATED         STATUS         PORTS                    NAMES
ac7f15ff3a57   assessment_container   "python3 main.py"   9 minutes ago   Up 9 minutes   0.0.0.0:8080->5000/tcp   jolly_noyce
````
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/test_assessment/imgs/img00.png">


### Часть 2. Разработать небольшой playbook, который выполняет следующее:
1) Установка docker
2) Сборка образа контейнера, в который необходимо включить разработанный ранее сервис на питоне. За базовый образ для сборки контейнера можно взять любой понравившийся.
3) Запустить контейнер из собранного ранее образа.
4) По итогам выполнения playbook'а сервис должен быть доступен по адресу хоста, на котором запущен контейнер, по порту 8081.
5) За использование ansible модулей shell и command баллы снижаются.
6) Весь получившийся код (playbook, докерфайл, python код) сохранить в гит репозитории с краткой инструкцией по использованию в файле README.md.

Операционная система: CentOS7.6+.
Docker версии 18+
