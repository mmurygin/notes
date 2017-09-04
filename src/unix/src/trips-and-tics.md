# Trips and tics

## Usefull commands
1. Get the lines number of a directory

    ```bash
    find . -name "*.js" -type f -exec cat {} \; | wc -l
    ```

1. Get the size number of a directory

    ```bash
    find . -name "*.js" -type f -exec cat {} \; | wc -c
    ```

## Usefull scripts

1. To change terminal title add the following function to `.bashrc`:

    ```bash
    st(){
        echo -en "\033]0;$1\a"
    }
    ```

2. To set the colored promt with current branch name add the following to `.bashrc`:

    ```bash
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
