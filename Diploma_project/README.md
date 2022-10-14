# Дипломный проект
## Этапы выполнения:

### 1. Регистрация доменного имени
#### Результат
Доменное имя ``mgnosov.site`` регистратор [reg.ru](https://www.reg.ru/)
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/img/img00.png">
### 2. Cоздание инфраструктуры
#### Результат
1. Использовался ранее созданный сервисный аккаунт.
````
mgnosov@Maksims-MacBook-Pro ~ % yc iam service-account list
+----------------------+-----------+
|          ID          |   NAME    |
+----------------------+-----------+
| aje12gdkbgac0kmeg446 | src-admin |
+----------------------+-----------+
````
2. Готовый бакет в Yandex.Cloud.
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/img/img01.png">
Конфигурационный файл для создания бакета [main.tf](https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/src/Terrafrom/bucket/main.tf)

3. Были созданы два воркспейся ``stage`` и ``prod``.
4. Конфигурационные файлы Terrafrom: 
 - [main.tf](https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/src/Terrafrom/main.tf);
 - [network.tf](https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/src/Terrafrom/network.tf);
 - [output.tf](https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/src/Terrafrom/output.tf);
 - [provider.tf](https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/src/Terrafrom/provider.tf);
 - [varibales.tf](https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/src/Terrafrom/variables.tf);

В процессе подготовки был дополнительно создан файл [meta.txt](https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/src/Terrafrom/meta.txt) для получения ``root`` доступа к вирутальным машинам. 
Соответственно конфигурация в [main.tf](https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/src/Terrafrom/main.tf) была изменена с...
````
metadata = {
    ssh-keys = "root:${file("~/.ssh/id_rsa.pub")}"
  }
````
на...
````
metadata = {
    user-data = "${file("~/downloads/final_project/terraform/iac/meta.txt")}"
    }
````
Создаем виртуальные машины:
````
mgnosov@Maksims-MacBook-Pro iac % terraform apply -auto-approve
...
Apply complete! Resources: 12 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_app_yandex_cloud = "178.154.228.124"
external_ip_address_db01_yandex_cloud = "178.154.229.88"
external_ip_address_db02_yandex_cloud = "51.250.85.93"
external_ip_address_gitlab_yandex_cloud = "178.154.203.46"
external_ip_address_monitoring_yandex_cloud = "178.154.226.158"
external_ip_address_revproxy_yandex_cloud = "84.201.128.39"
external_ip_address_runner_yandex_cloud = "178.154.228.15"
internal_ip_address_app_yandex_cloud = "10.2.0.10"
internal_ip_address_db01_yandex_cloud = "10.2.0.27"
internal_ip_address_db02_yandex_cloud = "10.2.0.11"
internal_ip_address_gitlab_yandex_cloud = "10.3.0.11"
internal_ip_address_monitoring_yandex_cloud = "10.4.0.6"
internal_ip_address_revproxy_yandex_cloud = "10.1.0.16"
internal_ip_address_runner_yandex_cloud = "10.3.0.9"
````
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/img/img02.png">


### 3. Установка Nginx и LetsEncrypt
#### Результат
Для выполнения данной задачи за основу была взята роль [ansible-letsencrypt-nginx-revproxy](https://github.com/hispanico/ansible-letsencrypt-nginx-revproxy).
1. Добавлены А-записи в личном кабинете [reg.ru](reg.ru)
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/img/img03.png">
2. Добавляем upstream'ы в файл [/default/main.yml](https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/src/Ansible/roles/revers-proxy/defaults/main.yml)
````
nginx_revproxy_sites:                                         # List of sites to reverse proxy
  mgnosov.site:                                                # Domain name
    client_max_body_size: "256M"
    proxy_read_timeout: "360"
    domains:                                                  # List of server_name aliases
      - mgnosov.site
      - www.mgnosov.site
    upstreams:                                                # List of Upstreams
      - {backend_address: 10.2.0.10, backend_port: 80}
    ssl: true                                                 # Set to True if you want to redirect http to https
    hsts_max_age: 63072000                                    # Set HSTS header with max-age defined
    letsencrypt: true                                         # Set to True if you want use letsencrypt
    letsencrypt_email: "mgnosov@mgnosov.site"                 # Set email for letencrypt cert
  gitlab.mgnosov.site:                                        # Domain name
    client_max_body_size: "256M"
    proxy_read_timeout: "360"
    domains:                                                  # List of server_name aliases
      - gitlab.mgnosov.site
    upstreams:                                                # List of Upstreams
      - {backend_address: 10.3.0.11, backend_port: 80}
    ssl: true                                                 # Set to True if you want to redirect http to https
    hsts_max_age: 63072000                                    # Set HSTS header with max-age defined
    letsencrypt: true                                         # Set to True if you want use letsencrypt
    letsencrypt_email: "mgnoso@mgnosov.site"                  # Set email for letencrypt cert
  grafana.mgnosov.site:                                        # Domain name
    client_max_body_size: "256M"
    proxy_read_timeout: "360"
    domains:                                                  # List of server_name aliases
      - grafana.mgnosov.site
    upstreams:                                                # List of Upstreams
      - {backend_address: 10.4.0.6, backend_port: 3000}
    ssl: true                                                 # Set to True if you want to redirect http to https
    hsts_max_age: 63072000                                    # Set HSTS header with max-age defined
    letsencrypt: true                                         # Set to True if you want use letsencrypt
    letsencrypt_email: "mgnoso@mgnosov.site"                  # Set email for letencrypt cert
  prometheus.mgnosov.site:                                        # Domain name
    client_max_body_size: "256M"
    proxy_read_timeout: "360"
    domains:                                                  # List of server_name aliases
      - prometheus.mgnosov.site
    upstreams:                                                # List of Upstreams
      - {backend_address: 10.4.0.6, backend_port: 9090}
    ssl: true                                                 # Set to True if you want to redirect http to https
    hsts_max_age: 63072000                                    # Set HSTS header with max-age defined
    letsencrypt: true                                         # Set to True if you want use letsencrypt
    letsencrypt_email: "mgnoso@mgnosov.site"                  # Set email for letencrypt cert
  alertmanager.mgnosov.site:                                        # Domain name
    client_max_body_size: "256M"
    proxy_read_timeout: "360"
    domains:                                                  # List of server_name aliases
      - alertmanager.mgnosov.site
    upstreams:                                                # List of Upstreams
      - {backend_address: 10.4.0.6, backend_port: 9093}
    ssl: true                                                 # Set to True if you want to redirect http to https
    hsts_max_age: 63072000                                    # Set HSTS header with max-age defined
    letsencrypt: true                                         # Set to True if you want use letsencrypt
    letsencrypt_email: "mgnoso@mgnosov.site"                  # Set email for letencrypt cert

nginx_revproxy_certbot_auto: false

# Remove WebRoot Sites
nginx_revproxy_remove_webroot_sites: false

# De-activate Sites
nginx_revproxy_de_activate_sites: false
````
3. Добавляем IP адреса вирутальных машин в файл [inventory](https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/src/Ansible/inventory)
````
[proxy_server]
revproxy.mgnosov.site
[proxy_server:vars]
ansible_host=84.201.128.39
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

[mysql_db01]
db01.mgnosov.site mysql_server_id=1 mysql_replication_role=master
[mysql_db01:vars]
ansible_host=178.154.229.88
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

[mysql_db02]
db02.mgnosov.site mysql_server_id=2 mysql_replication_role=slave
[mysql_db02:vars]
ansible_host=51.250.85.93
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

[wordpress]
app.mgnosov.site
[wordpress:vars]
ansible_host=178.154.228.124
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

[gitlab]
gitlab.mgnosov.site
[gitlab:vars]
ansible_host=178.154.203.46
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

[runner]
runner.mgnosov.site
[runner:vars]
ansible_host=178.154.228.15
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

[monitoring]
monitoring.mgnosov.site
[monitoring:vars]
ansible_host=178.154.226.158
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
````
4. Выполняем роль.
````
mgnosov@Maksims-MacBook-Pro ansible % ansible-playbook playbook.yml -i inventory

PLAY [proxy_server] ************************************************************

TASK [Gathering Facts] *********************************************************
ok: [revproxy.mgnosov.site]
.....
PLAY RECAP *********************************************************************
revproxy.mgnosov.site      : ok=26   changed=22   unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
````
#### WordPres
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/img/img04.png">

#### GitLab
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/img/img05.png">

#### Grafana
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/img/img06.png">

#### Prometheus
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/img/img07.png">

#### Alertmanager
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/img/img08.png">

### 4. Установка кластера MySQL
#### Результат
Для выполнения данной задачи за основу была взята роль [geerlingguy.mysql](https://github.com/geerlingguy/ansible-role-mysql).  
Пользователя ``wordpress`` добавляем в файл [/my_sql/defaults/main.yml](https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/src/Ansible/roles/my_sql/defaults/main.yml)  
Роли ``master`` и ``slave`` задаются в файле [inventory](https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/src/Ansible/inventory)
````
.....
db01.mgnosov.site mysql_server_id=1 mysql_replication_role=master
.....
db02.mgnosov.site mysql_server_id=1 mysql_replication_role=slave
````
````
mgnosov@Maksims-MacBook-Pro ansible % ansible-playbook playbook.yml -i inventory

PLAY [mysql_db01] **************************************************************

TASK [Gathering Facts] *********************************************************
ok: [db01.mgnosov.site]
.....
PLAY [mysql_db02] **************************************************************

TASK [Gathering Facts] *********************************************************
ok: [db02.mgnosov.site]
.....
PLAY RECAP *********************************************************************
db01.mgnosov.site          : ok=43   changed=1    unreachable=0    failed=0    skipped=18   rescued=0    ignored=0   
db02.mgnosov.site          : ok=49   changed=20   unreachable=0    failed=0    skipped=14   rescued=0    ignored=0   
````
### 5. Установка WordPress
#### Результат
Для выполенения данной задачи за основу была взята роль [ansible-role-wordpress](https://github.com/MakarenaLabs/ansible-role-wordpress)
````
mgnosov@Maksims-MacBook-Pro ansible % ansible-playbook playbook.yml -i inventory

PLAY [wordpress] ***************************************************************

TASK [Gathering Facts] *********************************************************
ok: [app.mgnosov.site]
.....
PLAY RECAP *********************************************************************
app.mgnosov.site           : ok=25   changed=23   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
````
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/img/img09.png">

###6. Установка Gitlab CE и Gitlab Runner
#### Результат
Для выполнения данной задачи за основу были взяты роли:
- [geerlingguy.gitlab](https://github.com/geerlingguy/ansible-role-gitlab)
- [riemers.gitlab-runner](https://github.com/riemers/ansible-gitlab-runner)

Пароль для ``root`` был заранее добавлен в [/gitlab/defaults/main.yml](https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/src/Ansible/roles/gitlab/defaults/main.yml) 

Токен для подключения так же был добавлен в файлы [/gitlab/defaults/main.yml](https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/src/Ansible/roles/gitlab/defaults/main.yml) и [/runner/defaults/main.yml](https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/src/Ansible/roles/runner/defaults/main.yml). Токен был сгенерирован раннее на тестовых прогонах через web-интерфейс Gitlab.
````
mgnosov@Maksims-MacBook-Pro ansible % ansible-playbook playbook.yml -i inventory

PLAY [gitlab] ******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [gitlab.mgnosov.site]
.....
PLAY [runner] ******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [runner.mgnosov.site]
.....
PLAY RECAP *********************************************************************
gitlab.mgnosov.site        : ok=20   changed=13   unreachable=0    failed=0    skipped=3    rescued=0    ignored=0   
runner.mgnosov.site        : ok=88   changed=25   unreachable=0    failed=0    skipped=111  rescued=0    ignored=0 
````
1. Gitlab доступен по https.
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/img/img11.png">
Runner так же подключен.
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/img/img12.png">
2. Добавляем ssh-ключи в переменную ``STAGE_PRIVATE_KEY``
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/img/img13.png">
3. Создаем репозиторий.
````
mgnosov@Maksims-MacBook-Pro final_project % git clone http://gitlab.mgnosov.site/gitlab-instance-165100fe/Monitoring.git
Cloning into 'Monitoring'...
warning: redirecting to https://gitlab.mgnosov.site/gitlab-instance-165100fe/Monitoring.git/
warning: You appear to have cloned an empty repository.
````
3. Настраиваем файл ``.gitlab-ci.yml``
````
# This file is a template, and might need editing before it works on your project.
# This is a sample GitLab CI/CD configuration file that should run without any modifications.
# It demonstrates a basic 3 stage CI/CD pipeline. Instead of real tests or scripts,
# it uses echo commands to simulate the pipeline execution.
#
# A pipeline is composed of independent jobs that run scripts, grouped into stages.
# Stages run in sequential order, but jobs within stages run in parallel.
#
# For more information, see: https://docs.gitlab.com/ee/ci/yaml/index.html#stages
#
# You can copy and paste this template into a new `.gitlab-ci.yml` file.
# You should not add this template to an existing `.gitlab-ci.yml` file by using the `include:` keyword.
#
# To contribute improvements to CI/CD templates, please follow the Development guide at:
# https://docs.gitlab.com/ee/development/cicd/templates.html
# This specific template is located at:
# https://gitlab.com/gitlab-org/gitlab/-/blob/master/lib/gitlab/ci/templates/Getting-Started.gitlab-ci.yml
before_script:
  - 'which ssh-agent || ( apt-get update -y && apt-get install openssh-client -y )'
  - mkdir -p ~/.ssh
  - eval $(ssh-agent -s)
  - '[[ -f /.ssh/id_rsa ]] && echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > /etc/ssh/ssh_config'

stages:          # List of stages for jobs, and their order of execution
#  - build
#  - test
  - deploy

#build-job:       # This job runs in the build stage, which runs first.
#  stage: build
#  script:
#    - echo "Compiling the code..."
#    - echo "Compile complete."

#unit-test-job:   # This job runs in the test stage.
#  stage: test    # It only starts when the job in the build stage completes successfully.
#  script:
#    - echo "Running unit tests... This will take about 60 seconds."
#    - sleep 60
#    - echo "Code coverage is 90%"

#lint-test-job:   # This job also runs in the test stage.
#  stage: test    # It can run at the same time as unit-test-job (in parallel).
#  script:
#    - echo "Linting code... This will take about 10 seconds."
#    - sleep 10
#    - echo "No lint issues found."

deploy-job:      # This job runs in the deploy stage.
  stage: deploy  # It only runs when *both* jobs in the test stage complete successfully.
  environment: production
  script:
    - echo "Deploying application..."
    - ssh-add <(echo "$STAGE_PRIVATE_KEY")
    - ssh -o StrictHostKeyChecking=no mgnosov@app.mgnosov.site "mkdir ~/_tmp"
    - scp -o StrictHostKeyChecking=no -r ./* mgnosov@app.mgnosov.site:~/_tmp
    - ssh -o StrictHostKeyChecking=no mgnosov@app.mgnosov.site "sudo mv /var/www/www.mgnosov.site/wordpress /var/www/www.mgnosov.site/wordpress_old && sudo mv ~/_tmp /var/www/www.mgnosov.site/wordpress"
    - ssh -o StrictHostKeyChecking=no mgnosov@app.mgnosov.site "sudo rm -rf /var/www/www.mgnosov.site/wordpress_old"
    - echo "Application successfully deployed."

````
4. Добавляем изменения в репозиторий.
````
mgnosov@Maksims-MacBook-Pro Monitoring % touch README.md
mgnosov@Maksims-MacBook-Pro Monitoring % git add .
mgnosov@Maksims-MacBook-Pro Monitoring % git commit -m "Commit #2"
[main aeceaea] Commit #2
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 README.md
mgnosov@Maksims-MacBook-Pro Monitoring % git push origin main     
warning: redirecting to https://gitlab.mgnosov.site/gitlab-instance-165100fe/Monitoring.git/
Enumerating objects: 4, done.
Counting objects: 100% (4/4), done.
Delta compression using up to 8 threads
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 347 bytes | 347.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
To http://gitlab.mgnosov.site/gitlab-instance-165100fe/Monitoring.git
   a0b0527..aeceaea  main -> main
````
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/Diploma_Project/img/img14.png">
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/Diploma_Project/img/img15.png">

Проверяем изменения на вирутальной машине.
````
mgnosov@Maksims-MacBook-Pro Monitoring % ssh mgnosov@178.154.228.124
Welcome to Ubuntu 18.04.6 LTS (GNU/Linux 4.15.0-112-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
New release '20.04.5 LTS' available.
Run 'do-release-upgrade' to upgrade to it.

Last login: Fri Oct 14 18:45:08 2022 from 109.197.26.249
mgnosov@app:~$ sudo su
root@app:/home/mgnosov# cd /var/www/www.mgnosov.site/wordpress
root@app:/var/www/www.mgnosov.site/wordpress# ls
README.md  wp-content
````
###7. Установка Prometheus, Alert Manager, Node Exporter и Grafana
#### Результат
Роль ``node_exporter`` добалена ко всем виртуальным машинам из ``inventory``.
Выполняем Playbook целиком с добавленными ролями ``alertmanager``, ``grafana``, ``node_exporter``, ``prometheus``
````
mgnosov@Maksims-MacBook-Pro ansible % ansible-playbook playbook.yml -i inventory
.....
PLAY RECAP *********************************************************************
app.mgnosov.site           : ok=22   changed=8    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
db01.mgnosov.site          : ok=43   changed=1    unreachable=0    failed=0    skipped=18   rescued=0    ignored=0   
db02.mgnosov.site          : ok=43   changed=1    unreachable=0    failed=0    skipped=18   rescued=0    ignored=0   
gitlab.mgnosov.site        : ok=14   changed=1    unreachable=0    failed=0    skipped=7    rescued=0    ignored=0   
monitoring.mgnosov.site    : ok=30   changed=1    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0   
revproxy.mgnosov.site      : ok=21   changed=5    unreachable=0    failed=0    skipped=6    rescued=0    ignored=0   
runner.mgnosov.site        : ok=84   changed=0    unreachable=0    failed=0    skipped=112  rescued=0    ignored=0
````
#### Prometheus
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/Diploma_Project/img/img16.png">

#### Alertmanager
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/Diploma_Project/img/img17.png">

#### Grafana
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/Diploma_Project/img/img18.png">

### Удаляем виртуальные машины:

````
mgnosov@Maksims-MacBook-Pro iac % terraform destroy -auto-approve
.....
Destroy complete! Resources: 12 destroyed.
````
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/Diploma_project/img/img10.png">
