# Домашнее задание к занятию 15.4 "Кластеры. Ресурсы под управлением облачных провайдеров"

Организация кластера Kubernetes и кластера баз данных MySQL в отказоустойчивой архитектуре.
Размещение в private подсетях кластера БД, а в public - кластера Kubernetes.

---
## Задание 1. Яндекс.Облако (обязательное к выполнению)

1. Настроить с помощью Terraform кластер баз данных MySQL:
- Используя настройки VPC с предыдущих ДЗ, добавить дополнительно подсеть private в разных зонах, чтобы обеспечить отказоустойчивость 
- Разместить ноды кластера MySQL в разных подсетях
- Необходимо предусмотреть репликацию с произвольным временем технического обслуживания
- Использовать окружение PRESTABLE, платформу Intel Broadwell с производительностью 50% CPU и размером диска 20 Гб
- Задать время начала резервного копирования - 23:59
- Включить защиту кластера от непреднамеренного удаления
- Создать БД с именем `netology_db` c логином и паролем

2. Настроить с помощью Terraform кластер Kubernetes
- Используя настройки VPC с предыдущих ДЗ, добавить дополнительно 2 подсети public в разных зонах, чтобы обеспечить отказоустойчивость
- Создать отдельный сервис-аккаунт с необходимыми правами 
- Создать региональный мастер kubernetes с размещением нод в разных 3 подсетях
- Добавить возможность шифрования ключом из KMS, созданного в предыдущем ДЗ
- Создать группу узлов состояющую из 3 машин с автомасштабированием до 6
- Подключиться к кластеру с помощью `kubectl`
- *Запустить микросервис phpmyadmin и подключиться к БД, созданной ранее
- *Создать сервис типы Load Balancer и подключиться к phpmyadmin. Предоставить скриншот с публичным адресом и подключением к БД

Документация
- [MySQL cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_cluster)
- [Создание кластера kubernetes](https://cloud.yandex.ru/docs/managed-kubernetes/operations/kubernetes-cluster/kubernetes-cluster-create)
- [K8S Cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster)
- [K8S node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group)
--- 
## Задание 2. Вариант с AWS (необязательное к выполнению)

1. Настроить с помощью terraform кластер EKS в 3 AZ региона, а также RDS на базе MySQL с поддержкой MultiAZ для репликации и создать 2 readreplica для работы:
- Создать кластер RDS на базе MySQL
- Разместить в Private subnet и обеспечить доступ из public-сети c помощью security-group
- Настроить backup в 7 дней и MultiAZ для обеспечения отказоустойчивости
- Настроить Read prelica в кол-ве 2 шт на 2 AZ.

2. Создать кластер EKS на базе EC2:
- С помощью terraform установить кластер EKS на 3 EC2-инстансах в VPC в public-сети
- Обеспечить доступ до БД RDS в private-сети
- С помощью kubectl установить и запустить контейнер с phpmyadmin (образ взять из docker hub) и проверить подключение к БД RDS
- Подключить ELB (на выбор) к приложению, предоставить скрин

Документация
- [Модуль EKS](https://learn.hashicorp.com/tutorials/terraform/eks)

# Ответ

## Задание 1

Все конфигурационные файлы проекта [terraform](15-clokub-4-cluster/terraform)

### Настроить с помощью Terraform кластер баз данных MySQL

- Конфигурация vpc [network.tf](15-clokub-4-cluster/terraform/network.tf)
- Конфигурация MySQL [mysql.tf](15-clokub-4-cluster/terraform/mysql.tf)
  - Для создания пароля пользователя БД использовался ресурс `random_password` - таким образом, пароль не хранится в конфигурации

### Настроить с помощью Terraform кластер Kubernetes

- Конфигурация vpc [network.tf](15-clokub-4-cluster/terraform/network.tf)
- Конфигурация сервис-аккаунта [k8s-sa.tf](15-clokub-4-cluster/terraform/k8s-sa.tf)
- Конфигурация регионального мастера kubernetes [k8s-cluster.tf](15-clokub-4-cluster/terraform/k8s-cluster.tf)
- Конфигурация KMS [kms.tf](15-clokub-4-cluster/terraform/kms.tf)
- Конфигурация группы узлов kubernetes кластера [k8s-ng.tf](15-clokub-4-cluster/terraform/k8s-ng.tf)
- Конфигурация для подключения к `kubectl` и деплоя микросервиса phpmyadmin [kubeconfig.tf](15-clokub-4-cluster/terraform/kubeconfig.tf)

### Созданные ресурсы

- Созданные ресурсы в Yandex.Cloud  
    ![img.png](15-clokub-4-cluster/img/img.png)  
- Кластер kubernetes доступен в `kubectl`  
    ![img_6.png](15-clokub-4-cluster/img/img_6.png)  
    ![img_1.png](15-clokub-4-cluster/img/img_1.png)  
- Группа узлов в Yandex.Cloud и `kubectl`  
    ![img_4.png](15-clokub-4-cluster/img/img_4.png)  
    ![img_5.png](15-clokub-4-cluster/img/img_5.png)  
- Запущенный `pod` и `service` phpmyadmin в kubernetes  
    ![img_2.png](15-clokub-4-cluster/img/img_2.png)  
- Подключился к БД через публичный адрес phpmyadmin. Пароль для подключения к БД взял из `terraform.tfstate`  
    ![img_3.png](15-clokub-4-cluster/img/img_3.png)  
- Для удаления MySQL вручную в интерфейсе YC снял защиту от удаления  