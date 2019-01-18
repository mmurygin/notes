# Essential Commands

## Commands
1. **`date`** - информация о дате, времени часовом поясе и тд
1. **`cal`** - выводит каледарь для текущего месяца, в котором выделен текущий день
1. **`sleep`** переход выполнения в режим ожидания на заданное количество секунд
1. **`time`** - выводит информацию о том сколько потратилось времени на выполнение команды
    ```bash
    time ls
    ```
1. **`whoami`**
1. **`uname`** - shows information about the system
1. **`last`** shows the last login users

## Working with archives
1. **`tar cf filename.tar dir1 dir2`** - create tar file from multiple dirs
1. **`tar czf filename.tar.gz dir`** - create tar file and pipe it through gzip
1. **`tar xf filename.tar`** - extract file
1. **`tar xzf filename.tar`** - unzip and extract file
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

