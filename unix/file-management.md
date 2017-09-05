# File System

## Table of content
- [Common](#common)
- [File System](#file-system)
- [File Management commands](#file-management-commands)
- [Механизмы владения файлами](#механизмы-владения-файлами)
- [Продвинутое управление правами доступа](#продвинутое-управление-правами-доступа)

## Common
1. ["On a UNIX system, everything is a file; if something is not a file, it is a process."](http://www.tldp.org/LDP/intro-linux/html/sect_03_01.html)
1. File extension does not play any role.

## File system
1. To get help about linux file system use
    ```
    man hier
    ```
1. [File system description [rus]](https://stepik.org/lesson/28949/step/2?course=%D0%9E%D1%81%D0%BD%D0%BE%D0%B2%D1%8B-Linux&unit=9961)

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
        ```bash
        rename 's/\.txt/\.png/ *.txt
        ```

1. **`find`** - поиск и обработка файлов рекурсивно
    * поиск всех файлов в директории рекурсивно
        ```bash
        find /etc
        ```

    * Поиск только файлов
        ```bash
        find . -type f
        ```

    * Поиск всех файлов с расширением `.conf`
        ```bash
        find . -name "*.conf"
        ```

    * Поиск всех файлов и копирование их в по заданному пути
        ```bash
        find /data -exec cp {} /backup/ \;
        ```

1. **`locate`** - поиск файлов используя данные индексирования файловой системы. Эта утилита гораздо быстрее find, но может вернуть устаревшие данные. Для того чтобы обновить индексы нужно вызвать `updatedb`. В большинстве систем Linux утилита `updatedb` запускатся один раз в день.

## Механизмы владения файлами
1. **`ls -l`** посмотреть права доступа к файлам
    ```bash
    $ ls -lh /home
    drwxr-xr-x 53 max  max  4,0K авг.  30 09:59 max
    ```

    * `drwxr-xr-x` - права доступа
        * **d**rwxr-xr-x - тип файла
        * d**rwx**r-xr-x - права доступа для обладателя файла
        * drwx**r-x**r-x - права доступа для группы обладателя фалйа
        * drwxr-x**r-x** - права доступа для всех остальных
    * `max` (3 колонка) - обладатель файла
    * `max` (4 колонка) - группа обладателя файла

1. Типы файлов

    | Первый символ | Тип файла |
    | --- | --- |
    | - | Обычный файл |
    | d | Директория |
    | l | Символьная ссылка |
    | p | Именованный канал |
    | b | Блочное устройство |
    | c | Символьное устройство |
    | s | Сокет |

1. Стандартные права доступа к файлам Unix

    | Право доступа | К файлу | К директории |
    | --- | --- | --- |
    | r (чтение) | Чтение содержимого файла (`cat`) | Чтение содержимого директории (`ls`) |
    | w (запись) | Изменение содержимого файла (`vi`) | Создание файлов в директории (`touch`) |
    | x (исполнение) | Исполнение файла | Вход в директорию (`cd`) |

1. **`chmod`** - устанавливает права доступа
    ```bash
    $ ls -l
    total 0
    -rw-rw-r-- 1 paul paul 0 Sep  3 08:23 permissins.txt
    $ chmod u+x permissins.txt
    $ ls -l
    total 0
    -rwxrw-r-- 1 paul paul 0 Sep  3 08:23 permissins.txt
    ```
    * **`+`** - добавляет право доступа, **`-`** - убирает право доступа, **`=`** - устанавливает права доступа (`u=rw`)
    * **`u+(r|w|x)`** - добавляет право доступа для пользователя владельца
    * **`g+(r|w|x)`** - добавляет право доступа для группы владельцев
    * **`o+(r|w|x)`** - добавляет право доступа для все пользователей, которые не являются ни владельцем ни группой владельцев
    * **`+(r|w|x)`** - добавляет право доступа для всех пользователей (владелец, группа владельцев, остальные пользователи)
    * **`chmod oct_ode filename`** - устанавливает права доступа в соответствии с восьмиричным представлением

        | Двоичное представление | Вольмеричное представление | Права доступа |
        | --- | --- | --- |
        | 000 | 0 | --- |
        | 001 | 1 | --x |
        | 010 | 2 | -w- |
        | 011 | 3 | -wx |
        | 100 | 4 | r-- |
        | 101 | 5 | r-x |
        | 110 | 6 | rw- |
        | 111 | 7 | rwx |

        ```bash
        # set to rwxrwxrwx
        $ chmod 777 permissions.txt
        $ ls -l permissions.txt
        -rwxrwxrwx 1 paul paul 0 2007-02-07 22:34 permissions.txt
        ```
1. **`chgrp groupname filename`** - изменяет группу пользователей, владеющей файлом
1. **`chown username filename`** - изменяет пользователя владельца файла
    * **`chown groupname:username filename`** - изменяет группу и пользователя одновременно.
1. **`mkdir -m oct_code dir_name`** - создаёт папку и устанавливает право доступа
    ```bash
    $ mkdir -m 700 MyDir
    $ mkdir -m 777 Public
    $ ls -dl MyDir/ Public/
    drwx------ 2 paul paul 4096 2011-10-16 19:16 MyDir/
    drwxrwxrwx 2 paul paul 4096 2011-10-16 19:16 Public/
    ```
1. **`cp -p`** - скопировать файлы и сохранить уровень доступа

## Продвинутое управление правами доступа
1. bit `sticky` может быть установлен для директории с целью предотвращения удаления файлов пользователями, которые не являются их непосредственными владельцами. отображается как `t` на месте символа `x`
    ```bash
    $ ls -l
    drwxrwxr-x 2 u1 u1 4096 Sep  4 01:26 projects
    $ chmod +t projects
    $ ls -l
    drwxrwxr-t 2 u1 u1 4096 Sep  4 01:26 projects
    ```

    * bit `sticky` может быть так же установлен в случае использования восьмеричного значения прав доступа, причём в этом случае должно использоваться двоичное значение 1 в первом из четерёх триплетов.

        ```bash
        chmod 1775 projects
        ```
1. bit `setgid` может устанавливаться дли директории в тех случаях, когда необходимо, чтобы в качестве группы пользователей, владеющей файлами в директории, использовалась группа пользователей владеющая директорией. Отображается с помощью символа `s`. Устанавливается с помощью команды `chmod 2xxx`.
    ```bash
    $ groupadd g1
    $ mkdir proj
    $ chown root:g1 proj
    $ ls -l
    drwxr-xr-x   2 root g1   4096 Sep  4 01:48 proj
    $ chmod 2775 proj
    $ touch proj/f1
    $ ls -l proj
    -rw-r--r-- 1 root g1 0 Sep  4 01:49 f1
    ```

    * если установлен бит `setgid` то при запуске файла он будет с правами пользователей из группы владеющей файлом.
1. `setuid` - позволяет запускать файл от лица его создателя, а не от лица текущего пользователя.
