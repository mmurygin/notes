# Python Tips

## Difference Between bytes and str
1. 1 byte != 1 character in string, it all depends on encoding
1. [What every SD should know about Unicode](http://www.joelonsoftware.com/articles/Unicode.html)
1. `open` function by uses os default encoding when tries to open a file (most of the time it's **utf-8**), so if you want to read a binary file use:

    ```python
    with open('data.bin', 'rb') as f:
        data = f.read()
    ```

## Iteration over the list
1. prefer to use `for x in arr` instead of `for i in range(arr)`
1. if you need to get index and value at the same time use `enumerate`

    ```python
    flavor_list = ['vanilla', 'chocolate', 'pecan', 'strawberry']

    for i, flavor in enumerate(flavor_list, 1):
        print(f'{i}: {flavor}')

    >>>
    1: vanilla
    2: chocolate
    3: pecan
    4: strawberry
    ```

## Use zip to process iterators in parallel

```python
names = ['Cecilia', 'Lise', 'Marie']
counts = [len(n) for n in names]

for name, count in zip(names, counts):
    print(name, count)
```

## Use warlus to assign and evaluate variable

```python
if count := fresh_fruit.get('lemon', 0):
    make_lemonade(count)
else:
    out_of_stock()
```
