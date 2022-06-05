# Курсовая работа по итогам модуля "DevOps и системное администрирование" Носов Максим

Курсовая работа необходима для проверки практических навыков, полученных в ходе прохождения курса "DevOps и системное администрирование".

Мы создадим и настроим виртуальное рабочее место. Позже вы сможете использовать эту систему для выполнения домашних заданий по курсу

## Задание

1. Создайте виртуальную машину Linux.
2. Установите ufw и разрешите к этой машине сессии на порты 22 и 443, при этом трафик на интерфейсе localhost (lo) должен ходить свободно на все порты.
3. Установите hashicorp vault ([инструкция по ссылке](https://learn.hashicorp.com/tutorials/vault/getting-started-install?in=vault/getting-started#install-vault)).
4. Cоздайте центр сертификации по инструкции ([ссылка](https://learn.hashicorp.com/tutorials/vault/pki-engine?in=vault/secrets-management)) и выпустите сертификат для использования его в настройке веб-сервера nginx (срок жизни сертификата - месяц).
5. Установите корневой сертификат созданного центра сертификации в доверенные в хостовой системе.
6. Установите nginx.
7. По инструкции ([ссылка](https://nginx.org/en/docs/http/configuring_https_servers.html)) настройте nginx на https, используя ранее подготовленный сертификат:
  - можно использовать стандартную стартовую страницу nginx для демонстрации работы сервера;
  - можно использовать и другой html файл, сделанный вами;
8. Откройте в браузере на хосте https адрес страницы, которую обслуживает сервер nginx.
9. Создайте скрипт, который будет генерировать новый сертификат в vault:
  - генерируем новый сертификат так, чтобы не переписывать конфиг nginx;
  - перезапускаем nginx для применения нового сертификата.
10. Поместите скрипт в crontab, чтобы сертификат обновлялся какого-то числа каждого месяца в удобное для вас время.

### Результат

##### Процесс установки и настройки ufw
``````
root@vagrant:/home/vagrant# ufw default deny incoming
Default incoming policy changed to 'deny'
(be sure to update your rules accordingly)
root@vagrant:/home/vagrant# ufw allow outgoing
ERROR: Could not find a profile matching 'outgoing'
root@vagrant:/home/vagrant# ufw allow 22
Rules updated
root@vagrant:/home/vagrant# ufw allow 443
Rules updated
root@vagrant:/home/vagrant# ufw allow in on lo to any
Rules updated
root@vagrant:/home/vagrant# ufw allow out on lo to any
Rules updated
root@vagrant:/home/vagrant# ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup
root@vagrant:/home/vagrant# ufw status
Status: active

To                         Action      From
--                         ------      ----
22                         ALLOW       Anywhere                  
443                        ALLOW       Anywhere                  
Anywhere on lo             ALLOW       Anywhere                  

Anywhere                   ALLOW OUT   Anywhere on lo            

``````
### Процесс установки и выпуска сертификата с помощью hashicorp vault
#### Установка Hashicorp Vault
``````
root@vagrant:/home/vagrant# sudo apt update && sudo apt install gpg
root@vagrant:/home/vagrant# wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null
root@vagrant:/home/vagrant# gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
root@vagrant:/home/vagrant# echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
root@vagrant:/home/vagrant# sudo apt update && sudo apt install vault
root@vagrant:/home/vagrant# vault
Usage: vault <command> [args]

Common commands:
    read        Read data and retrieves secrets
    write       Write data, configuration, and secrets
    delete      Delete secrets and configuration
    list        List data or secrets
    login       Authenticate locally
    agent       Start a Vault agent
    server      Start a Vault server
    status      Print seal and HA status
    unwrap      Unwrap a wrapped secret

Other commands:
    audit                Interact with audit devices
    auth                 Interact with auth methods
    debug                Runs the debug command
    kv                   Interact with Vault's Key-Value storage
    lease                Interact with leases
    monitor              Stream log messages from a Vault server
    namespace            Interact with namespaces
    operator             Perform operator-specific tasks
    path-help            Retrieve API help for paths
    plugin               Interact with Vault plugins and catalog
    policy               Interact with policies
    print                Prints runtime configurations
    secrets              Interact with secrets engines
    ssh                  Initiate an SSH session
    token                Interact with tokens
    version-history      Prints the version history of the target Vault server
``````

#### Запуск сервера
``````
root@vagrant:/home/vagrant# vault server -dev -dev-root-token-id root
==> Vault server configuration:

             Api Address: http://127.0.0.1:8200
                     Cgo: disabled
         Cluster Address: https://127.0.0.1:8201
              Go Version: go1.17.9
              Listener 1: tcp (addr: "127.0.0.1:8200", cluster address: "127.0.0.1:8201", max_request_duration: "1m30s", max_request_size: "33554432", tls: "disabled")
               Log Level: info
                   Mlock: supported: true, enabled: false
           Recovery Mode: false
                 Storage: inmem
                 Version: Vault v1.10.3
             Version Sha: af866591ee60485f05d6e32dd63dde93df686dfb

==> Vault server started! Log data will stream in below:

2022-06-03T13:41:58.506Z [INFO]  proxy environment: http_proxy="" https_proxy="" no_proxy=""
2022-06-03T13:41:58.506Z [WARN]  no `api_addr` value specified in config or in VAULT_API_ADDR; falling back to detection if possible, but this value should be manually set
2022-06-03T13:41:58.506Z [INFO]  core: Initializing versionTimestamps for core
2022-06-03T13:41:58.507Z [INFO]  core: security barrier not initialized
2022-06-03T13:41:58.508Z [INFO]  core: security barrier initialized: stored=1 shares=1 threshold=1
2022-06-03T13:41:58.509Z [INFO]  core: post-unseal setup starting
2022-06-03T13:41:58.511Z [INFO]  core: loaded wrapping token key
2022-06-03T13:41:58.512Z [INFO]  core: Recorded vault version: vault version=1.10.3 upgrade time="2022-06-03 13:41:58.512001499 +0000 UTC"
2022-06-03T13:41:58.512Z [INFO]  core: successfully setup plugin catalog: plugin-directory=""
2022-06-03T13:41:58.512Z [INFO]  core: no mounts; adding default mount table
2022-06-03T13:41:58.513Z [INFO]  core: successfully mounted backend: type=cubbyhole path=cubbyhole/
2022-06-03T13:41:58.513Z [INFO]  core: successfully mounted backend: type=system path=sys/
2022-06-03T13:41:58.514Z [INFO]  core: successfully mounted backend: type=identity path=identity/
2022-06-03T13:41:58.516Z [INFO]  core: successfully enabled credential backend: type=token path=token/ namespace="ID: root. Path: "
2022-06-03T13:41:58.516Z [INFO]  core: restoring leases
2022-06-03T13:41:58.516Z [INFO]  rollback: starting rollback manager
2022-06-03T13:41:58.518Z [INFO]  expiration: lease restore complete
2022-06-03T13:41:58.518Z [INFO]  identity: entities restored
2022-06-03T13:41:58.518Z [INFO]  identity: groups restored
2022-06-03T13:41:58.960Z [INFO]  core: post-unseal setup complete
2022-06-03T13:41:58.960Z [INFO]  core: root token generated
2022-06-03T13:41:58.960Z [INFO]  core: pre-seal teardown starting
2022-06-03T13:41:58.960Z [INFO]  rollback: stopping rollback manager
2022-06-03T13:41:58.960Z [INFO]  core: pre-seal teardown complete
2022-06-03T13:41:58.961Z [INFO]  core.cluster-listener.tcp: starting listener: listener_address=127.0.0.1:8201
2022-06-03T13:41:58.961Z [INFO]  core.cluster-listener: serving cluster requests: cluster_listen_address=127.0.0.1:8201
2022-06-03T13:41:58.961Z [INFO]  core: post-unseal setup starting
2022-06-03T13:41:58.961Z [INFO]  core: loaded wrapping token key
2022-06-03T13:41:58.961Z [INFO]  core: successfully setup plugin catalog: plugin-directory=""
2022-06-03T13:41:58.961Z [INFO]  core: successfully mounted backend: type=system path=sys/
2022-06-03T13:41:58.962Z [INFO]  core: successfully mounted backend: type=identity path=identity/
2022-06-03T13:41:58.962Z [INFO]  core: successfully mounted backend: type=cubbyhole path=cubbyhole/
2022-06-03T13:41:58.962Z [INFO]  core: successfully enabled credential backend: type=token path=token/ namespace="ID: root. Path: "
2022-06-03T13:41:58.963Z [INFO]  rollback: starting rollback manager
2022-06-03T13:41:58.963Z [INFO]  core: restoring leases
2022-06-03T13:41:58.963Z [INFO]  identity: entities restored
2022-06-03T13:41:58.963Z [INFO]  identity: groups restored
2022-06-03T13:41:58.963Z [INFO]  expiration: lease restore complete
2022-06-03T13:41:58.963Z [INFO]  core: post-unseal setup complete
2022-06-03T13:41:58.963Z [INFO]  core: vault is unsealed
2022-06-03T13:41:58.965Z [INFO]  expiration: revoked lease: lease_id=auth/token/root/h391f605a1287259ac8415afeb359a2f59afced83b8188abe2592c78382a7b57e
2022-06-03T13:41:58.970Z [INFO]  core: successful mount: namespace="" path=secret/ type=kv
2022-06-03T13:41:58.978Z [INFO]  secrets.kv.kv_7e2ef885: collecting keys to upgrade
2022-06-03T13:41:58.978Z [INFO]  secrets.kv.kv_7e2ef885: done collecting keys: num_keys=1
2022-06-03T13:41:58.978Z [INFO]  secrets.kv.kv_7e2ef885: upgrading keys finished
WARNING! dev mode is enabled! In this mode, Vault runs entirely in-memory
and starts unsealed with a single unseal key. The root token is already
authenticated to the CLI, so you can immediately begin using Vault.

You may need to set the following environment variable:

    $ export VAULT_ADDR='http://127.0.0.1:8200'

The unseal key and root token are displayed below in case you want to
seal/unseal the Vault or re-authenticate.

Unseal Key: 9rTCewY1m6Io9zUllhgSKUhaC92BGOqD+rs3VITJbOo=
Root Token: root

Development mode should NOT be used in production installations!


root@vagrant:/home/vagrant# export VAULT_ADDR=http://127.0.0.1:8200
root@vagrant:/home/vagrant# export VAULT_TOKEN=root
``````
#### Generate root CA
``````
root@vagrant:/home/vagrant# vault secrets enable \
> -path=pki_root_ca \
> -description="PKI Root CA" \
> -max-lease-ttl="262800h" \
> pki
Success! Enabled the pki secrets engine at: pki_root_ca/
root@vagrant:/home/vagrant# vault write -format=json pki_root_ca/root/generate/internal \
> common_name="Root Certificate Authority" \
> country="Russian Federation" \
> locality="Moscow" \
> street_address="Tverskaya st 1" \
> postal_code="121000" \
> organization="JSC Chamomile" \
> ou="IT" \
> ttl="87600" > pki-root-ca.json
root@vagrant:/home/vagrant# cat pki-root-ca.json | jq -r .data.certificate > CA_root.crt
root@vagrant:/home/vagrant# vault write pki_root_ca/config/urls \
> issuing_certificates="$VAULT_ADDR/v1/pki_root_ca/ca" \
> crl_distribution_points="$VAULT_ADDR/v1/pki_root_ca/crl"
Success! Data written to: pki_root_ca/config/urls
``````
#### Generate intermediate CA
``````
root@vagrant:/home/vagrant# vault secrets enable \
> -path=pki_int_ca \
> -description="PKI Intermediate CA" \
> -max-lease-ttl="43800h" \
> pki
Success! Enabled the pki secrets engine at: pki_int_ca/
root@vagrant:/home/vagrant# vault write -format=json pki_int_ca/intermediate/generate/internal \
> common_name="Intermediate CA" \
> country="Russian Federation" \
> locality="Moscow" \
> street_address="Tverskaya st 1" \
> postal_code="121000" \
> organization="JSC Chamomile" \
> ou="IT" \
> ttl="43800h" | jq -r '.data.csr' > pki_intermediate_ca.csr
root@vagrant:/home/vagrant# vault write -format=json pki_root_ca/root/sign-intermediate csr=@pki_intermediate_ca.csr \
> country="Russian Federation" \
> locality="Moscow" \
> street_address="Tverskaya st 1" \
> postal_code="121000" \
> organization="JSC Chamomile" \
> ou="IT" \
> format=pem_bundle \
> ttl="43800h" | jq -r '.data.certificate' > CA_intermediate.crt
root@vagrant:/home/vagrant# vault write pki_int_ca/intermediate/set-signed \
> certificate=@CA_intermediate.crt
Success! Data written to: pki_int_ca/intermediate/set-signed
root@vagrant:/home/vagrant# vault write pki_int_ca/config/urls \
> issuing_certifiates="$VAULT_ADDR/v1/pki_int_ca/ca" \
> crl_distribution_points="$VAULT_ADDR/v1/pki_int_ca/crl"
Success! Data written to: pki_int_ca/config/urls
``````
#### Create a role
````
root@vagrant:/home/vagrant# vault write pki_int_ca/roles/example-dot-com \
> country="Russian Federation" \
> locality="Moscow" \
> street_address="Tverskaya st 1" \
> organization="JSC Chamomile" \
> ou="IT" \
> allow_domains="example.com" \
> allow_subdomains=true \
> max_ttl="43800h" \
> key_bits="2048" \
> key_type="rsa" \
> allow_any_name=true \
> allow_bare_domains=false \
> allow_glob_domain=false \
> allow_ip_sans=true \
> allow_localhost=false \
> client_flag=false \
> server_flag=true \
> enforce_hostname=true \
> key_usage="DigitalSignature,KeyEncipherment" \
> ext_key_usage="ServerAuth" \
> require_cn=true
Success! Data written to: pki_int_ca/roles/example-dot-com
````
#### Request certificate
``````
root@vagrant:/home/vagrant# vault write -format=json pki_int_ca/issue/example-dot-com \
> common_name="mgnosov.example.com" \
> alt_names="mgnosov.example.com" \
> ttl="720h" > certificate.crt
root@vagrant:/home/vagrant# cat certificate.crt | jq -r .data.certificate > mgnosov.example.crt
root@vagrant:/home/vagrant# cat certificate.crt | jq -r .data.issuing_ca >> mgnosov.example.crt
root@vagrant:/home/vagrant# cat certificate.crt | jq -r .data.private_key > mgnosov.example.key
root@vagrant:/home/vagrant# cat certificate.crt | grep serial_number
    "serial_number": "56:dd:72:c3:5d:7c:8f:f2:48:62:5b:71:4e:30:76:a9:c0:fb:33:72"
``````

#### Установка сертификата в доверенные
``````
Копирую корневой сертификат из виртуальной машини в хостовую
root@vagrant:/home/vagrant# cp CA_root.crt /vagrant 
root@vagrant:/home/vagrant# cat pki-root-ca.json | grep serial_number
    "serial_number": "6d:23:36:2a:43:ad:61:57:ce:de:e9:4d:47:be:12:28:5f:3c:a8"
``````
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main/Course_Work/img/img00.png">

#### Процесс установки и настройки сервера nginx
``````
root@vagrant:/home/vagrant# apt install nginx
root@vagrant:/home/vagrant# systemctl status nginx
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
     Active: active (running) since Sat 2022-06-04 14:40:40 UTC; 18s ago
       Docs: man:nginx(8)
   Main PID: 16015 (nginx)
      Tasks: 3 (limit: 1071)
     Memory: 5.6M
     CGroup: /system.slice/nginx.service
             ├─16015 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
             ├─16016 nginx: worker process
             └─16017 nginx: worker process

root@vagrant:/home/vagrant# mkdir /etc/nginx/ssl
root@vagrant:/home/vagrant# cp mgnosov.example.crt /etc/nginx/ssl/
root@vagrant:/home/vagrant# cp mgnosov.example.key /etc/nginx/ssl/
root@vagrant:/home/vagrant# nano /etc/nginx/sites-enabled/default

server {
        listen 80 default_server;
        listen [::]:80 default_server;

        # SSL configuration
        #
        listen 443 ssl default_server;
        listen [::]:443 ssl default_server;
        ssl_certificate /etc/nginx/ssl/mgnosov.example.crt;
        ssl_certificate_key /etc/nginx/ssl/mgnosov.example.key;
        #
        # Note: You should disable gzip for SSL traffic.
        
root@vagrant:/home/vagrant# systemctl restart nginx
root@vagrant:/home/vagrant# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
``````
#####Страница сервера nginx в браузере хоста не содержит предупреждений
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main//Course_Work/img/img01.png">

#### Скрипт генерации нового сертификата работает (сертификат сервера ngnix должен быть "зеленым")
``````
#!/bin/bash
vault write -format=json pki_int_ca/issue/example-dot-com \
common_name="mgnosov.example.com" \
alt_names="mgnosov.example.com" \
ttl="720h" > certificate_nginx.crt
cat certificate_nginx.crt | jq -r '.data.certificate' > /etc/nginx/ssl/mgnosov_new.example.crt
cat certificate_nginx.crt | jq -r '.data.issuing_ca' >> /etc/nginx/ssl/mgnosov_new.example.crt
cat certificate_nginx.crt | jq -r '.data.private_key' > /etc/nginx/ssl/mgnosov_new.example.key
systemctl restart nginx
cat certificate_nginx.crt | grep serial_number>&1
``````
####### Запускаем и проверяем скрипт
``````
root@vagrant:/home/vagrant# ./cert_script.sh
    "serial_number": "49:d2:9f:bb:cb:d8:39:fd:39:13:62:b5:96:74:55:11:93:78:ee:4c"
``````
<img align="cetner" src="https://github.com/MGNosov/devops-netology/blob/main//Course_Work/img/img02.png">

#### Crontab работает (выберите число и время так, чтобы показать что crontab запускается и делает что надо)
``````
 root@vagrant:/home/vagrant# crontab -e
 GNU nano 4.8                                                     /tmp/crontab.nKJK1S/crontab                                                      Modified  
# Edit this file to introduce tasks to be run by cron.
# 
# Each task to run has to be defined through a single line
# indicating with different fields when the task will be run
# and what command to run for the task
# 
# To define the time you can provide concrete values for
# minute (m), hour (h), day of month (dom), month (mon),
# and day of week (dow) or use '*' in these fields (for 'any').
# 
# Notice that tasks will be started based on the cron's system
# daemon's notion of time and timezones.
# 
# Output of the crontab jobs (including errors) is sent through
# email to the user the crontab file belongs to (unless redirected).
# 
# For example, you can run a backup of all your user accounts
# at 5 a.m every week with:
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
# 
# For more information see the manual pages of crontab(5) and cron(8)
# 
43 10 5 * * root /bin/bash /home/vagrant/cert_script.sh > /dev/null 2>&1

root@vagrant:/home/vagrant# grep CRON /var/log/syslog
* * * *
Jun  5 10:43:01 vagrant CRON[18884]: (root) CMD (root /bin/bash /home/vagrant/cert_script.sh > /dev/null 2>&1)
``````
## Как сдавать курсовую работу

Курсовую работу выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Также вы можете выполнить задание в [Google Docs](https://docs.google.com/document/u/0/?tgif=d) и отправить в личном кабинете на проверку ссылку на ваш документ.
Если необходимо прикрепить дополнительные ссылки, просто добавьте их в свой Google Docs.

Перед тем как выслать ссылку, убедитесь, что ее содержимое не является приватным (открыто на комментирование всем, у кого есть ссылка), иначе преподаватель не сможет проверить работу. 
Ссылка на инструкцию [Как предоставить доступ к файлам и папкам на Google Диске](https://support.google.com/docs/answer/2494822?hl=ru&co=GENIE.Platform%3DDesktop).
