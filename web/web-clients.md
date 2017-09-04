# Web-клиенты

## Table of Content

- [Библиотеки](#Библиотеки)
- [Консольные клиенты](#Консольные-клиенты)
- [Сценарий работы web приложения в браузере](#Сценарий-работы-web-приложения-в-браузере)

## Библиотеки
1. Библиотеки в языках програмирования: `libcurl`, `urllib`...
1. Предоставляют максимум опция для работы с `HTTP`
1. Осуществляют кодирование/декодирование данных
1. Перенаправления, куки - опционально
1. Назначение: используются внутри других программ для простой работы с HTTP

    ```python
    import urllib
    import urllib2

    url = 'http://api.site.com/method/`
    values = {
        'argument1': 'value1',
        'argument2': 'value2'
    }
    headers = { 'User-Agent': 'python urllib2' }
    data = urllib.urlencode(values)
    req = urllib2.Request(url, data, headers)
    response = urllib2.urlopen(req)
    result = response.read()
    ```

## Консольные клиенты
1. Консольные клиенты: `wget`, `curl`, `telnet`.
1. Назначение:
    * Автоматизация в shell-скриптах
    * Создание "статической копии сайта"
    * Отладка web-приложений
1. `telnet` - это простейшее средство отдадки. `telnet` открывает `tcp` соединение и связывает его с консолью, позволяя общаться с web-сервером напрямую с клавиатуры.
    ```
    $ telnet example.com 80
    Trying 93.184.216.34...
    Connected to example.com.
    Escape character is '^]'.
    GET / HTTP/1.1
    Host: example.com

    HTTP/1.1 200 OK
    Accept-Ranges: bytes
    Cache-Control: max-age=604800
    Content-Type: text/html
    Date: Mon, 14 Aug 2017 02:07:40 GMT
    Etag: "359670651+gzip"
    Expires: Mon, 21 Aug 2017 02:07:40 GMT
    Last-Modified: Fri, 09 Aug 2013 23:54:35 GMT
    Server: ECS (lga/1386)
    Vary: Accept-Encoding
    X-Cache: HIT
    Content-Length: 1270

    ...
    ```
1. `curl` - полноценный консольный клиент. Может загружать данные, в т.ч. рекурсиво, может писать отладочную информацию и т.д.

        * GET запрос с отображением отладочной информации

        ```
        curl -vv example.com
        ```

        * POST запрос с передачей доп. заголовоков

        ```
        curl -vv -d 'arg=1' -H 'X-Token: 123' example.com
        ```

## Сценарий работы web приложения в браузере
1. Пользователь вводит URL
1. Браузер загружает WEB страницу - HTML Документ
1. Браузер анализирует (parse) HTML и загружает доп. ресурсы
1. Браузер отображает (rendering) HTML страницу (по мере получения её кода)
1. Пользователь переходит по гиперссылке или отправляет форму
1. Цикл повторяется

## Сценарий работы современного приложения в браузере
1. Браузер загружает Web страницу
1. JavaScript загружает данные с помощью AJAX запросов
1. JavaScript обеспечивает полноценный UI на странице
1. Пользователь взаимодействует с UI, что приводит к вызову JavaScript обработчиков
1. JavaScript обновляет данные на сервере или загружает новые данные, используя AJAX
