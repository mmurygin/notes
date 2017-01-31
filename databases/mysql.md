# MySQL

## Usefull tips

1. Use show create table to view all table columns, indexes, contstrains

    ```sql
    SHOW CREATE TABLE Tasks;
    ```

2. To view all table indexes use

    ```sql
    SHOW INDEXES from Tasks;
    ```

3. To list data about table size use:

    ```sql
    SELECT table_name, table_rows, Avg_row_length, Data_length, Max_data_length,
           Index_length,Data_free,Auto_increment
    FROM information_schema.tables
    WHERE table_schema = DATABASE();
    ```