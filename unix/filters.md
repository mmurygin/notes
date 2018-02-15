# Filters
- [Get file content](#get-file-content)
- [Filters](#filters)

## Get file content
1. **`head`** - get first 10 lines of file
    * **`head -4`** - get first 4 files of file
    * **`head -4c`** - get first 4 bytes of file
1. **`tail`** - get last 10 lines of file
    * **`tail -4`** - get last 4 files of file
    * **`tail -4c`** - get last 4 bytes of file
1. **`cat`** - copy data from `stdin` to `stdout`.
    * **`cat file1 file2 file3`** - concatenates 3 files
    * create a file with content (stop - here is a special marker of end of input - we could specify any word, most common is EOF)
        ```bash
        cat > hot.txt <<stop
        some string
        stop
        ```
    * copy file1 to file2
        ```bash
        cat file1 > file2
        ```
1. **`less`** get file content and format it into multiple pages (use space to navigate between them).
1. **`tac`** - print file with reversed string order
    ```bash
    $ tac count.txt
    три
    два
    один
    ```


## Filters
1. `cat` - при размещении фильтра cat между двумя программными каналами не будет осуществляться какой-либо обработки передающихся через них данных.

    ```bash
    $ tac count.txt | cat | cat | cat | cat | cat
    три
    два
    один
    ```
1. **`tee`** - перемещает данные из стандартного потока ввода stdin в стандартный поток вывода stdout, а также записывает их в файл.

    ```bash
    $ tac count.txt | tee temp.txt | tac
    один
    два
    три
    $ cat temp.txt
    три
    два
    один
    ```
1. **`grep`** - фильрует строки текста

    * поиск слово Williams в строке
        ```bash
        cat tennis.txt | grep Williams
        ```

    * **`-i`** - поиск без учета регистра
        ```bash
        grep -i Bel tennis.txt
        ```

    * **`-v`** - поиск строк не удовлетворяющих условию
        ```bash
        grep -v Bel tennis.txt
        ```

    * **`-A1`** - добавить одну строку выше найденной в результат
        ```bash
        grep -A1 Henin tennis.txt
        ```

    * **`-B1`** - добавить одну строку ниже найденной в результат
    * **`-C1`** - добавить по одной строке выше и ниже найденной в результат.

1. **`cut`** - извлекает данные из столбцов расположенных в файлах таблиц с указанием разделителя столбцов или количества байт данных в столбцах

    * разделить строку по двоеточию и вывести 1 и 3 столбцы
        ```bash
        cut -d: -f1,3 /etc/passwd | tail -4
        ```

    * разделить строку по пробелам
        ```bash
        cut -d" " -f1 file.txt
        ```

1. **`tr`** - преобразование символов в потоке

    * заменить символ в строке
        ```bash
        cat tennis.txt | tr 'e' 'E'
        ```

    * **`-d`** - удалить символ
        ```bash
        cat tennis.txt | tr -d e
        ```

    * заменить последовательность символов
        ```bash
        cat tennis.txt | tr 'a-z' 'A-Z'
        ```

1. **`wc`** - подсчитывает строки, слова и символы
1. **`sort`** - сортирует строки

    * сортировка строк
        ```bash
        sort music.txt
        ```

    * **`-k`** - сортировка строк по 1 столбцу
        ```bash
        sort -k1 country.txt
        ```

    * **`-n`** - числовая сортировка
        ```bash
        $ sort -k3 country.txt
        Belgium, Brussels, 10
        Germany, Berlin, 100
        Italy, Rome, 50
        France, Paris, 60

        Iran, Teheran, 70
        $ sort -n -k3 country.txt
        Belgium, Brussels, 10
        Italy, Rome, 50
        France, Paris, 60
        Iran, Teheran, 70
        Germany, Berlin, 100
        ```

1. **`uniq`** - отфильтровывает повторяющиеся строки
1. **`sed`** - расширенное потоковое редактирование файлов с помощью регулярных выражений

    * замена строки
    ```bash
    $ echo уровень5 | sed 's/5/42/'
    уровень42
    ```

    * **`g`** - замена всех строк в файле
    ```bash
    $ echo уровень5 уровень7 | sed 's/уровень/переход/'
    переход5 уровень7
    ```

    * **`d`** - удаление срок содержащих заданную последовательность символов
    ```bash
    $ cat tennis.txt
    Venus Williams, USA
    Martina Hingis, SUI
    Justine Henin, BE
    Serena williams, USA
    Kim Clijsters, BE
    Yanina Wickmayer, BE

    $ cat tennis.txt | sed '/BE/d'
    Venus Williams, USA
    Martina Hingis, SUI
    Serena williams, USA
    ```
