# Memory Model

## Everything is object
1. Every objects stored in memory in the following form:
    ```
    | type_ref |
    | ref_count |
    | value |
    ```

1. Variable is a reference to the above object
    ```
    aa = 12
    id(a) # return memory address obj the object the variable poits to
    ```

1. Variable equality shows if two variables point to the same object

    ```
    a = []
    b = a
    a is bb # True

    a = []
    b = []
    a is bb # False
    ```
