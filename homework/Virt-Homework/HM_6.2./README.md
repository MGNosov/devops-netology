# Домашнее задание к занятию "6.2. SQL" Носов Максим

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

#### Результат
###### содержание compose.yml
````
version: "3.8"
services:
  db:
    image: "postgres:12"
    ports:
      - "5432:5432"
    volumes:
      - /Users/mgnosov/downloads/docker/DATA:/var/lib/postgresql/data
      - /Users/mgnosov/docker/downloads/BACKUP:/media/postgresql/backup
    environment:
      POSTGRES_USER: "test-admin-user"
      POSTGRES_PASSWORD: "1234QWEr"
      POSTGRES_DB: "test_db"
    restart: always

````
````
mgnosov@Maksims-MacBook-Pro docker % docker-compose up -d
Recreating docker_db_1 ... done
mgnosov@Maksims-MacBook-Pro docker % docker ps                
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS                    NAMES
f8bf7801d33a   postgres:12   "docker-entrypoint.s…"   26 seconds ago   Up 24 seconds   0.0.0.0:5432->5432/tcp   docker_db_1
mgnosov@Maksims-MacBook-Pro docker % docker exec -it docker_db_1 bash
````

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db
### Результат
- итоговый список БД после выполнения пунктов выше,
````
test_db=# \l+
                                                                               List of databases
   Name    |      Owner      | Encoding |  Collate   |   Ctype    |            Access privileges            |  Size   | Tablespace |  
              Description                 
-----------+-----------------+----------+------------+------------+-----------------------------------------+---------+------------+--
------------------------------------------
 postgres  | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 |                                         | 7969 kB | pg_default | d
efault administrative connection database
 template0 | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-admin-user"                   +| 7825 kB | pg_default | u
nmodifiable empty database
           |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user" |         |            | 
 template1 | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-admin-user"                   +| 7825 kB | pg_default | d
efault template for new databases
           |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user" |         |            | 
 test_db   | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/"test-admin-user"                  +| 8121 kB | pg_default | 
           |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user"+|         |            | 
           |                 |          |            |            | "test-simple-user"=c/"test-admin-user"  |         |            | 
(4 rows)
````
- описание таблиц (describe)
````
test_db=# \d orders
                                    Table "public.orders"
    Column    |       Type        | Collation | Nullable |              Default               
--------------+-------------------+-----------+----------+------------------------------------
 id           | integer           |           | not null | nextval('orders_id_seq'::regclass)
 наименивание | character varying |           |          | 
 цена         | integer           |           |          | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
test_db=# \d clients
                                       Table "public.clients"
      Column       |       Type        | Collation | Nullable |               Default               
-------------------+-------------------+-----------+----------+-------------------------------------
 id                | integer           |           | not null | nextval('clients_id_seq'::regclass)
 фамилия           | character varying |           |          | 
 страна проживания | character varying |           |          | 
 заказ             | integer           |           |          | 
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "clients_страна проживания_idx" btree ("страна проживания")
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
````
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
````
test_db=# SELECT * FROM information_schema.table_privileges WHERE grantee in ('test-admin-user', 'test-simple-user') and table_name in ('clients', 'orders');
````
- список пользователей с правами над таблицами test_db
````
     grantor     |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
-----------------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 test-admin-user | test-admin-user  | test_db       | public       | orders     | INSERT         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public       | orders     | SELECT         | YES          | YES
 test-admin-user | test-admin-user  | test_db       | public       | orders     | UPDATE         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public       | orders     | DELETE         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public       | orders     | TRUNCATE       | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public       | orders     | REFERENCES     | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public       | orders     | TRIGGER        | YES          | NO
 test-admin-user | test-simple-user | test_db       | public       | orders     | INSERT         | NO           | NO
 test-admin-user | test-simple-user | test_db       | public       | orders     | SELECT         | NO           | YES
 test-admin-user | test-simple-user | test_db       | public       | orders     | UPDATE         | NO           | NO
 test-admin-user | test-simple-user | test_db       | public       | orders     | DELETE         | NO           | NO
 test-admin-user | test-admin-user  | test_db       | public       | clients    | INSERT         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public       | clients    | SELECT         | YES          | YES
 test-admin-user | test-admin-user  | test_db       | public       | clients    | UPDATE         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public       | clients    | DELETE         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public       | clients    | TRUNCATE       | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public       | clients    | REFERENCES     | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public       | clients    | TRIGGER        | YES          | NO
 test-admin-user | test-simple-user | test_db       | public       | clients    | INSERT         | NO           | NO
 test-admin-user | test-simple-user | test_db       | public       | clients    | SELECT         | NO           | YES
 test-admin-user | test-simple-user | test_db       | public       | clients    | UPDATE         | NO           | NO
 test-admin-user | test-simple-user | test_db       | public       | clients    | DELETE         | NO           | NO
````
## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.
#### Результат
````
test_db=# INSERT INTO orders VALUES (1, 'Шоколад', 10), (2, 'Принтер', 3000), (3, 'Книга', 500), (4, 'Монитор', 7000), (5, 'Гитара', 4000);
INSERT 0 5
test_db=# INSERT INTO clients VALUES (1, 'Иванов Иван Иванович', 'USA'), (2, 'Петров Петр Петрович', 'Canada'), (3, 'Иоганн Себастьян Бах', 'Japan'), (4, 'Ронни Джеймс Дио', 'Russia'), (5, 'Ritchie Blackmore', 'Russia');
INSERT 0 5
test_db=# SELECT * FROM orders;
 id | наименивание | цена 
----+--------------+------
  1 | Шоколад      |   10
  2 | Принтер      | 3000
  3 | Книга        |  500
  4 | Монитор      | 7000
  5 | Гитара       | 4000
(5 rows)

test_db=# SELECT * FROM clients;
 id |       фамилия        | страна проживания | заказ 
----+----------------------+-------------------+-------
  1 | Иванов Иван Иванович | USA               |      
  2 | Петров Петр Петрович | Canada            |      
  3 | Иоганн Себастьян Бах | Japan             |      
  4 | Ронни Джеймс Дио     | Russia            |      
  5 | Ritchie Blackmore    | Russia            |      
(5 rows)
````

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказк - используйте директиву `UPDATE`.
#### Результат
````
test_db=# UPDATE clients SET "заказ" = (SELECT id FROM orders WHERE "наименивание"='Книга') WHERE "фамилия"='Иванов Иван Иванович';
UPDATE 1
test_db=# UPDATE clients SET "заказ" = (SELECT id FROM orders WHERE "наименивание"='Монитор') WHERE "фамилия"='Петров Петр Петрович';
UPDATE 1
test_db=# UPDATE clients SET "заказ" = (SELECT id FROM orders WHERE "наименивание"='Гитара') WHERE "фамилия"='Иоганн Себастьян Бах';
UPDATE 1
test_db=# SELECT c.* FROM clients c JOIN orders o ON c.заказ = o.id;
 id |       фамилия        | страна проживания | заказ 
----+----------------------+-------------------+-------
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоганн Себастьян Бах | Japan             |     5
(3 rows)
````
## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

#### Результат
````
EXPLAIN SELECT c.* FROM clients c JOIN orders o ON c.заказ = o.id;
                               QUERY PLAN                               
------------------------------------------------------------------------
 Hash Join  (cost=37.00..57.24 rows=810 width=72)
   Hash Cond: (c."заказ" = o.id)
   ->  Seq Scan on clients c  (cost=0.00..18.10 rows=810 width=72)
   ->  Hash  (cost=22.00..22.00 rows=1200 width=4)
         ->  Seq Scan on orders o  (cost=0.00..22.00 rows=1200 width=4)
(5 rows)
````
EXPLAIN в данном случае показывает план выполнения запроса, какова нагрузка на исполнение запроса, последовательность запроса.
## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

#### Результат
````
root@c7717a6bfb9e:/# pg_dumpall -h localhost -U test-admin-user > /media/postgresql/backup/test_db_2.sql
root@c7717a6bfb9e:/# ls /media/postgresql/backup/
test_db_2.sql  test_db.sql
root@c7717a6bfb9e:/# exit
exit
sh-3.2# docker-compose stop
Stopping docker_db_1 ... done
sh-3.2# docker run --rm -d -e POSTGRES_USER=test-admin-user -e POSTGRES_PASSWORD=1234QWEr -e POSTGRES_DB=test_db -v /Users/mgnosov/downloads/docker/BACKUP:/media/postgresql/backup --name docker_db_2 postgres:12
57a8d274529cd9c4add1fbb7be4168a5f672a2104ac0535cfe372a402636a0ce
sh-3.2# docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS                     PORTS      NAMES
57a8d274529c   postgres:12   "docker-entrypoint.s…"   10 seconds ago   Up 10 seconds              5432/tcp   docker_db_2
c7717a6bfb9e   postgres:12   "docker-entrypoint.s…"   21 hours ago     Exited (0) 3 minutes ago              docker_db_1
95a00c473c12   debian        "bash"                   4 weeks ago      Exited (255) 4 weeks ago              mgnosovdebian
e9071a1cc886   centos        "/bin/bash"              4 weeks ago      Exited (255) 4 weeks ago              mgnosovcentos
sh-3.2# docker exec -it docker_db_2 bash
root@57a8d274529c:/# ls /media/postgresql/backup/
test_db_2.sql  test_db.sql
root@57a8d274529c:/# psql -h localhost -U test-admin-user -f /media/postgresql/backup/test_db_2.sql test_db
oot@57a8d274529c:/# psql -h localhost -U test-admin-user test_db
psql (12.11 (Debian 12.11-1.pgdg110+1))
Type "help" for help.

test_db=# \d orders
                                    Table "public.orders"
    Column    |       Type        | Collation | Nullable |              Default               
--------------+-------------------+-----------+----------+------------------------------------
 id           | integer           |           | not null | nextval('orders_id_seq'::regclass)
 наименивание | character varying |           |          | 
 цена         | integer           |           |          | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

test_db=# SELECT * FROM orders
test_db-# ;
 id | наименивание | цена 
----+--------------+------
  1 | Шоколад      |   10
  2 | Принтер      | 3000
  3 | Книга        |  500
  4 | Монитор      | 7000
  5 | Гитара       | 4000
(5 rows)

test_db=# SELECT * FROM clients;
 id |       фамилия        | страна проживания | заказ 
----+----------------------+-------------------+-------
  4 | Ронни Джеймс Дио     | Russia            |      
  5 | Ritchie Blackmore    | Russia            |      
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоганн Себастьян Бах | Japan             |     5
(5 rows)

test_db=# 
````
---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---