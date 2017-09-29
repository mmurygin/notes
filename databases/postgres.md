# Postgres

## Table Of Content
- [Analize Query](#analize-query)

## Analize Query
```sql
EXPLAIN ANALYZE
    SELECT Conference.name, University.name
    FROM Conference
        JOIN Participant ON (Conference.conference_id = Participant.conference_id)
        JOIN Researcher ON (Participant.researcher_id = Researcher.researcher_id)
        JOIN University ON (Researcher.university_id = University.university_id);
```

![Analize](../images/postgres-analize.png)

* `Seq Scan`- последовательное сканирование
* `Hash` - составление хэш таблицы (`key: values[])
* `Hash Join` - join двух хэшированных таблиц
