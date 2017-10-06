# Routines

## View

1. Создание

    ```sql
    CREATE VIEW PaperSubmission AS
        SELECT title, keyword, name AS conf_name, accepted
        FROM Paper
        JOIN Conference ON (Paper.conference_id = Conference.id);
    ```

1. Использование

    ```sql
    SELECT * From PaperSubmission
    WHERE conf_name = 'SIGMOD15';
    ```

1. Функции
    * Настройка схемы БД для разных пользователей.
    * Сокращение текста запросов
    * Разграничение прав доступа
    * Устойчивость к изменениям схемы приложения

## Stored Procedure
1. Хранимая процедура это код написанный с помощью: `SQL` + императивные конструкции (переменные, условные операторы, циклы)
1. Хранятся в базе данных и выполняются ядром СУБД.
1. Могут принимать аргументы и возвращать значения (в т.ч. может вернуть таблицу)
1. Пример:
    ```sql
    CREATE OR REPLACE FUNCTION SubmitPaper(_title Text, _conference_id INT, _keywords TEXT[])
    RETURNS VOID AS $$
        DECLARE
            _paper_id INT;
            k TEXT;
        BEGIN
            INSERT INTO Paper(title)
            VALUES (_title)
            RETURNING id INTO _paper_id;

            INSERT INTO PaperConference(paper_id, conference_id)
            VALUES (_paper_id, _conference_id)

            FOREACH k IN ARRAY _keywords LOOP
                INSERT INTO PaperKeyword(paper_id, keyword_id)
                SELECT _paper_id, Keyword.id
                FROM Keyword
                WHERE value = k;
            END LOOP;
        END;
    $$ LANGUAGE plpgsql;
    ```

1. Плюсы
    * Нет накладных расходов на передачу данных по сети.
    * Воможет более изощренный контроль над правами доступа
    * Код и схема БД рядом => есть шансы, что изменения будут синхронизированны
    * Приложение получает интерфейс для действий над данными.

1. Минусы
    * Синтаксис и поведение плохо стандартизированны
    * Отладка затруднена
    * Код и схема БД в отрыве от приложения => есть шансы, что изменения будут рассинхронизированны
    * Тяжело отслеживать изменения в системе контроля версий
