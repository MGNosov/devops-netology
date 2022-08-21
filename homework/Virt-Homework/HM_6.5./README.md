# Домашнее задание к занятию "6.5. Elasticsearch" Носов Максим

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
##### Результат
````
FROM centos:7

EXPOSE 9200 9300

EXPOSE 5601 5601

RUN yum install wget -y

RUN yum install perl-Digest-SHA1 -y

RUN cd /usr/local/src

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.3.3-linux-x86_64.tar.gz

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.3.3-linux-x86_64.tar.gz.sha512

RUN sha512sum -c elasticsearch-8.3.3-linux-x86_64.tar.gz.sha512

RUN tar -xzf elasticsearch-8.3.3-linux-x86_64.tar.gz

RUN mkdir /usr/local/elasticsearch

RUN mv elasticsearch-8.3.3 /usr/local/elasticsearch

RUN cd /usr/local/elasticsearch/

RUN useradd elasticsearch

RUN chown -R elasticsearch:elasticsearch /usr/local/elasticsearch

RUN mkdir /var/lib/elasticsearch && chown elasticsearch:elasticsearch /var/lib/elasticsearch/

RUN mkdir /var/log/elasticsearch && chown elasticsearch:elasticsearch /var/log/elasticsearch/

ENV ES_HOME="/usr/local/elasticsearch/elasticsearch-8.3.3"

ENV ES_PATH_CONF="/usr/local/elasticsearch/elasticsearch-8.3.3/config"

RUN cd /usr/local/elasticsearch

RUN wget https://artifacts.elastic.co/downloads/kibana/kibana-8.3.3-linux-x86_64.tar.gz

RUN wget https://artifacts.elastic.co/downloads/kibana/kibana-8.3.3-linux-x86_64.tar.gz.sha512

RUN sha512sum -c kibana-8.3.3-linux-x86_64.tar.gz.sha512

RUN tar -xzf kibana-8.3.3-linux-x86_64.tar.gz

RUN mkdir /usr/local/kibana

RUN mv kibana-8.3.3 /usr/local/kibana

WORKDIR ${ES_HOME}
````
````
mgnosov@Maksims-MacBook-Pro docker % docker build . -t mgnosov/elastic:8.3
mgnosov@Maksims-MacBook-Pro docker % docker run -d -p 9200:9200 -p 9300:9300 -p 5601:5601 mgnosov/elastic:8.3
mgnosov@Maksims-MacBook-Pro docker % docker push mgnosov/elastic:8.3
````
- ссылку на образ в репозитории dockerhub
[hub.docker.com](https://hub.docker.com/r/mgnosov/elastic)
- ответ `elasticsearch` на запрос пути `/` в json виде
````
mgnosov@Maksims-MacBook-Pro docker % curl -X GET "localhost:9200"
{
  "name" : "netology-test",
  "cluster_name" : "my-application",
  "cluster_uuid" : "Nj1rV7T_QvOHFgXtRl_vdA",
  "version" : {
    "number" : "8.3.3",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "801fed82df74dbe537f89b71b098ccaff88d2c56",
    "build_date" : "2022-07-23T19:30:09.227964828Z",
    "build_snapshot" : false,
    "lucene_version" : "9.2.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
````

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |
````
mgnosov@Maksims-MacBook-Pro docker % curl -X PUT localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-1"}%               
mgnosov@Maksims-MacBook-Pro docker % curl -X PUT localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 2,  "number_of_replicas": 1 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-2"}%               
mgnosov@Maksims-MacBook-Pro docker % curl -X PUT localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 4,  "number_of_replicas": 2 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-3"}%
````

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.
##### Результат
````
mgnosov@Maksims-MacBook-Pro docker % curl -X GET "http://localhost:9200/_cat/indices?v"
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
yellow open   ind-3 foN4WJ9nTnW7uTwX4WsUQg   4   2          0            0       413b           413b
yellow open   ind-2 f-YExGhPSgG6ArL1HwecpQ   2   1          0            0       450b           450b
green  open   ind-1 85fooDcCRJaApSYMHDODaw   1   0          0            0       225b           225b
````
Получите состояние кластера `elasticsearch`, используя API.
##### Результат
````              
mgnosov@Maksims-MacBook-Pro docker % curl -X GET "localhost:9200/_cluster/health?pretty"
{
  "cluster_name" : "my-application",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 9,
  "active_shards" : 9,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 47.368421052631575
}
````

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?
##### Ответ
``Потому, что шарды и реплики находятся на одной машине. Так быть не должно.``

Удалите все индексы.
##### Результат
````
mgnosov@Maksims-MacBook-Pro docker % curl -X DELETE 'http://localhost:9200/ind-1?pretty'
{
  "acknowledged" : true
}
mgnosov@Maksims-MacBook-Pro docker % curl -X DELETE 'http://localhost:9200/ind-2?pretty'  
{
  "acknowledged" : true
}
mgnosov@Maksims-MacBook-Pro docker % curl -X DELETE 'http://localhost:9200/ind-3?pretty'
{
  "acknowledged" : true
}
mgnosov@Maksims-MacBook-Pro docker % curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index uuid pri rep docs.count docs.deleted store.size pri.store.size
````

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.
##### Результат
````
mgnosov@Maksims-MacBook-Pro docker % curl -XPOST "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'{"type": "fs", "settings": { "location":"/usr/local/elasticsearch/elasticsearch-8.3.3/snapshots" }}'

{
  "acknowledged" : true
}
mgnosov@Maksims-MacBook-Pro docker % curl -L "http://localhost:9200/_snapshot/netology_backup?pretty"
{
  "netology_backup" : {
    "type" : "fs",
    "settings" : {
      "location" : "/usr/local/elasticsearch/elasticsearch-8.3.3/snapshots"
    }
  }
}
````

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.
##### Результат
````
mgnosov@Maksims-MacBook-Pro docker % curl -X PUT "localhost:9200/test" -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"test"}%                
mgnosov@Maksims-MacBook-Pro docker % curl -L "localhost:9200/test?pretty"
{
  "test" : {
    "aliases" : { },
    "mappings" : { },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "1",
        "provided_name" : "test",
        "creation_date" : "1660919810572",
        "number_of_replicas" : "0",
        "uuid" : "A5O1CTTHSreuq61ZQk3vzQ",
        "version" : {
          "created" : "8030399"
        }
      }
    }
  }
}
````

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.
##### Результат
````
mgnosov@Maksims-MacBook-Pro docker % curl -X PUT "localhost:9200/_snapshot/netology_backup/snapshot_1?wait_for_completion=true&pretty"
{
  "snapshot" : {
    "snapshot" : "snapshot_1",
    "uuid" : "89YqAUTrSO2tN_2pCvsUdg",
    "repository" : "netology_backup",
    "version_id" : 8030399,
    "version" : "8.3.3",
    "indices" : [
      "test",
      ".security-7",
      ".geoip_databases"
    ],
    "data_streams" : [ ],
    "include_global_state" : true,
    "state" : "SUCCESS",
    "start_time" : "2022-08-19T14:45:54.309Z",
    "start_time_in_millis" : 1660920354309,
    "end_time" : "2022-08-19T14:45:55.312Z",
    "end_time_in_millis" : 1660920355312,
    "duration_in_millis" : 1003,
    "failures" : [ ],
    "shards" : {
      "total" : 3,
      "failed" : 0,
      "successful" : 3
    },
    "feature_states" : [
      {
        "feature_name" : "geoip",
        "indices" : [
          ".geoip_databases"
        ]
      },
      {
        "feature_name" : "security",
        "indices" : [
          ".security-7"
        ]
      }
    ]
  }
}
mgnosov@Maksims-MacBook-Pro docker % docker exec -it 1ea4cf81bd24f73b97ac3aaf7863362b1ef5cc1b36f01ecb786096d3e978e297 /bin/bash
[root@1ea4cf81bd24 elasticsearch-8.3.3]# cd /usr/local/elasticsearch/elasticsearch-8.3.3/snapshots
[root@1ea4cf81bd24 snapshots]# ll
total 36
-rw-rw-r-- 1 elasticsearch elasticsearch  1095 Aug 19 14:45 index-0
-rw-rw-r-- 1 elasticsearch elasticsearch     8 Aug 19 14:45 index.latest
drwxrwxr-x 5 elasticsearch elasticsearch  4096 Aug 19 14:45 indices
-rw-rw-r-- 1 elasticsearch elasticsearch 18467 Aug 19 14:45 meta-89YqAUTrSO2tN_2pCvsUdg.dat
-rw-rw-r-- 1 elasticsearch elasticsearch   384 Aug 19 14:45 snap-89YqAUTrSO2tN_2pCvsUdg.dat
````

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.
##### Результат
````
mgnosov@Maksims-MacBook-Pro docker % curl -X DELETE "http://localhost:9200/test?pretty"                                        
{
  "acknowledged" : true
}
mgnosov@Maksims-MacBook-Pro docker % curl -X PUT "localhost:9200/test-2?pretty" -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}

mgnosov@Maksims-MacBook-Pro docker % curl -X GET "http://localhost:9200/_cat/indices?v"
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 w_mNIAGPRi6EqEGLHARoDQ   1   0          0            0       225b           225b
````

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.
##### Результат
````
mgnosov@Maksims-MacBook-Pro docker % curl -X POST "localhost:9200/_snapshot/netology_backup/snapshot_1/_restore?pretty" -H 'Content-Type: application/json' -d'{"include_global_state":true}'
{
  "accepted" : true
}
mgnosov@Maksims-MacBook-Pro docker % curl -X GET "http://localhost:9200/_cat/indices?v"
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test   t4dJ_2gORq6-hN-i8Es_pg   1   0          0            0       225b           225b
green  open   test-2 w_mNIAGPRi6EqEGLHARoDQ   1   0          0            0       225b           225b

````

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---