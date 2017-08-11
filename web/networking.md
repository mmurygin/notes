# Networking

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

## Protocols
1. **`IP`** - глобальная адресация, передача в гетерогенной среде. Позволяет передавать пакеты по сети. Не гарантирует надёжную доставку.
1. **`TCP`** - обеспечивает надёжную передачу данных. Если протокол ответил что пакет доставлен, значит
