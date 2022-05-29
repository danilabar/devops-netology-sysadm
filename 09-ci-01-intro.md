## Подготовка к выполнению
1. Получить бесплатную [JIRA](https://www.atlassian.com/ru/software/jira/free)
2. Настроить её для своей "команды разработки"
3. Создать доски kanban и scrum

## Основная часть
В рамках основной части необходимо создать собственные workflow для двух типов задач: bug и остальные типы задач. Задачи типа bug должны проходить следующий жизненный цикл:
1. Open -> On reproduce
2. On reproduce -> Open, Done reproduce
3. Done reproduce -> On fix
4. On fix -> On reproduce, Done fix
5. Done fix -> On test
6. On test -> On fix, Done
7. Done -> Closed, Open

Остальные задачи должны проходить по упрощённому workflow:
1. Open -> On develop
2. On develop -> Open, Done develop
3. Done develop -> On test
4. On test -> On develop, Done
5. Done -> Closed, Open

Создать задачу с типом bug, попытаться провести его по всему workflow до Done. Создать задачу с типом epic, к ней привязать несколько задач с типом task, провести их по всему workflow до Done. При проведении обеих задач по статусам использовать kanban. Вернуть задачи в статус Open.
Перейти в scrum, запланировать новый спринт, состоящий из задач эпика и одного бага, стартовать спринт, провести задачи до состояния Closed. Закрыть спринт.

Если всё отработало в рамках ожидания - выгрузить схемы workflow для импорта в XML. Файлы с workflow приложить к решению задания.

### Ответ

- Получить бесплатную JIRA
- Настроил её для своей "команды разработки"
- Создал доски kanban и scrum
- Создал собственные workflow для двух типов задач: bug и остальные типы задач  
    ![img.png](09-ci-01-intro/img/img.png)
- Создал задачу:
  - с типом bug
  - с типом epic, к ней привязал несколько задач с типом task
    ![img_1.png](09-ci-01-intro/img/img_1.png)
- Провёл их по всему workflow до Done в борде kanban
- Запланировал новый спринт в scrum и стартовал его
- Провел задачи до состояния Closed
    ![img_2.png](09-ci-01-intro/img/img_2.png)
- Закрыл спринт
- Выгрузил схемы workflow в XML
  - [bug workflow.xml](09-ci-01-intro/bug%20workflow.xml)
  - [other types of tasks.xml](09-ci-01-intro/other%20types%20of%20tasks.xml)