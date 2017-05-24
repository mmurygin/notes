# Bash

## Help

1. `man` - prints help for command

    ```
    man cmd
    ```

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

## File management

1. Special symbols
    * **`/`** - top level directory
    * **`.`** - current directory
    * **`..`** - parent directory
    * **`~`** - home directory

2. Quoting special characters
    * backslash for a single character: `"file\ with\ spaces"`
    * single quotes espace everything: `'f*?'`

3. List files - **`ls`**
    * **`ls dir`** - list contens of dir
    * **`ls -l`** - list in long format
    * **`ls -a`** - list all files
    * **`ls -R`** - recursively list files in subdirectories
    * **`ls -d`** - don't go into subdirectories, just list them
    * **`ls -S`** - list by size
    * **`ls -t`** - list by modification date

4. Copy files - **`cp`**
    * **`cp a b`** - copy file **a** to **b**
    * **`cp a b c dir/`** - copy files **a b c** into **dir/**
    * **`cp -R old new`** - recursively copies directory old into new
    * **`cp -i a b`** - ask before overwriting files

5. Get the lines number of a directory

    ```
    find . -name "*.js" -type f -exec cat {} \; | wc -l
    ```

6. Get the size number of a directory

    ```
    find . -name "*.js" -type f -exec cat {} \; | wc -c
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

