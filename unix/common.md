# Commands

## Table of Content

- [Help](#help)
- [Upgrade Packages](#upgrade-packages)
- [History](#history)
- [Syntax](#syntax)
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

## Upgrade Packages

1. To get Packet Source Lists
    ```bash
    cat /etc/apt/source.list
    ```

1. To update list of latest versions of the software from Packet Source Lists
    ```bash
    sudo apt-get update
    ```

    **This command doesn't install any new versions, only updates their list**

1. To upgrade packages version
    ```bash
    sudo apt-get upgrade -y
    ```

1. To Remove unused packages
    ```bash
    sudo apt-get autoremove
    ```

1. To browse packages navigate to [packages.ubuntu.com](packages.ubuntu.com)

## Syntax
1. **`''`** escape everything inside.
1. **`""`** don’t escape **`$`**, **`{}`**. But escape **`~`** (use **`$HOME`** instead).
1. **`\`** - escapes one symbol
1. There are 2 kinds of commands. Shell _builtin_ and _external_ (executable files).
    * **`type`** - get info if command is builtin, external or alias command

        ```bash
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

## System utils
1. **`date`** - информация о дате, времени часовом поясе и тд
1. **`cal`** - выводит каледарь для текущего месяца, в котором выделен текущий день
1. **`sleep`** переход выполнения в режим ожидания на заданное количество секунд
1. **`time`** - выводит информацию о том сколько потратилось времени на выполнение команды
    ```bash
    time ls
    ```
1. **`gzip`** - сжать файл
    ```bash
    gzip text.txt
    ```

1. **`gunzip`** - распоковать файл
    ```bash
    gunzip text.txt.gz
    ```
1. **`zcat`**, **`zmore`** - вывод содержимого сжатых файлов сжатых с помощью `gzip`
1. **`bzip2`**, **`bunzip2`** - сжимает\распоковывает файлы более эффективно чем `gzip` но при этом тратит больше времени.
1. **`bzcat`**, **`bzmore`** - вывод содержимого сжатых файлов сжатого с помощью `bzip2`
1. **`kill`** - shut down the process

    ```bash
    kill -9 process-id
    ```

1. **`ps`** - get the processes list snapshoot

    * get the full process list
        ```bash
        sudo ps aux
        ```

1. **`dpkg`** - get info about installed packages.

    * Get the full list of installed packages
        ```bash
        sudo dpkg -l
        ```
