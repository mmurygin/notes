# Debugging using gdb

- [Before debugging](#before-debugging)
- [Running debuger](#running-debuger)
- [Getting information](#getting-information)
- [Execution](#execution)
- [Line execution](#line-execution)
- [Break and watch](#break-and-watch)
- [Stack Inspection](#stack-inspection)
- [Variable and sources](#variable-and-sources)

## Before debugging
1. Complile your programm with debug information

    ```bash
    gcc -g<0,1,2,3> # 3 shows all debug info
    ```

1. Turn off optimization level

    ```bash
    gcc -o<0,1,2,3> # 0 means without optimization
    ```

1. To show to the compilator that we will use gdb to debug use. Within linux platform it's the same as `gcc -g3`

    ```bash
    gcc -ggdb
    ```

## Running debuger
1. Run your executable

    ```bash
    gdb ./executable
    ```

1. If we have core dumb (memory image before process crash) and want to restore this moment in memory.

    ```bash
    gdb ./executable -c core
    ```

    * to record core dumb we need to run the following command before our executable file

        ```bash
        ulimit -c unlimited
        ```

1. If we want to attach to working process

    ```bash
    gdb -p pid
    ```

## Getting information
1. help <command>
1. **`info`** - show info about current state
    * args
    * breakpoints
    * watchpoints
    * registers
    * threads
    * signals
1. **`where`** - shows stack

## Execution
1. **`r/run`**
1. **`r/run args`**
1. **`c/continue`**
1. **`c/continue breaks-number-to-ignore`** - continue ignore break
1. **`finish`** - continue to the end of function
1. **`kill`**
1. **`q/quit`**

## Line execution
1. **`step`** (into a function)
1. **`next`** (next line of code)
1. **`until line-number`**
1. **`stepi/nexti`** step for assembler instruction


## Break and watch
1. **`break function/line`**
1. **`break +/- relative-position`**

    ```bash
    break +3
    ```

1. **`break filename:line`**
1. **`break filename:function`**
1. **`break ... if condition`**
1. **`break line thread tid`**
1. **`enable/disable`**
1. **`watch condition`**

## Stack Inspection
1. **`bt/backstrace`** - show stack frames
1. **`f/frame [number]`** - change to frame to [number]
1. **`up/down number`** - go up and down inside stack
1. **`info frame`** - go into stack frame

## Variable and sources
1. **`list +n -n`** - show source code
1. **`set listsize num`** - set source code size
1. **`p/print[format] variable`** print using format (x, o, d, f, c)
