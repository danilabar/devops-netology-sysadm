# Домашнее задание к занятию "13.3 работа с kubectl"
## Задание 1: проверить работоспособность каждого компонента
Для проверки работы можно использовать 2 способа: port-forward и exec. Используя оба способа, проверьте каждый компонент:
* сделайте запросы к бекенду;
* сделайте запросы к фронту;
* подключитесь к базе данных.

## Задание 2: ручное масштабирование

При работе с приложением иногда может потребоваться вручную добавить пару копий. Используя команду kubectl scale, попробуйте увеличить количество бекенда и фронта до 3. Проверьте, на каких нодах оказались копии после каждого действия (kubectl describe, kubectl get pods -o wide). После уменьшите количество копий до 1.

---

# Ответ

## Задание 1

- Список подов и сервисов  
  ![img_2.png](13-kubernetes-config-03-kubectl/img/img_2.png)  
  ![img.png](13-kubernetes-config-03-kubectl/img/img.png)  

- exec
  - Запрос к бекенду от фронтенда
    ```bash
    kubectl exec frontend-8c7cd5884-tq4ks -- curl -s backend.prod.svc.cluster.local:9000/api/news/
    ```  
    ![img_1.png](13-kubernetes-config-03-kubectl/img/img_1.png)  

  - Запрос к фронтенду от бекенда
    ```bash
    kubectl exec backend-7677687cf4-79b9m -- curl -s frontend.prod.svc.cluster.local:8000
    ```  
    ![img_3.png](13-kubernetes-config-03-kubectl/img/img_3.png)  

  - Запрос к БД
    ```bash
    kubectl exec db-0 -- psql -U postgres -d news -c \\dt
    ```  
    ![img_4.png](13-kubernetes-config-03-kubectl/img/img_4.png)

- port-forward
  - Фронтенд
    ```bash
    kubectl port-forward service/frontend 8080:8000
    ```  
    ![img_5.png](13-kubernetes-config-03-kubectl/img/img_5.png)  
    ![img_6.png](13-kubernetes-config-03-kubectl/img/img_6.png)  

  - Бекенд
    ```bash
    kubectl port-forward service/backend 8080:9000
    ```  
    ![img_7.png](13-kubernetes-config-03-kubectl/img/img_7.png)  
    ![img_8.png](13-kubernetes-config-03-kubectl/img/img_8.png)  

  - БД
    ```bash
    kubectl port-forward service/postgres 8080:5432
    ```  
    ![img_9.png](13-kubernetes-config-03-kubectl/img/img_9.png)  
    ![img_10.png](13-kubernetes-config-03-kubectl/img/img_10.png)  

## Задание 2

- Поды до масштабирования  
  ![img_11.png](13-kubernetes-config-03-kubectl/img/img_11.png)  

- Увеличил реплики фронтенд и бекенд до 3-х
  ```bash
  kubectl scale --replicas=3 deploy/frontend
  kubectl scale --replicas=3 deploy/backend
  ```  
  ![img_12.png](13-kubernetes-config-03-kubectl/img/img_12.png)  
- Уменьшил реплики фронтенд и бекенд до 1-й
  ```bash
  kubectl scale --replicas=1 deploy/frontend
  kubectl scale --replicas=1 deploy/backend
  ```  
  ![img_13.png](13-kubernetes-config-03-kubectl/img/img_13.png)  