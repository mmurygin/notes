# Shell scripts

## Table of Content

- [Common](#common)
- [Variables](#variables)
- [Integer and Arithmetic Expressions](#integer-and-arithmetic-expressions)
- [Debugging](#debugging)
- [Conditions](#conditions)
- [Control flow](#control-flow)
- [Input and Output](#input-and-output)
- [Stream and IO Redirection](#stream-and-io-redirection)
- [Handling script parametrs](#handling-script-parametrs)
- [Functions](#function)
- [Strings](#strings)
- [Running Scripts](#running-scripts)

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
    * **`declare -A var_name`**  - declares dictionary
    * More info http://goo.gl/g6xtca

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
    * **`${var=value}`** - if var was unset, this evaluates to `value` and assigns it to var<br>
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

## Control flow

1. **`while`** - repeats code while test true

    ```
    while test; do
        code to be repeated
    done
    ```

2. **`until`** - repeats code while test false

    ```
    until test; do
        code to be repeated
    done
    ```

3. **`for`** - assign each word in words to var . Stops when no words are left. **Do NOT** quote words.

    ```
    for VAR in WORDS; do
        code
    done
    ```

    ```
    for (( i=0; i<max; i++ )); do
        code
    done
    ```

    * Note: Inside for there is an arithmetic expression. So we do not need to use `$` to get variable value

4. **`case`**

    ```
    case WORD in
        PATTERN1)
            code for pattern1;;
        PATTERN2)
            code for pattern2;;
        ....
        PATTERNNn)
            code for pattern n;;
        ?)
            code for not matching pattern
    esac
    ```

5. **`||`** and **`&&`** - combines multiple commands depending on their result. Commands are executed in order, they do not use any priorites
    * `[[ $1 ]] || echo “missing argument”` - print error when there is no argument
    * `[[ $1 ]] || echo “missing argument” && exit 1` - always exits!!!
    * `[[ $1 ]] || { echo “missing argument” >&2; exit 1; }` - good way to check input params

6. **`{ }`** - group commands
    * will group them into a single statement
    * can use I/O redirection for the whole group
    * use the group in an if statement or while loop
    * return status is that of the last command in the group
    * separate the commands with new linews or semicolons, use spaces around braces
        * `{ cmd1; cmd2; cmd3 }`

## Input and Output

1. **`echo`** - display a line of text

2. **`printf`** - format and print data
    * can do more sophisticated output than echo
    * uses a format string for formatting
    * will not append a newline by default.

3. To put argument in printf command use

    ```
    printf "hello %s, how are you?\n" $USER
    ```

5. To put printf output to a variable use -v option

    ```
    printf -v var_name “some_str”
    ```

4. [More Info About printf](http://wiki.bash-hackers.org/commands/builtin/printf)

5. **`read`** - reads input into a variable

    ```
    read x
    ```

    * without variable name put input to variable **`REPLY`**
    * **`-n`** stop read at the new line
    * **`-N`** reads exact number of characters
    * **`-s`** will suspess otput (useful for passwords)
    * **`-r`** dissallow escare sequences, line continuation (best practice to use this option)
    * to read 2 variables at one time:

        ```
        read var_1 var_2 var_1_value var_2_value
        ```
        * everything after the last separator goes to the last variable
        * to change default separator (space) you could change variable IFS

## Stream and IO Redirection

[An Introduction to Linux I/O Redirection](https://www.digitalocean.com/community/tutorials/an-introduction-to-linux-i-o-redirection)

1. **`0`**: Standart Input (stdin)

    ```
    /dev/stdin
    ```

2. **`1`**: Standart Output (stdout)

    ```
    /dev/stdout
    ```

3. **`2`**: Standart Error (stderr)

    ```
    /dev/stderr
    ```

4. **`/dev/null`** - discards all data send to it
5. Input redirection: **`<`**

    ```
    grep milk < shoppingnotes.txt
    ```

6. Output redirection: **`>`**

    ```
    ls > listing.txt
    ```

    * **`>`** - will overwite existing files
    * **`>>`** -  appends to the end of a file

7. Pipes

    ```
    ls | grep x
    ```

8. Redirect a specific stream with `N>` (where N is the number of stream, `1` is default )

    * **`cmd 2>/dev/null`**  - discards all errors

9. Redirect **to** a specific stream with `>&N`

    * **`>&2`** - sends output to stderr
    * **`2>&1`** - redirects stderr into stdout

10. To redirect all I/O for the whole script use exec (usefull for logging)

    ```
    exec >logfile 2>errorlog
    ```

11. A command in a pipeline runs in a subshell

    ```
    declare -i count=0
    ls | while read -r; do ((++count)); done  # do not increases global count
    ```

12. Examples

    * **`command > file`** - redirects out of a command to a file
    * **`command > /dev/null`** - discards out of a command
    * **`command 2> file`** - redirects standart error stream to a file
    * **`command | tee file`** - redirects standart ouput of the command to a file and backward to output
    * **`command  > logfile 2>&1`** - sending both error and ouput to a single file


## Handling script parametrs

1. Special variables
    * **`$1, $2…`** - gets the argument number 1, 2 and etc
    * **`“$@”**` - equivalent to `“$1”, “$2”, ..,  “$N”`
    * **`“$*”`** - equivalent to `“$1 $2 $3… $N”`
    * **`$#`** - get the number of script arguments
    * **`$0`** - holds the name of the script as it was called

2. **`shift`** - removes the first argument ($2 => $1, $3 => $2)
    * `shift n` - removes first n arguments

3. **`getopts`**  - parse script options (like -p). Stops on an argument which does not starts with -.

    ```
    getopts opt_string var_name
    ```

    * **opt_string**
        * a list of expected options
        * `“ab”` will let your script handle an option `-a` and/or `-b`
        * Append `:` to options that take an argument
        * `“a:b”` will let `a` take an argument, but not `b`
    * **var_name**
        * The name of a variable
        * Every time you call getopts, it will place next option int $var_name
    * **`OPTARG`** - argument of an option
    * **`OPTIND`** - holds the index of the next argument to be processed
    * **`getopts`** returns false when no more options are left
    * **`getopts`** handles erros for you. If anything goes wrong, the option variable var_name holds **`“?”`**

4. Process getopts errors by yourself
    * start optioon strgin with a colon (silent mode)
        * `“:bsr”`
    * Unknown option:
        * **`“?”`** will be putted in `var_name`
        * actual option in `OPTARG`
    * Missing option argument
        * `“:”` in option `var_name`
        * actual option in `OPTARG`

## Functions

1. To define function use

    ```
    function_name () { .. }
    ```

2.  Functions are like any command (or little shell script inside another shell script)
    * you can pass arguments to it

    * you can use input\output redirection

3. Exit a function with return

    * returns a status code, like exit

    * without a return statement, function returns status of last command

4. To **return value** from function use one of the following:
    * print to stdout

        ```
        sum () {
            echo $(( $1 + $2))
        }
        ```

    * change global variable value (all variables by default globals)
    * use status  of last comman

        ```
        start_with_a () {
              [[ $1 == [aA]* ]];
        }
        ```

5. To define function local variable use:

    ```
    declare var_name
    local var_name
    ```

6. To export function to subprocess use

    ```
    export -f function_name
    ```

7. Redirection
    * redirection is allowed immeadiately after function definition
    * will be executed every time when function is run

        ```
        fun () {} >&2
        ```
    * you can not pipe some output to the function
        * `ls | some_func` - function will not get input from the ls output

## Strings

1. Get the length of the string

    ```
    ${#var_name}
    ```

2. Removing part of a string

    * Example string: `i=/Users/reindert/demo.txt`

    * **`${var_name#pattern}`**  - removes the shortest match from the begining of a string

        ```
        ${i#*/} => User/reindert/demo.txt
        ```

    * **`${var_name##pattern}`**  -removes the longest match from the begining of a string

        ```
        ${i##*/} => demo.txt
        ```
    * **`${var_name%pattern}`**  - removes the shortest match from the end of a string

        ```
        ${i%.*} => /User/reindert/demo (remove extension)
        ```

    * **`${var_name%%pattern}`**  - remove the longest match from the end of a string

        ```
        ${i%%*.} => txt
        ```

3. Search and Replace.

    * Example string `i=mytxt.txt`

    * **`${var/pattern/string}`** - substitute first match with a string

        ```
        ${i/txt/jpg} # myjpg.txt
        ```

    * **`${var//pattern/string}`** - substitute all matchs with a string

        ```
        ${i//txt/jpg} # myjpg.jpg
        ${i//[jx]/a} # matat.tat
        ```

    * **`${var/#pattern/string}`** - matches begining of the string
    * **`${var/%pattern/string}`** - matches the end of the string

        ```
        ${i/%txt/jpg} # mytxt.jpg
        ```

## Running Scripts

1. To import code in the crrent shell proces use

    ```
    source myscript
    ```

    * `source` has an allias **`.`**

2.  To run script in backgroud use

    ```
    ./myscript &
    ```

3. To keep you script running when you exit the terminal session use

    ```
    nohup myscript &
    ```

4. To run script with lower priority

    ```
    nice myscript
    ```

5. To run script with lower priority in background use

    ```
    nohup nice myscript &
    ```

6. At will execute your script at a specific time

    ```
    at -f myscript noon tomorrow
    ```

7. **Cron** will execute your script according to a schedule. Also we could use **upstart** for this purpose