# Bash

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

## Common
1. Quoting special characters
    * backslash for a single character: `"file\ with\ spaces"`
    * single quotes espace everything: `'f*?'`

## File management
1. ["On a UNIX system, everything is a file; if something is not a file, it is a process."](http://www.tldp.org/LDP/intro-linux/html/sect_03_01.html)

1. Special symbols
    * **`/`** - top level directory
    * **`.`** - current directory
    * **`..`** - parent directory
    * **`~`** - home directory

3. List files - **`ls`**
    * **`ls dir`** - list contens of dir
    * **`ls -l`** - list in long format
    * **`ls -a`** - list all files
    * **`ls -R`** - recursively list files in subdirectories
    * **`ls -d`** - don't go into subdirectories, just list them
    * **`ls -S`** - list by size
    * **`ls -t`** - list by modification date
    * **`ls -lh`** - list files in long format with human-readable size
    * **`ls -F`** - list files and gets their types

4. Copy files - **`cp`**
    * **`cp a b`** - copy file **a** to **b**
    * **`cp a b c dir/`** - copy files **a b c** into **dir/**
    * **`cp -R old new`** - recursively copies directory old into new
    * **`cp -i a b`** - ask before overwriting files

1. **`mkdir`** - create directory
    * **`mkdir -p`** - create directory recursively
1. **`file`** - get info about file
1. **`mv`** - rename file
1. **`rename`** - rename files according to template

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


## Configuration

1. To extend `PATH` variable use

    ```shell
    PATH="${PATH}:new_path"
    ```

2. To add ssh-key use

    ```shell
    ssh-add path_to_ssh_key
    ```

## Usefull commands
1. Get the lines number of a directory

    ```
    find . -name "*.js" -type f -exec cat {} \; | wc -l
    ```

1. Get the size number of a directory

    ```
    find . -name "*.js" -type f -exec cat {} \; | wc -c
    ```

## Usefull scripts

1. To change terminal title add the following function to `.bashrc`:

    ```shell
    st(){
        echo -en "\033]0;$1\a"
    }
    ```

2. To set the colored promt with current branch name add the following to `.bashrc`:

    ```shell
    parse_git_branch() {
        local branch=$(git branch 2> /dev/null | \
            sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')


        if [[ branch ]]; then
            local -i MAX_LENGTH=30
            local -i branch_characters=${#branch}

            if ((branch_characters > MAX_LENGTH)) ; then
                branch="${branch::30}...)"
            fi

            echo "$branch"
        fi
    }
    GREEN="\[\033[0;32m\]"
    NO_COLOR="\[\033[0m\]"
    PS1="$GREEN\$(parse_git_branch)$NO_COLOR${debian_chroot:+($debian_chroot)}\w$ "
    ```

