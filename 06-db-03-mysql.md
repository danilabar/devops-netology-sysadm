## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](06-db-03-mysql/test_data/test_dump.sql) и восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.

### Ответ

- [docker-compose манифест](06-db-03-mysql/docker-compose.yaml)
- Запустил контейнер
  ```bash
   docker-compose -f docker-compose.yaml up -d
  ```
- Восстановил БД из [бекапа](06-db-03-mysql/test_data/test_dump.sql)
  ```bash
  docker exec -i mysql sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD" test_db' < /root/06_03/test_dump.sql
  ```
- Команда для выдачи статуса БД `status    (\s) Get status information from the server.`
  ```bash
  mysql> status
  --------------
  mysql  Ver 8.0.28 for Linux on x86_64 (MySQL Community Server - GPL)
  
  Connection id:          13
  Current database:
  Current user:           root@localhost
  SSL:                    Not in use
  Current pager:          stdout
  Using outfile:          ''
  Using delimiter:        ;
  Server version:         8.0.28 MySQL Community Server - GPL
  Protocol version:       10
  Connection:             Localhost via UNIX socket
  Server characterset:    utf8mb4
  Db     characterset:    utf8mb4
  Client characterset:    latin1
  Conn.  characterset:    latin1
  UNIX socket:            /var/run/mysqld/mysqld.sock
  Binary data as:         Hexadecimal
  Uptime:                 6 min 17 sec
  
  Threads: 5  Questions: 73  Slow queries: 0  Opens: 185  Flush tables: 3  Open tables: 103  Queries per second avg: 0.193
  -------------- 
  ```
- Подключился к восстановленной БД и получил список всех таблиц
  ```bash
  mysql> USE test_db;
  Reading table information for completion of table and column names
  You can turn off this feature to get a quicker startup with -A
  
  Database changed
  mysql> SHOW TABLES;
  +-------------------+
  | Tables_in_test_db |
  +-------------------+
  | orders            |
  +-------------------+
  1 row in set (0.01 sec)
  
  mysql> SHOW FULL TABLES;
  +-------------------+------------+
  | Tables_in_test_db | Table_type |
  +-------------------+------------+
  | orders            | BASE TABLE |
  +-------------------+------------+
  1 row in set (0.00 sec) 
  ```
- количество записей с `price` > 300
  ```bash
   mysql> SELECT COUNT(*) FROM orders WHERE price > '300';
  +----------+
  | COUNT(*) |
  +----------+
  |        1 |
  +----------+
  1 row in set (0.00 sec)
  ```
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

### Ответ

- Создал пользователя
  ```sql
  CREATE USER 'test'@'localhost' IDENTIFIED WITH mysql_native_password BY 'test-pass'
  WITH MAX_QUERIES_PER_HOUR 100
      PASSWORD EXPIRE INTERVAL 180 DAY
      FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 1
  ATTRIBUTE '{"Фамилия": "Pretty", "Имя": "James"}'; 
  ```
- Предоставил привилегии пользователю `test` на операции SELECT базы `test_db`  
  ```sql
  GRANT SELECT ON `test_db`.* TO 'test'@'localhost';
  FLUSH PRIVILEGES; 
  ```
- Получил данные по пользователю `test`  
  ```bash
  mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE `USER` = 'test';
  +------+-----------+---------------------------------------+
  | USER | HOST      | ATTRIBUTE                             |
  +------+-----------+---------------------------------------+
  | test | localhost | {"Имя": "James", "Фамилия": "Pretty"} |
  +------+-----------+---------------------------------------+
  1 row in set (0.00 sec)
  ```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

### Ответ
- В таблице БД `test_db` используется `Engine: InnoDB` 
  ```bash
  mysql> SHOW TABLE STATUS WHERE Name = 'orders'\G;
  *************************** 1. row ***************************
             Name: orders
           Engine: InnoDB
          Version: 10
       Row_format: Dynamic
             Rows: 5
   Avg_row_length: 3276
      Data_length: 16384
  Max_data_length: 0
     Index_length: 0
        Data_free: 0
   Auto_increment: 6
      Create_time: 2022-02-20 21:44:54
      Update_time: NULL
       Check_time: NULL
        Collation: utf8mb4_0900_ai_ci
         Checksum: NULL
   Create_options:
          Comment:
  1 row in set (0.00 sec) 
  ```
- Время выполнения и запрос на изменения из профайлера
  ```bash
  mysql> SHOW PROFILES;
  +----------+------------+------------------------------------+
  | Query_ID | Duration   | Query                              |
  +----------+------------+------------------------------------+
  |       18 | 0.03444750 | ALTER TABLE orders ENGINE = MyISAM |
  |       19 | 0.04021375 | ALTER TABLE orders ENGINE = InnoDB |
  +----------+------------+------------------------------------+
  2 rows in set, 1 warning (0.00 sec) 
  ```

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

### Ответ

- Файл `my.cnf` в директории /etc/mysql
  ```bash
  root@207c4ea071bc:/# cat /etc/mysql/my.cnf
  # Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
  #
  # This program is free software; you can redistribute it and/or modify
  # it under the terms of the GNU General Public License as published by
  # the Free Software Foundation; version 2 of the License.
  #
  # This program is distributed in the hope that it will be useful,
  # but WITHOUT ANY WARRANTY; without even the implied warranty of
  # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  # GNU General Public License for more details.
  #
  # You should have received a copy of the GNU General Public License
  # along with this program; if not, write to the Free Software
  # Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
  
  #
  # The MySQL  Server configuration file.
  #
  # For explanations see
  # http://dev.mysql.com/doc/mysql/en/server-system-variables.html
  
  [mysqld]
  pid-file        = /var/run/mysqld/mysqld.pid
  socket          = /var/run/mysqld/mysqld.sock
  datadir         = /var/lib/mysql
  secure-file-priv= NULL
  
  # Custom config should go here
  !includedir /etc/mysql/conf.d/
  ```
- измененный файл `my.cnf`  
  ```bash
  [mysqld]
  pid-file        = /var/run/mysqld/mysqld.pid
  socket          = /var/run/mysqld/mysqld.sock
  datadir         = /var/lib/mysql
  secure-file-priv= NULL
  
  innodb_flush_method = O_DSYNC
  innodb_flush_log_at_trx_commit = 2
  innodb_file_per_table = ON
  innodb_log_buffer_size = 1M
  innodb_buffer_pool_size = 1178M
  innodb_log_file_size = 100M
  
  # Custom config should go here
  !includedir /etc/mysql/conf.d/
  ```