# Commands

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

## System commands

1. To shut down the process

    ```shell
    kill -9 process-id
    ```

1. To get the full processes list

    ```shell
    sudo ps aux
    ```

1. Get the full list of installed packages

    ```shell
    sudo dpkg -l
    ```
