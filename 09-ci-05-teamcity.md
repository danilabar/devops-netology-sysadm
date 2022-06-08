## Подготовка к выполнению

1. В Ya.Cloud создайте новый инстанс (4CPU4RAM) на основе образа `jetbrains/teamcity-server`
2. Дождитесь запуска teamcity, выполните первоначальную настройку
3. Создайте ещё один инстанс(2CPU4RAM) на основе образа `jetbrains/teamcity-agent`. Пропишите к нему переменную окружения `SERVER_URL: "http://<teamcity_url>:8111"`
4. Авторизуйте агент
5. Сделайте fork [репозитория](https://github.com/aragastmatb/example-teamcity)
6. Создать VM (2CPU4RAM) и запустить [playbook](09-ci-05-teamcity/src/infrastructure)

## Основная часть

1. Создайте новый проект в teamcity на основе fork
2. Сделайте autodetect конфигурации
3. Сохраните необходимые шаги, запустите первую сборку master'a
4. Поменяйте условия сборки: если сборка по ветке `master`, то должен происходит `mvn clean deploy`, иначе `mvn clean test`
5. Для deploy будет необходимо загрузить [settings.xml](09-ci-05-teamcity/src/teamcity/settings.xml) в набор конфигураций maven у teamcity, предварительно записав туда креды для подключения к nexus
6. В pom.xml необходимо поменять ссылки на репозиторий и nexus
7. Запустите сборку по master, убедитесь что всё прошло успешно, артефакт появился в nexus
8. Мигрируйте `build configuration` в репозиторий
9. Создайте отдельную ветку `feature/add_reply` в репозитории
10. Напишите новый метод для класса Welcomer: метод должен возвращать произвольную реплику, содержащую слово `hunter`
11. Дополните тест для нового метода на поиск слова `hunter` в новой реплике
12. Сделайте push всех изменений в новую ветку в репозиторий
13. Убедитесь что сборка самостоятельно запустилась, тесты прошли успешно
14. Внесите изменения из произвольной ветки `feature/add_reply` в `master` через `Merge`
15. Убедитесь, что нет собранного артефакта в сборке по ветке `master`
16. Настройте конфигурацию так, чтобы она собирала `.jar` в артефакты сборки
17. Проведите повторную сборку мастера, убедитесь, что сбора прошла успешно и артефакты собраны
18. Проверьте, что конфигурация в репозитории содержит все настройки конфигурации из teamcity
19. В ответ предоставьте ссылку на репозиторий

### Ответ

- Создал инстансы teamcity и nexus
  - В docker-compose.yml внёс дополнительно `user: root:root` иначе контейнер не запускался с ошибками доступа к каталогам
- Авторизовал агента  
    ![img.png](09-ci-05-teamcity/img/img.png)
- Сделал fork [репозитория](https://github.com/danilabar/example-teamcity)  
- Создал новый проект в teamcity на основе fork  
    ![img_1.png](09-ci-05-teamcity/img/img_1.png)
- Сделал autodetect конфигурации  
    ![img_2.png](09-ci-05-teamcity/img/img_2.png)
- Запустил первую сборку master  
    ![img_3.png](09-ci-05-teamcity/img/img_3.png)
- Поменял условия сборки  
    ![img_4.png](09-ci-05-teamcity/img/img_4.png)
- Загрузил settings.xml в набор конфигураций maven  
    ![img_5.png](09-ci-05-teamcity/img/img_5.png)
- Поправил pom.xml
- Запустил сборку по master  
    ![img_6.png](09-ci-05-teamcity/img/img_6.png)
- Артефакт появился в nexus  
    ![img_7.png](09-ci-05-teamcity/img/img_7.png)
- Мигрировал `build configuration` в репозиторий  
    ![img_8.png](09-ci-05-teamcity/img/img_8.png)
- Создал отдельную ветку `feature/add_reply` в репозитории  
    ![img_9.png](09-ci-05-teamcity/img/img_9.png)
- Написал новый метод `sayAttention` для класса Welcomer
- Дополнил тест для нового метода
- Сделал [push](https://github.com/danilabar/example-teamcity/commit/153851a1d31061b945c86b4a8b04242ef88f35b2) всех изменений 
- Сборка самостоятельно запустилась, тесты прошли успешно  
    ![img_10.png](09-ci-05-teamcity/img/img_10.png)  
    ![img_11.png](09-ci-05-teamcity/img/img_11.png)  
- Сделал [Pull requests](https://github.com/danilabar/example-teamcity/pull/1) в `master`  
- Убедился, что нет собранного артефакта в сборке по ветке `master`  
    ![img_12.png](09-ci-05-teamcity/img/img_12.png)
- Настроил конфигурацию, чтобы она собирала `.jar` в артефакты сборки  
    ![img_13.png](09-ci-05-teamcity/img/img_13.png)
- Провёл повторную сборку мастера, она прошла успешно и артефакты собраны
  - Сборка `#9` зафейлилась т.к. возникла путаница с ветками в IDE после мёржа. Поправил и сборка `#11` прошла успешно  
    ![img_14.png](09-ci-05-teamcity/img/img_14.png)  
    ![img_15.png](09-ci-05-teamcity/img/img_15.png)  
- Проверил, что конфигурация в [репозитории](https://github.com/danilabar/example-teamcity/tree/master/.teamcity) содержит все настройки конфигурации из teamcity