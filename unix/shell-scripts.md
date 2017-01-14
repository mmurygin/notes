# Shell scripts

## Table of Content

- [Common](#common)
- [Variables](#variables)


## Common

1. The is a good practise to put hash-band line at the beginning of each script

    ```
    #!/bin/bash
    ```
2. To make file executable use

    ```
    chmod u+x file_name
    ```
3. Single quotes escape everything inside.

4. Double quotes don’t escape **`$`**, **`{}`**. But escape **`~`** (use **`$HOME`** instead).

5. Every unix command return result code. **`0`** means success. Other values are error codes.

6. To finish script execution run

    ```
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

    ```
    var_name=var_value
    ```
2. To extract variable value use

    ```
    $var_name
    ```
3.  variables have no type. Basically just store a string.
4. To assign combo value use the following

    ```
    greeting=”hello”
    user_greeting=”$greeting, $USER”
    ```
5. Good habit to surround usage of ALL your variables with quotes
    * wrong: **`$x`**
    * right: **`“$x”`**
6. To tell  where you variable ends use braces **`{}`**

    ```
    ${var_name}
    ```
7. To read a line of input into variable use

    ```
    read var_name
    ```
8. All variables have attributes. To set attribute use declare.

    **`declare -p var_name`** - print attributes for a variable

9. To set variable as readonly

    ```
    declare -r const_name=”some value”
    ```
10. To export variable to child script use:

    ```
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
    ```
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

## Integer and Arithmetic Expressions
1. To declare integer variable use
    * **`declare -i var_name`** - add integer attribute to a varibale
    * **`declare +i var_name`** - removes integer attribute from a variable

2. C-like syntax for doing calculation
    * **`let n=100/2`** - sets variable n to integer

3. **`((..))`** - arithmetic expression.
    * **`((++x))**` - increment x variable
    * **`((p=x/100))`**
    * **`(p= $( ls | wc -l )*10)`**
    * To get the variable value we do not need to use $

4. `$((..))` - this is a substitution, not a command

5. if variable declared as integer:

    ```
    declare -i x
    x=”from max”
    echo $x # 0
    ```

6.  `((..))` can be used in if. In this case: `0` is `false`, anything else is `true`

## Debugging
1. To debug your bash script put ‘-x’ to shellband

    ```
    #!/bin/bash -x
    ```

2. To run script in debug mode use

    ```
    bash -x script_name
    ```

3. To show command only for some lines use

    ```
    set -x
    bash_code_to_debug
    set +x
    ```

4. The following flags available in set command
    * **-x** - prints each command with its arguments as it is executed
    * **-u** - gives an error when using an unitialized variable and exist script
    * **-n** - reads command byt do not execute
    * **-v** - print each command as it is read
    * **-e** - exists script whenever a command faild (but not with if, while, until, ||, &&)

5. shopt can set many options with -s, unset with -u
    * **`shopt -s nocaseblob`** - ignore case with pathname expansion
    * **`shopt -s extglob`** - enable extended pattern matching
    * **`shopt -s dotglob`** - include hidden files with path name expansion

## Conditions

1. The condition syntax

    ```
    if <condition or command>; then
        <code>
    elif <condition or command>; then
        <code>
    else
        <code>
    fi
    ```

2. **`[[ ... ]]`** - contition expression
    * not a command but special syntax
    * not quotes need around variables

3. Conditional expressions:

    | Expression | Meaning |
    | --- | ---- |
    | [[ $str ]] | str is not empty |
    | [[ $str = pattern ]] | checks unix pattern matching |
    | [[ $str=sometning ]] | always return true. **Do not do like this!** |
    | [[ $str = ~sometning ]] | checks regular expression matching |
    | [[ -e $filename ]] | checks if file exists |
    | [[ -d $dirname ]] | checks if directory exists |

    * Spaces around the expression are very important
    * Same for switches (-e) and equals sign
    * `=` is the same as `==`

4. To get the info about conditional usage use<br>
    `help [[`<br>
    `help test`<br>

5. To compare numbers (only integer supported)<br>
    **`[[ arg1 OP arg2 ]]`** -  where OP: -eq, -ne, -lt, -gt

6. The is the following operators: `!`, `&&`, `||`

7. Some usefull regex:<br>
    **`[0-9]?`** - will match a single digit or nothing at all<br>
    **`[a-z]*`** - will match any lowecase text or nothing at all
