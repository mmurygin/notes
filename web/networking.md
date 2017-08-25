# Networking

## Как происходит HTTP запрос
1. Браузер анализирует введенныё URL и извлекает имя хоста
1. Используя систему `DNS` браузер преобразует домен в `ip` адрес
1. Устанавливает `TCP` соединение с web-сервером
1. Если протокол `https`, устанавливает `TLS` соединение поверх `TCP`
1. Формирует `HTTP` запрос, отправляет его, получает в ответе документ
1. Браузер закрывает соединение (для HTTP/1.0)
1. Браузер анализирует (parse) HTML и загружает доп. ресурсы (`css`, `img`, `javascript`)
1. Браузер отображает (rendering) HTML страницу (по мере получения её кода)

## Стэк сетевых протоколов
![Network Protocol Stack](../images/network-protocol-stack.png)
1. `HTTP` и `TLS` реализованна в браузере или веб сервере
1. `TCP` и `IP` реализованна в ОС
1. Порядок работы на клиенте:
    1. `HTTP`: формируется запрос. Вызывает функцию протокола `TLS`.
    1. `TLS`: шифрует данные, вызывает функцию протокола `TCP`.
    1. `TCP`: добавляет контрольные суммы, делит на сегменты если это нужно, ставит свои флаги и передаёт данные протоколу более нижнего уровня (`IP`)
    1. `IP`: передача данных через сеть интернет
1. Порядок работы на сервере: `IP` => `TCP` => `TLS` => `HTTP`.

## Common
1. **`traceroute`** - tracks  the route packets taken from an IP network on their way to a given host.

    ```bash
    $ traceroute google.com
    traceroute to google.com (173.194.44.72), 30 hops max, 60 byte packets
        1  192.168.10.1 (192.168.10.1)  0.282 ms  0.268 ms  0.396 ms
        2  bsr02.tomsk.ertelecom.ru (109.194.32.69)  2.716 ms  2.886 ms  3.306 ms
        3  lag-2-436.bgw01.tomsk.ertelecom.ru (109.194.40.22)  1.259 ms  1.449 ms  1.462 ms
        4  72.14.215.165 (72.14.215.165)  41.599 ms  47.736 ms  41.773 ms
        5  72.14.215.166 (72.14.215.166)  41.787 ms  41.766 ms  41.761 ms
        6  66.249.94.94 (66.249.94.94)  42.176 ms  41.686 ms  41.857 ms
        7  108.170.232.47 (108.170.232.47)  42.602 ms  42.585 ms  42.903 ms
        8  173.194.44.72 (173.194.44.72)  42.846 ms  42.518 ms  42.616 ms
    ```

1. To show a machine IP address:

    ```bash
    ip addr show
    ```
    ```bash
    ifconfig
    ```

1. To ping a server use

    ```bash
    ping | -c count |  <server>
    ```

1. To send an HTTP request with netcat use:

    ```bash
    printf 'HEAD / HTTP/1.1\r\nHost: <host>\r\n\r\n' | nc <server> <port>
    ```

1. To listen to a port with netcat use

    ```bash
    nc -l <port>
    ```

1. To get an information about domain use

    ```bash
    dig <domain>
    ```
