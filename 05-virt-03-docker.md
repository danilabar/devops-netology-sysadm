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

### Ответ

- Скачал себе образ nginx `docker pull nginx:latest`
- Подготовил файлы:
  - [Dockerfile](https://github.com/danilabar/devops-netology-sysadm/blob/main/05-virt-03-docker/nginx/Dockerfile)
  - [index.html](https://github.com/danilabar/devops-netology-sysadm/blob/main/05-virt-03-docker/nginx/index.html)
- Собрал новый образ `docker build -t danilabar/nginx:1.21.6.4 .`
- Контейнер запускается, страница открывается `docker run -d -p 80:80 danilabar/nginx:1.21.6.4`
- Выгрузил образ в публичный реестр `docker push danilabar/nginx:1.21.6.4`
- Образ доступен в репозитории [https://hub.docker.com/repository/docker/danilabar/nginx](https://hub.docker.com/repository/docker/danilabar/nginx)

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;
- Nodejs веб-приложение;
- Мобильное приложение c версиями для Android и iOS;
- Шина данных на базе Apache Kafka;
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
- Мониторинг-стек на базе Prometheus и Grafana;
- MongoDB, как основное хранилище данных для java-приложения;
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

### Ответ

- Высоконагруженное монолитное java веб-приложение - физический сервер или виртуализация т.к. приложение высоконагруженное и ему может требоваться достаточно мощные вычислительные ресурсы
- Nodejs веб-приложение - как правило легковесные и могут прекрасно работать в контейнере
- Мобильное приложение c версиями для Android и iOS - для работы приложения нужна виртуальная машина или устройство на базе ARM
- Шина данных на базе Apache Kafka - исходя из описания Kafka с его горизонтальной масштабируемостью вполне логично будет выбрать контейнер
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana - можно запустить в контейнере, но лучшей производительности и надёжности как мне кажется можно добиться при использовании виртуальных машин.
- Мониторинг-стек на базе Prometheus и Grafana - будет прекрасно работать и быстро масштабироваться при использовании контейнеров
- MongoDB, как основное хранилище данных для java-приложения - если БД не высоконагруженная можно обойтись виртуализацией, контейнер не лучшее решение для размещения БД.
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry - исходя из реализации найденной в WWW этот сервис может работать в контейнерах.

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

### Ответ

- Контейнер 1 `docker run -dit -v /data:/data centos`
- Контейнер 2 `docker run -dit -v /data:/data debian`
  - Оба контейнера запущены
  ```bash
  root@ubuntuvm:~# docker ps
  CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS          PORTS     NAMES
  a4fe5d5868ec   debian    "bash"        6 seconds ago    Up 5 seconds              charming_hamilton
  1bc950468c26   centos    "/bin/bash"   13 seconds ago   Up 11 seconds             modest_snyder
  ```
- Подключился к контейнеру 1 и создал файл
  ```bash
  root@ubuntuvm:~# docker exec -it 1bc950468c26 /bin/bash
  [root@1bc950468c26 /]# echo 'This centos container' > /data/centos.txt
  ```
- Создал файл на хостовой машине
  ```bash
  root@ubuntuvm:~# echo 'This host machine' > /data/host.txt
  ```
- Подключился к контейнеру 2 и показал листинг
  ```bash
  root@ubuntuvm:~# docker exec -it a4fe5d5868ec /bin/bash
  
  root@a4fe5d5868ec:/# ls -lha /data/
  total 16K
  drwxr-xr-x 2 root root 4.0K Jan 27 06:25 .
  drwxr-xr-x 1 root root 4.0K Jan 27 06:14 ..
  -rw-r--r-- 1 root root   22 Jan 27 06:20 centos.txt
  -rw-r--r-- 1 root root   18 Jan 27 06:25 host.txt
  
  root@a4fe5d5868ec:/# cat /data/*
  This centos container
  This host machine
  ```

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.

### Ответ
- Воспроизвёл задание из лекции, ссылка на собранный Docker образ с Ansible [https://hub.docker.com/repository/docker/danilabar/ansible](https://hub.docker.com/repository/docker/danilabar/ansible)