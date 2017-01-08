# Shell scripts

## Table of Content

- [Common](#common)
- [Variables](#variables)


## Common

1. The is a good practise to put hash-band line at the beginning of each script

    ```bash
    #!/bin/bash
    ```
2. To make file executable use

    ```bash
    chmod u+x file_name
    ```
3. Single quotes escape everything inside.

4. Double quotes don’t escape **`$`**, **`{}`**. But escape **`~`** (use **`$HOME`** instead).

5. Every unix command return result code. **`0`** means success. Other values are error codes.

6. To finish script execution run

    ```bash
    exit exit_code
    ```

7. **`$#`** - the number of script arguments

8. **`$?`** - exit status for last command

9. **`${#var}`** - the length of the string in a variable

10. **`--`** - end of options command.
    * Supported by many UNIX commands
    * Arguments after this will not be interpreted as options

## Variables

1. To create variable and assign value to it (do not put space before or after **`=`** )

    ```bash
    var_name=var_value
    ```
2. To extract variable value use

    ```bash
    $var_name
    ```
3. Bash variables have no type. Basically just store a string.
4. To assign combo value use the following

    ```bash
    greeting=”hello”
    user_greeting=”$greeting, $USER”
    ```
5. Good habit to surround usage of ALL your variables with quotes
    * wrong: **`$x`**
    * right: **`“$x”`**
6. To tell bash where you variable ends use braces **`{}`**

    ```bash
    ${var_name}
    ```
7. To read a line of input into variable use

    ```bash
    read var_name
    ```
8. All variables have attributes. To set attribute use declare.

    **`declare -p var_name`** - print attributes for a variable

9. To set variable as readonly

    ```bash
    declare -r const_name=”some value”
    ```
10. To export variable to child script use:

    ```bash
    export var_name
    declare -x var_name
    ```
    Note: you can not pass variable from child scirpt to parent. When you pass variable to sub process the attributes of this variables do not get passed.

11. Arrays
    * **`declare -a var_name`**  - declares an array variable
    * **`x[0]=”some”`** - assigns value to 0 element of x array
    * **`${x[0]}`** - retrives 0 value from an array
    * **`${x[@]}`** or **`${x[*]}`** - retrieves all values from an array
    * **`ar=(1 2 3 a b c)`** - creates array of 6 elements
    * **`${#var_name[@]}`** - gets the array length
    * **`${!var_name[@]}`** - gets all array indices (there can be gaps in the indices)
    * **`declare -A var_name`**  - declares dictionary<br>
    More info http://goo.gl/g6xtca

12. To put some string multistring value to a variable use
    ```bash
    var_name=$(cat <<some_custom_tag
        multiline string
    some_custom_tag
    )
    ```
13. Default value
    * **`${var:-value}`** - will evaluate to “value” if var is empty or unset
    * **`${var-value}`** - will evaluete to “value” if var is unset
    * **`${var:=value}`** - if var was empty or unset, this evaluates to “value” and assigns it to var
    **`${var=value}`** - if var was unset, this evaluates to `value` and assigns it to var<br>
    More information about parameter expansions
