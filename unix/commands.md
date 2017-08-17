# Commands

## Table of Content

- [Help](#help)
- [History](#history)
- [Common](#common)
- [File management commands](#file-management-commands)
- [Get file content](#get-file-content)
- [Filters](#filters)
- [System utils](#system-utils)

## Help

1. **`man`** - prints help for command

    ```
    man cmd
    ```
1. **`man -k`** - get all pages which contain specified string
    ```
    man -k syslog
    ```
1. **`whatis`** - get the description of help page
    ```
    whatis route
    ```
1. **`whereis`** - get help page location
    ```
    whereis -m whois
    ```
1. To get help about linux file system use
    ```
    man heir
    ```

## Common
1. **`''`** escape everything inside.
1. **`""`** don’t escape **`$`**, **`{}`**. But escape **`~`** (use **`$HOME`** instead).
1. **`\`** - escapes one symbol
1. There are 2 kinds of commands. Shell _builtin_ and _external_ (executable files).
    * **`type`** - get info if command is builtin, external or alias command

        ```shell
        type ls # ls is aliased to `ls --color=auto`
        ```

    * **`which command`** - finds command executable in $PATH

## History
1. **`!!`** - повторение предыдущей команды
1. **`!to`** - повторение последней команды начинающейся с `to`
1. **`!<number>`** (`!3`) - повторение команды по с номером 3 из истории
1. **`history <n>`** - отображает последние `n` команд
1. **`ctrl+r`** - поиск последней команды содержащий набор символов. (для перехода к следующему результату поиска нужно повторно нажать `ctrl+r`)
1. Конфигурирование
    * **`HISTSIZE`** - количество команд, которые сохраняются при работе в текущем окружении
    * **`HISTFILE`** - имя файла для сохранения истории
    * **`HISTFILESIZE`** - количество команд которые сохраняются в файле истории команд
1. Чтобы предтовратить сохранение команды в истории нужно использовать `space` вначале команды

## File management commands
1. Special symbols
    * **`/`** - top level directory
    * **`.`** - current directory
    * **`..`** - parent directory
    * **`~`** - home directory

1. **`touch`** - create a file

1. List files - **`ls`**
    * **`ls dir`** - list contens of dir
    * **`ls -l`** - list in long format
    * **`ls -a`** - list all files
    * **`ls -R`** - recursively list files in subdirectories
    * **`ls -d`** - don't go into subdirectories, just list them
    * **`ls -S`** - list by size
    * **`ls -t`** - list by modification date
    * **`ls -lh`** - list files in long format with human-readable size
    * **`ls -F`** - list files and gets their types

1. Copy files - **`cp`**
    * **`cp a b`** - copy file **a** to **b**
    * **`cp a b c dir/`** - copy files **a b c** into **dir/**
    * **`cp -R old new`** - recursively copies directory old into new
    * **`cp -i a b`** - ask before overwriting files

1. **`mkdir`** - create directory
    * **`mkdir -p`** - create directory recursively

1. **`file`** - get info about file

1. **`mv`** - rename file

1. **`rename`** - rename files according to template
    * change all `.txt` files extensions to `.png`
        ```shell
        rename 's/\.txt/\.png/ *.txt
        ```

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
        ```shell
        cat > hot.txt <<stop
        some string
        stop
        ```
    * copy file1 to file2
        ```shell
        cat file1 > file2
        ```
1. **`less`** get file content and format it into multiple pages (use space to navigate between them).
1. **`tac`** - print file with reversed string order
    ```shell
    $ tac count.txt
    три
    два
    один
    ```

## Filters
1. `cat` - при размещении фильтра cat между двумя программными каналами не будет осуществляться какой-либо обработки передающихся через них данных.

    ```shell
    $ tac count.txt | cat | cat | cat | cat | cat
    три
    два
    один
    ```
1. **`tee`** - перемещает данные из стандартного потока ввода stdin в стандартный поток вывода stdout, а также записывает их в файл.

    ```shell
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
        ```shell
        cat tennis.txt | grep Williams
        ```

    * **`-i`** - поиск без учета регистра
        ```shell
        grep -i Bel tennis.txt
        ```

    * **`-v`** - поиск строк не удовлетворяющих условию
        ```shell
        grep -v Bel tennis.txt
        ```

    * **`-A1`** - добавить одну строку выше найденной в результат
        ```shell
        grep -A1 Henin tennis.txt
        ```

    * **`-B1`** - добавить одну строку ниже найденной в результат
    * **`-C1`** - добавить по одной строке выше и ниже найденной в результат.

1. **`cut`** - извлекает данные из столбцов расположенных в файлах таблиц с указанием разделителя столбцов или количества байт данных в столбцах

    * разделить строку по двоеточию и вывести 1 и 3 столбцы
        ```shell
        cut -d: -f1,3 /etc/passwd | tail -4
        ```

    * разделить строку по пробелам
        ```shell
        cut -d" " -f1 file.txt
        ```

1. **`tr`** - преобразование символов в потоке

    * заменить символ в строке
        ```shell
        cat tennis.txt | tr 'e' 'E'
        ```

    * **`-d`** - удалить символ
        ```shell
        cat tennis.txt | tr -d e
        ```

    * заменить последовательность символов
        ```shell
        cat tennis.txt | tr 'a-z' 'A-Z'
        ```

1. **`wc`** - подсчитывает строки, слова и символы
1. **`sort`** - сортирует строки

    * сортировка строк
        ```shell
        sort music.txt
        ```

    * **`-k`** - сортировка строк по 1 столбцу
        ```shell
        sort -k1 country.txt
        ```

    * **`-n`** - числовая сортировка
        ```shell
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
    ```shell
    $ echo уровень5 | sed 's/5/42/'
    уровень42
    ```

    * **`g`** - замена всех строк в файле
    ```shell
    $ echo уровень5 уровень7 | sed 's/уровень/переход/'
    переход5 уровень7
    ```

    * **`d`** - удаление срок содержащих заданную последовательность символов
    ```shell
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

1. **`find`** - поиск и обработка файлов рекурсивно
    * поиск всех файлов в директории рекурсивно
        ```shell
        find /etc
        ```

    * Поиск только файлов
        ```shell
        find . -type f
        ```

    * Поиск всех файлов с расширением `.conf`
        ```shell
        find . -name "*.conf"
        ```

    * Поиск всех файлов и копирование их в по заданному пути
        ```shell
        find /data -exec cp {} /backup/ \;
        ```

1. **`locate`** - поиск файлов используя данные индексирования файловой системы. Эта утилита гораздо быстрее find, но может вернуть устаревшие данные. Для того чтобы обновить индексы нужно вызвать `updatedb`. В большинстве систем Linux утилита `updatedb` запускатся один раз в день.

## System utils
1. **`date`** - информация о дате, времени часовом поясе и тд
1. **`cal`** - выводит каледарь для текущего месяца, в котором выделен текущий день
1. **`sleep`** переход выполнения в режим ожидания на заданное количество секунд
1. **`time`** - выводит информацию о том сколько потратилось времени на выполнение команды
    ```shell
    time ls
    ```
1. **`gzip`** - сжать файл
    ```shell
    gzip text.txt
    ```

1. **`gunzip`** - распоковать файл
    ```shell
    gunzip text.txt.gz
    ```
1. **`zcat`**, **`zmore`** - вывод содержимого сжатых файлов сжатых с помощью `gzip`
1. **`bzip2`**, **`bunzip2`** - сжимает\распоковывает файлы более эффективно чем `gzip` но при этом тратит больше времени.
1. **`bzcat`**, **`bzmore`** - вывод содержимого сжатых файлов сжатого с помощью `bzip2`
1. **`kill`** - shut down the process

    ```shell
    kill -9 process-id
    ```

1. **`ps`** - get the processes list snapshoot

    * get the full process list
        ```shell
        sudo ps aux
        ```

1. **`dpkg`** - get info about installed packages.

    * Get the full list of installed packages
        ```shell
        sudo dpkg -l
        ```
