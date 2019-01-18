# Help

- [Man](#man)
- [Usefull man pages](#usefull-man-pages)

## Man

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

1. Update mandb database
    ```bash
    mandb
    ```

1. List documentation for all installed packages
    ```bash
    ls /usr/share/lib
    ```


## Usefull man pages
1. `man man`
1. `man apropos`
1. `man whatis`
1. `man 3 getaddinfo`
1. `man inet`
1. `man 7 ip`


## Readming man
1. `[ARG]` - there is an optional argument
1. `[ARG]`... - there are zero or more optional arguments
1. `[[month] year]` - if there is one argument it will be treated at `year` (remove a `[]`); if there are 2 arguments they will be treated at `month year`
