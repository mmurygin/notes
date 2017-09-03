# File System

## Table of content
- [Common](#common)
- [File System](#file-system)
- [File Management commands](#file-management-commands)

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
1. **`chgrp groupname filename`** - изменяет группу пользователей, владеющей файлом
1. **`chown username filename`** - изменяет пользователя владельца файла
    * **`chown groupname:username filename`** - изменяет группу и пользователя одновременно.
1. **`ls -l`**Посмотреть права доступа к файлам
    ```bash
    $ ls -lh /home
    drwxr-xr-x 53 max  max  4,0K авг.  30 09:59 max
    ```

    * `drwxr-xr-x` - права доступа
        * **<span style="color: red">d</span>rwxr-xr-x** - тип файла
        * **d<span style="color: red">rwx</span>r-xr-x** - права доступа для обладателя файла
        * **drwx<span style="color: red">r-x</span>r-x** - права доступа для группы обладателя фалйа
        * **drwxr-x<span style="color: red">r-x</span>** - права доступа для всех остальных
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
