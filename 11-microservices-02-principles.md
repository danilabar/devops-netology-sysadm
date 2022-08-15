# Домашнее задание к занятию "11.02 Микросервисы: принципы"

Вы работаете в крупной компанию, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps специалисту необходимо выдвинуть предложение по организации инфраструктуры, для разработки и эксплуатации.

## Задача 1: API Gateway 

Предложите решение для обеспечения реализации API Gateway. Составьте сравнительную таблицу возможностей различных программных решений. На основе таблицы сделайте выбор решения.

Решение должно соответствовать следующим требованиям:
- Маршрутизация запросов к нужному сервису на основе конфигурации
- Возможность проверки аутентификационной информации в запросах
- Обеспечение терминации HTTPS

Обоснуйте свой выбор.

## Задача 2: Брокер сообщений

Составьте таблицу возможностей различных брокеров сообщений. На основе таблицы сделайте обоснованный выбор решения.

Решение должно соответствовать следующим требованиям:
- Поддержка кластеризации для обеспечения надежности
- Хранение сообщений на диске в процессе доставки
- Высокая скорость работы
- Поддержка различных форматов сообщений
- Разделение прав доступа к различным потокам сообщений
- Протота эксплуатации

Обоснуйте свой выбор.

## Задача 3: API Gateway * (необязательная)

### Есть три сервиса:

**minio**
- Хранит загруженные файлы в бакете images
- S3 протокол

**uploader**
- Принимает файл, если он картинка сжимает и загружает его в minio
- POST /v1/upload

**security**
- Регистрация пользователя POST /v1/user
- Получение информации о пользователе GET /v1/user
- Логин пользователя POST /v1/token
- Проверка токена GET /v1/token/validation

### Необходимо воспользоваться любым балансировщиком и сделать API Gateway:

**POST /v1/register**
- Анонимный доступ.
- Запрос направляется в сервис security POST /v1/user

**POST /v1/token**
- Анонимный доступ.
- Запрос направляется в сервис security POST /v1/token

**GET /v1/user**
- Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET /v1/token/validation/
- Запрос направляется в сервис security GET /v1/user

**POST /v1/upload**
- Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET /v1/token/validation/
- Запрос направляется в сервис uploader POST /v1/upload

**GET /v1/user/{image}**
- Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET /v1/token/validation/
- Запрос направляется в сервис minio  GET /images/{image}

### Ожидаемый результат

Результатом выполнения задачи должен быть docker compose файл запустив который можно локально выполнить следующие команды с успешным результатом.
Предполагается что для реализации API Gateway будет написан конфиг для NGinx или другого балансировщика нагрузки который будет запущен как сервис через docker-compose и будет обеспечивать балансировку и проверку аутентификации входящих запросов.
Авторизаци
curl -X POST -H 'Content-Type: application/json' -d '{"login":"bob", "password":"qwe123"}' http://localhost/token

**Загрузка файла**

curl -X POST -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJib2IifQ.hiMVLmssoTsy1MqbmIoviDeFPvo-nCd92d4UFiN2O2I' -H 'Content-Type: octet/stream' --data-binary @yourfilename.jpg http://localhost/upload

**Получение файла**
curl -X GET http://localhost/images/4e6df220-295e-4231-82bc-45e4b1484430.jpg

---

#### [Дополнительные материалы: как запускать, как тестировать, как проверить](https://github.com/netology-code/devkub-homeworks/tree/main/11-microservices-02-principles)

---

# Ответ

## Задача 1: API Gateway 

Если не все, то многие современные решения для API Gateway удовлетворяют заявленные потребности, например это такие как:
- Облачные решения:
  - Amazon API Gateway
  - Oracle API Gateway
  - Google API Gateway
- Локальные
  - Tyk
  - KrakenD
  - Nginx

Я бы остановил выбор на реализации API Gateway с помощью Nginx, т.к. это популярный продукт с большим сообществом, так же
у него есть описание различных схем реализации API Gateway собранных в [статье](https://www.nginx.com/blog/choosing-the-right-api-gateway-pattern/?__cf_chl_captcha_tk__=ed4062235a4eed746839ffaa4456039c320f9dec-1624120905-0-AYcP8ha43drdyJNKyF-DIGvZ1DR9YkX22Cl4O1eqj6VlImek5TI0LGefDCYx2x8nlce-REfCRIUyoqCAkDCcqNbjEPJCtKlCWPqty1WO-_5wzjjqkhHOIIP4GOQc-WRiQC4-XSYDvk_4svL_UsxTXQXtnach30UaMfB5o7Gf1AWSQtMK4FuNSBTxryzUZ4JAFyVrZVzzUWvWihqdKzk9otDOoK_kSzkjOTisu3XqYuBH6SsaiivUTx2TE20_hYQk4_URyMlzH7RhybZzZQL_KZakNAx2Aa5rBJt-ps0ETa_PZsEOgBBOv2MFeQu0DzaSqiLqnmboU47i38a0dKZg23_sq2wz7ULK3JZTSKsj6fIO-PTA-k_yncNs7odQNoL-hbaUsWor_aJX3cTcoDvok11rxniKHSQtkTKaGKgmi9s4SNft7kq6u0fkANzo77qLQQ7RJuwEAb5QuRba8ulZPQADD8vVC16JyY3aRET9DskxQg2T-1n6MGHjOtvjrNjhUojPMI0VU4oFjU7YqCvJyFdW-r4b43R2D3S6uOeJVNZjn4DbU-lKshHet4jd45PjgA0C7fANadJ9bstolosruifQyN_rWlRJiytg-yRLpZpxkFKEhRuC3C6R9JVbivKhP1gSc2OkLvKH8Fa4wk6QwIr03PSzA78Dnsb4JSE5MhvqaK_0XYqb95ZWYUKaFF40Jw).
Основываясь на данных этой статьи подойдёт схема `Microgateway` созданная на базе Nginx.

## Задача 2: Брокер сообщений

Задача \ Брокер | Kafka | Redis | RabbitMQ | ActiveMQ
--- | --- | --- | --- | ---
Поддержка кластеризации для обеспечения надежности | + | + | + | + |
Хранение сообщений на диске в процессе доставки | + | - | + | + |
Высокая скорость работы | + | + | + | - |
Поддержка различных форматов сообщений | + | + | + | - |
Разделение прав доступа к различным потокам сообщений | + | + | + | + |
Простота эксплуатации | + | + | + | + |

RabbitMQ и Kafka оба удовлетворяет всем предъявляемым требованиям. Выбор конечного решения будет зависеть от задач сервиса.
RabbitMQ использует push модель, а Kafka pull. Kafka позволяет намного проще выполнять масштабирование и поддержание порядка сообщений, при этом 
RabbitMQ позволяет подписчикам упорядочивать произвольные группы событий, что бы они не конкурировали за получение сообщений.  
Исходя из этих различий, которые могут быть критичными для реализуемого сервиса следует остановить выбор на Kafka или RabbitMQ.