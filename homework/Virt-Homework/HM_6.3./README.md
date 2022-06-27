# Домашнее задание к занятию "6.3. MySQL" Носов Максим

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.

#### Результат
###### Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.
````
mgnosov@Maksims-MacBook-Pro ~ % docker run --rm --name mysql \
> -e MYSQL_DATABASE=mysql_db \
> -e MYSQL_ROOT_PASSWORD=1234QWEr \
> -v /Users/mgnosov/downloads/docker/MySQL_DATA:/var/lib/mysql \
> -v /Users/mgnosov/downloads/docker/BACKUP:/media/mysql/backup \
> -p 3306:3306 \
> -d mysql:8.0
Unable to find image 'mysql:8.0' locally
8.0: Pulling from library/mysql
Digest: sha256:bed914af3f2dea400c4bc83136d6b3a8cf7edcf96f5c08bbbdec8a10cc021a5d
Status: Downloaded newer image for mysql:8.0
eec275af3ed7e647ed2817e82147220d67a9b5290762db1ad49f1cffc943b136
mgnosov@Maksims-MacBook-Pro ~ % docker ps
CONTAINER ID   IMAGE       COMMAND                  CREATED          STATUS          PORTS                               NAMES
eec275af3ed7   mysql:8.0   "docker-entrypoint.s…"   18 seconds ago   Up 18 seconds   0.0.0.0:3306->3306/tcp, 33060/tcp   mysql
mgnosov@Maksims-MacBook-Pro ~ % docker exec -it mysql bash
root@eec275af3ed7:/#
````
###### Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и восстановитесь из него.
````
root@eec275af3ed7:/# mysql -u root -p mysql_db < /media/mysql/backup/test_dump.sql
Enter password: 
root@eec275af3ed7:/# 
````
###### Перейдите в управляющую консоль `mysql` внутри контейнера.
````
root@eec275af3ed7:/# mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 12
Server version: 8.0.29 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
````
###### Используя команду `\h` получите список управляющих команд.
````
mysql> \h

For information about MySQL products and services, visit:
   http://www.mysql.com/
For developer information, including the MySQL Reference Manual, visit:
   http://dev.mysql.com/
To buy MySQL Enterprise support, training, or other products, visit:
   https://shop.mysql.com/

List of all MySQL commands:
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
clear     (\c) Clear the current input statement.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter.
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to mysql server, display result vertically.
exit      (\q) Exit mysql. Same as quit.
go        (\g) Send command to mysql server.
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Don't write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash.
source    (\.) Execute an SQL script file. Takes a file name as an argument.
status    (\s) Get status information from the server.
system    (\!) Execute a system shell command.
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
warnings  (\W) Show warnings after every statement.
nowarning (\w) Don't show warnings after every statement.
resetconnection(\x) Clean session context.
query_attributes Sets string parameters (name1 value1 name2 value2 ...) for the next query to pick up.
ssl_session_data_print Serializes the current SSL session data to stdout or file

For server side help, type 'help contents'

mysql> \s
--------------
mysql  Ver 8.0.29 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:		12
Current database:	
Current user:		root@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		8.0.29 MySQL Community Server - GPL
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	latin1
Conn.  characterset:	latin1
UNIX socket:		/var/run/mysqld/mysqld.sock
Binary data as:		Hexadecimal
Uptime:			1 hour 19 min 41 sec

Threads: 2  Questions: 51  Slow queries: 0  Opens: 159  Flush tables: 3  Open tables: 77  Queries per second avg: 0.010
--------------

mysql> 
````
###### Подключитесь к восстановленной БД и получите список таблиц из этой БД.
````
mysql> SHOW DATABASES
    -> ;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| mysql_db           |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.01 sec)

mysql> USE mysql_db
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> 
````
###### **Приведите в ответе** количество записей с `price` > 300.
````
mysql> SHOW TABLES;
+--------------------+
| Tables_in_mysql_db |
+--------------------+
| orders             |
+--------------------+
1 row in set (0.01 sec)

mysql> SELECT COUNT(*) FROM orders WHERE price > 300;
+----------+
| COUNT(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)
````

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

#### Результат
###### Создайте пользователя test в БД c паролем test-pass, используя:...
````
mysql> CREATE USER 'test'@'localhost'
    -> IDENTIFIED WITH mysql_native_password BY 'test-pass'
    -> WITH MAX_CONNECTIONS_PER_HOUR 100
    -> PASSWORD EXPIRE INTERVAL 180 DAY
    -> FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 2
    -> ATTRIBUTE '{"first_name":"James", "last_name": "Pretty"}';
Query OK, 0 rows affected (0.08 sec)

mysql> 
````
###### Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
````
mysql> GRANT SELECT ON test_db.* TO test@localhost;
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql> 
````
###### Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и **приведите в ответе к задаче**.
````
mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER = 'test';
+------+-----------+------------------------------------------------+
| USER | HOST      | ATTRIBUTE                                      |
+------+-----------+------------------------------------------------+
| test | localhost | {"last_name": "Pretty", "first_name": "James"} |
+------+-----------+------------------------------------------------+
1 row in set (0.01 sec)

mysql> 
````
## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`
#### Результат
###### Установите профилирование `SET profiling = 1`.
````
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql> 
````
###### Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.
````
mysql> SELECT table_schema,table_name,engine FROM information_schema.tables WHERE table_schema = DATABASE();
+--------------+------------+--------+
| TABLE_SCHEMA | TABLE_NAME | ENGINE |
+--------------+------------+--------+
| mysql_db     | orders     | InnoDB |
+--------------+------------+--------+
1 row in set (0.01 sec)
````
###### Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
######- на `MyISAM`
````
mysql> SET profiling = 1
    -> ;
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.12 sec)
Records: 5  Duplicates: 0  Warnings: 0
````
###### - на `InnoDB`
````
mysql> ALTER TABLE oreders ENGINE = InnoDB;
ERROR 1146 (42S02): Table 'mysql_db.oreders' doesn't exist
mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.06 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW PROFILES;
+----------+------------+-------------------------------------+
| Query_ID | Duration   | Query                               |
+----------+------------+-------------------------------------+
|        1 | 0.11503300 | ALTER TABLE orders ENGINE = MyISAM  |
|        2 | 0.00134050 | ALTER TABLE oreders ENGINE = InnoDB |
|        3 | 0.05877950 | ALTER TABLE orders ENGINE = InnoDB  |
+----------+------------+-------------------------------------+
3 rows in set, 1 warning (0.00 sec)

mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> SHOW PROFILES;
+----------+------------+-------------------------------------+
| Query_ID | Duration   | Query                               |
+----------+------------+-------------------------------------+
|        1 | 0.11503300 | ALTER TABLE orders ENGINE = MyISAM  |
|        2 | 0.00134050 | ALTER TABLE oreders ENGINE = InnoDB |
|        3 | 0.05877950 | ALTER TABLE orders ENGINE = InnoDB  |
|        4 | 0.00034850 | SET profiling = 1                   |
+----------+------------+-------------------------------------+
4 rows in set, 1 warning (0.00 sec)
````
## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

###### Результат
````
root@eec275af3ed7:/# nano /etc/mysql/my.cnf


  GNU nano 3.2                                      /etc/mysql/my.cnf                                       Modified  


[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Custom config should go here
!includedir /etc/mysql/conf.d/

innodb_flush_log_at_trx_commit = 0
innodb_file_per_table = ON
innodb_log_buffer_size = 1M
innodb_buffer_pool_size = 2G
innodb_log_file_size = 100M


````
---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---