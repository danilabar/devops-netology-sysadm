# Домашнее задание к занятию "13.5 поддержка нескольких окружений на примере Qbec"
Приложение обычно существует в нескольких окружениях. Для удобства работы следует использовать соответствующие инструменты, например, Qbec.

## Задание 1: подготовить приложение для работы через qbec
Приложение следует упаковать в qbec. Окружения должно быть 2: stage и production. 

Требования:
* stage окружение должно поднимать каждый компонент приложения в одном экземпляре;
* production окружение — каждый компонент в трёх экземплярах;
* для production окружения нужно добавить endpoint на внешний адрес.

---

# Ответ

- Установил jsonnet
- Установил qbec
- Создал конфигурацию
    ```bash
    qbec init netology --with-example
    ```  
    ![img.png](13-kubernetes-config-05-qbec/img/img.png)

- Добавил компоненты в конфигурацию [netology](13-kubernetes-config-05-qbec/netology)
- Посмотрел список компонентов в окружении
    ```bash
    qbec component list stage
    qbec component list prod
    ```  
    ![img_1.png](13-kubernetes-config-05-qbec/img/img_1.png)

- Запустил деплой stage
    ```bash
    qbec apply stage --yes
    ```  
    ![img_2.png](13-kubernetes-config-05-qbec/img/img_2.png)

- Проверил что всё запущено
    ```bash
    kubectl get deployments.apps,statefulsets.apps -n stage -o wide
    ```  
    ![img_3.png](13-kubernetes-config-05-qbec/img/img_3.png)

- Удалил деплой stage
    ```bash
    qbec delete stage --yes
    ```  
    ![img_4.png](13-kubernetes-config-05-qbec/img/img_4.png)

- Запустил деплой prod
    ```bash
    qbec apply prod --yes
    ```  
    ![img_5.png](13-kubernetes-config-05-qbec/img/img_5.png)

- Проверил что всё запущено
    ```bash
    kubectl get deployments.apps,statefulsets.apps,endpoints -n prod -o wide
    ```  
    ![img_6.png](13-kubernetes-config-05-qbec/img/img_6.png)  

- Удалил деплой prod
    ```bash
    qbec delete prod --yes
    ```  