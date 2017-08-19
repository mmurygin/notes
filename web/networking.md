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
1. **Protocol** is a set of rules and procedures used for communication

2. **Host** - a machine on the internet that can hosts services

3. **Endpoints** - the two machines or programs communication over the connection

4. **DNS** (Domanin Name System) has a lot of records
    * **A-Record** - used to find the address of a computer connected to the internet from a name
    * **The Resolver** - the DNS client code built into all operating systems

5. **Search Domain**- a setting in the resolver configuration that makes the resolver look up names inside domain
6. To show a machine IP address:

    ```bash
    ip addr show
    ```
    ```bash
    ifconfig
    ```

7. To ping a server use

    ```bash
    ping | -c count |  <server>
    ```

8. To send an HTTP request with netcat use:

    ```bash
    printf 'HEAD / HTTP/1.1\r\nHost: <host>\r\n\r\n' | nc <server> <port>
    ```

9. To listen to a port with netcat use

    ```bash
    nc -l <port>
    ```

10. To get an information about domain use

    ```bash
    dig <domain>
    ```
