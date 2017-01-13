# Python

## Table Of Contents

- [Common](#common)
- [Decorators](#decorators)
- [Requests](#requests)
- [JSON](#json)
- [Internationalization](#internationalization)
- [Logging](#logging)

## Common

1. To get items from dictionary use `items` method

    ```python
    obj = {'a': 1, 'b': 2}
    obj.items()
    ```
2. To set string as a row string (ignore any escaping) use `r`

    ```python
    my_str = r"this is my \nstring"
    ```

## Decorators

[The guide to Python's function decorators](http://thecodeship.com/patterns/guide-to-python-function-decorators/)

## Requests

1. To make a requests use `urllib2`

    ```python
    import urllib2
    response = urllib2.urlopen('http://example.com')
    response.read()
    ```

2. To get the result from response body use

    ```python
    response.read()
    ```

3. To get the headers from the response use

    ```python
    response.headers
    ```

## JSON

1. To work with json use **`json`** library

2. To init `dict` from `json` string:

    ```python
    j = '{"one": 1, "two": 2}'
    json.loads(j)
    ```

3. To get json string from object use `dumps`

    ```python
    json.dumps({'a': 1})
    ```

3. There are two ways to escape json
    * use `\\`
    ```python
    json.loads('{"story": "don\\"t"}')
    ```

    * use 'r'
    ```python
    json.loads(r'{"story": "don\"t"}')
    ```

## Internationalization

1. To implement internationalization use library called `gettext`

## Logging

1. Use python standart library

    ```python
    import logging
    logging.debug(...)
    ```
