# Тестовое задание Максим Носов
### Часть 1. Часть Python + Docker.
Разработать микро вебсервис отображающий простую статическую страницу с текстом: Hello world.
Сервис упаковать в контейнер.
Примечание: Никаких ограничений на использование модулей и фреймворков нет, можно использовать любые средства.

#### Результат
1. За основу был взят модуль [Flask](https://pythonbasics.org/flask-tutorial-hello-world/).
Был создан файл [index.html](https://github.com/MGNosov/devops-netology/blob/main/test_assessment/src/ansible/files/web_microservice/index.html)
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

Код веб сервиса [main.py](https://github.com/MGNosov/devops-netology/blob/main/test_assessment/src/ansible/files/web_microservice/main.py)
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
Файл образа [Dockerfile](https://github.com/MGNosov/devops-netology/blob/main/test_assessment/src/ansible/files/Dockerfile)
````Dockerfile
FROM python:3.12.0a7-bullseye
COPY ./prerequest.txt /app/prerequest.txt
WORKDIR /app
RUN pip install -r prerequest.txt
COPY ./web_microservice /app
ENTRYPOINT [ "python3" ]
CMD [ "main.py" ]
````

Был добавлен файл [prerequest.txt](https://github.com/MGNosov/devops-netology/blob/main/test_assessment/src/ansible/files/web_microservice/prerequest.txt) для установки модуля Flask.

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

#### Результат
Для выполнения данного задания использовал Ansible в связке с Vagrant.
Был доработан [Vagrant](https://github.com/MGNosov/devops-netology/blob/main/test_assessment/src/Vagrantfile)
````ruby
ISO = "bento/centos-7.9"
DOMAIN = ".mgnosov"
HOST_PREFIX = "vm"

servers = [
  {
    :hostname => HOST_PREFIX + "1" + DOMAIN,
    :ssh_host => "2222",
    :ssh_vm => "22",
    :http_host => "8081",
    :http_vm => "8081",
    :ram => 1024,
    :core => 1
  }
]

Vagrant.configure(2) do |config|
  config.vm.synced_folder ".", "/vagrant", disable: false
  servers.each do |machine|
    config.vm.define machine[:hostname]
      config.vm.box = ISO
      config.vm.network :forwarded_port, guest: machine[:ssh_vm], host: machine[:ssh_host]
      config.vm.network :forwarded_port, guest: machine[:http_vm], host: machine[:http_host]
      config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory", machine[:ram]]
        vb.customize ["modifyvm", :id, "--cpus", machine[:core]]
        vb.name = machine[:machine]
      config.vm.provision "ansible" do |setup|
        setup.playbook = "../test_assessment/src/ansible/provision.yaml"
        setup.become = true
        setup.extra_vars = { ansible_user: 'vagrant' }
        end
      end
    end
  end
````
OS - CentOS 7.9
Playbook в файле [provision.yaml](https://github.com/MGNosov/devops-netology/blob/main/test_assessment/src/ansible/provision.yaml)
````yaml
---
- hosts: all
  become: yes
  remote_user: vagrant
  become_user: root
  become_method: sudo
  tasks:

    - name: Create directory for ssh-keys
      file: state=directory mode=0700 dest=/root/.ssh

    - name: Add rsa-keys in /root/.ssh/authorized_keys
      copy: src=~/.ssh/id_rsa.pub dest=/root/.ssh/authorized_keys owner=root mode=0600
      ignore_errors: yes

    - name: Tools installation
      yum: >
        name={{ item }}
        state=present
        update_cache=yes
      with_items:
        - curl
        - python3
        - python3-pip
        - python-requests

    - name: Add docker repository
      get_url:
        url: https://download.docker.com/linux/centos/docker-ce.repo
        dest: /etc/yum.repos.d/docker-ce.repo
      become: yes

    - name: Installing Docker packages
      yum: >
        name={{ item }}
        state=present
        update_cache=yes
      with_items:
        - docker-ce
        - docker-ce-cli
        - containerd.io

    - name: Enable docker daemon
      service:
        name: docker
        state: started
        enabled: yes
      become: yes

    - name: Synching files
      copy:
        src: web_microservice/
        dest: "/opt/web_microservice/"

    - name: Copy Dockerfile
      copy:
        src: Dockerfile
        dest: /opt/

    - name: Build container image
      docker_image:
        name: assessment_image
        source: build
        build:
          path: /opt

    - name: Start docker container
      docker_container:
        image: assessment_image
        name: assessment
        state: started
        ports:
          - "8081:5000"
````
Проверяем:
````bash
mgnosov@Maksims-MacBook-Pro test_assessment % vagrant up
Bringing machine 'vm1.mgnosov' up with 'virtualbox' provider...
==> vm1.mgnosov: Importing base box 'bento/centos-7.9'...
==> vm1.mgnosov: Matching MAC address for NAT networking...
==> vm1.mgnosov: Checking if box 'bento/centos-7.9' version '202303.13.0' is up to date...
==> vm1.mgnosov: There was a problem while downloading the metadata for your box
==> vm1.mgnosov: to check for updates. This is not an error, since it is usually due
==> vm1.mgnosov: to temporary network problems. This is just a warning. The problem
==> vm1.mgnosov: encountered was:
==> vm1.mgnosov:
==> vm1.mgnosov: The requested URL returned error: 404
==> vm1.mgnosov:
==> vm1.mgnosov: If you want to check for box updates, verify your network connection
==> vm1.mgnosov: is valid and try again.
==> vm1.mgnosov: Setting the name of the VM: test_assessment_vm1mgnosov_1681230516567_5347
==> vm1.mgnosov: Clearing any previously set network interfaces...
==> vm1.mgnosov: Preparing network interfaces based on configuration...
    vm1.mgnosov: Adapter 1: nat
==> vm1.mgnosov: Forwarding ports...
    vm1.mgnosov: 22 (guest) => 2222 (host) (adapter 1)
    vm1.mgnosov: 8081 (guest) => 8081 (host) (adapter 1)
    vm1.mgnosov: 22 (guest) => 2222 (host) (adapter 1)
==> vm1.mgnosov: Running 'pre-boot' VM customizations...
==> vm1.mgnosov: Booting VM...
==> vm1.mgnosov: Waiting for machine to boot. This may take a few minutes...
    vm1.mgnosov: SSH address: 127.0.0.1:2222
    vm1.mgnosov: SSH username: vagrant
    vm1.mgnosov: SSH auth method: private key
    vm1.mgnosov:
    vm1.mgnosov: Vagrant insecure key detected. Vagrant will automatically replace
    vm1.mgnosov: this with a newly generated keypair for better security.
    vm1.mgnosov:
    vm1.mgnosov: Inserting generated public key within guest...
    vm1.mgnosov: Removing insecure key from the guest if it is present...
    vm1.mgnosov: Key inserted! Disconnecting and reconnecting using new SSH key...
==> vm1.mgnosov: Machine booted and ready!
==> vm1.mgnosov: Checking for guest additions in VM...
==> vm1.mgnosov: Mounting shared folders...
    vm1.mgnosov: /vagrant => /Users/mgnosov/Downloads/github/devops-netology/test_assessment
==> vm1.mgnosov: Running provisioner: ansible...
    vm1.mgnosov: Running ansible-playbook...

PLAY [all] *********************************************************************

TASK [Gathering Facts] *********************************************************
ok: [vm1.mgnosov]

TASK [Create directory for ssh-keys] *******************************************
changed: [vm1.mgnosov]

TASK [Add rsa-keys in /root/.ssh/authorized_keys] ******************************
changed: [vm1.mgnosov]

TASK [Tools installation] ******************************************************
ok: [vm1.mgnosov] => (item=curl)
changed: [vm1.mgnosov] => (item=python3)
ok: [vm1.mgnosov] => (item=python3-pip)
changed: [vm1.mgnosov] => (item=python-requests)

TASK [Add docker repository] ***************************************************
changed: [vm1.mgnosov]

TASK [Installing Docker packages] **********************************************
changed: [vm1.mgnosov] => (item=docker-ce)
ok: [vm1.mgnosov] => (item=docker-ce-cli)
ok: [vm1.mgnosov] => (item=containerd.io)

TASK [Enable docker daemon] ****************************************************
changed: [vm1.mgnosov]

TASK [Synching files] **********************************************************
changed: [vm1.mgnosov]

TASK [Copy Dockerfile] *********************************************************
changed: [vm1.mgnosov]

TASK [Build container image] ***************************************************
changed: [vm1.mgnosov]

TASK [Start docker container] **************************************************
changed: [vm1.mgnosov]

PLAY RECAP *********************************************************************
vm1.mgnosov                : ok=11   changed=10   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
````
Заходим на виртуальную машину, проверяем, что всё соответствует условиям:
````bash
mgnosov@Maksims-MacBook-Pro test_assessment % vagrant ssh
Last login: Tue Apr 11 16:34:12 2023 from 10.0.2.2

This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
-bash: warning: setlocale: LC_CTYPE: cannot change locale (UTF-8): No such file or directory
[vagrant@localhost ~]$ sudo su
[root@localhost vagrant]# cat /etc/centos-release
CentOS Linux release 7.9.2009 (Core)
[root@localhost vagrant]# docker --version
Docker version 23.0.3, build 3e7cbfd
[root@localhost vagrant]# docker ps
CONTAINER ID   IMAGE              COMMAND            CREATED         STATUS         PORTS                    NAMES
a99a0567e4ec   assessment_image   "python main.py"   5 minutes ago   Up 5 minutes   0.0.0.0:8081->5000/tcp   assessment
````
Сервис доступ из браузера на хостовой машине.
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/test_assessment/imgs/img01.png">

Источники:
[Домашняя работа 5.4](https://github.com/MGNosov/devops-netology/tree/main/homework/Virt-Homework/HM_5.4.)
[Docker Hub](https://hub.docker.com/_/python)
[DockerDocs](https://docs.docker.com/compose/gettingstarted/)
[Hashicorp](https://developer.hashicorp.com/vagrant/docs/provisioning/ansible)
