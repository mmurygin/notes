# Analysis

  - [Types](#types)
  - [Attack Surface](#attack-surface)
  - [DNS / WHOIS / NETWORK](#dns--whois--network)
  - [Search Engines](#search-engines)
  - [Web Content](#web-content)


## Types
1. **Black box analysis** - when we analyse system without internal knowledge about it. Usually we have a goal to inject into the system.
    * zero information about the target
    * entry point
        * domain
        * ip address
        * person name
    * usually is used to find one vulnerability in the system and exploit it.
1. `White box analysys` - initially we have extended knowledge about the system (possibly provided by system owner).
    * The goal is to find all possible vulnerabilities

## Attack surface
### Definition
1. Изначально у нас есть одна точка входа. Для того чтобы повысить шансы успешной компрометации системы мы проводим анализ, с целью **увеличения поверхности атаки**. Т.е. находим смежные домены, адреса и т.д.
1. Методы первоначальной разведки:
    * пассивный анализ - полностью легальны, основанны на открытой информации
        * система доменных имён
        * поисковые системы
        * код клиентской части
        * карта сайта
        * содержимое `robots.txt`
        * социальные сети
    * активный анализ - не совсем легальны, может среагировать служба безопасности.
        * подбор DNS записей
        * подбор файловых путей
        * подбор портов
        * подбор пользователей

### Extending Attack Surface
#### DNS
1. Tools
    * `nslookup [-q=ns|mx|txt|...] {name} {server}`
        * `server` - это `DNS` сервер через который мы хотим произвести запрос
    * `host {name} {server}`
    * `dig [@server] {name} [type]`
1. Для расширения поверхности атаки можно попробовать найти все домены данной доменной зоны. К примеру, мы хотим атаковать `example.com`, полезно было бы узнать все используемые домены данной зоны, к примеру `www.example.com`, `my.example.com`, etc.
1. Пример поиска поддоменов для учебной зоны `zonetransfer.me`
    * ищем авторитетные днс сервера для искомой зоны

        ```bash
        nslookup -q=ns zonetransfer.me
        ```

    * ищем все поддомены

        ```bash
        dig zonetransfer.me @authorative-name-server axfr
        ```

#### Whois
1. Get network the IP belongs to:

    ```bash
    whois ip-address
    ```

1. Get domain owher data

    ```bash
    whois domain-name
    ```

#### Search Engines
1. Два слова без кавычек - ищется вхождение этих двух слов
1. Два слова в кавычках - ищется вхождение выражения в том виде, в котором оно записанно в кавычках
1. Специальные директивы
    * **`inurl`** позволяет задать шаблон url результата ответа
        * `inurl:admin` - выдат одним из результатов `targte.com/admin`
    * **`site`** - позволяет искать в пределах сайта
        * `site:target.com` - результаты будут с сайта `target.com`
    * **`filetype`** - поиск по разрешению файла
        * `filetype: pdf` - выдаст все pdf
    * **`cache`** - вернуть закэшированную копию.
        * `cache: target.com` - закэшированная копия сайта target.com
1. `robots.txt`  - директива для поисковых систем относительно того какие каталоги надо индексировать, а какие нет.
    * некоторые некомпетентные разработчики указывают в `rotobs.txt` какие-либо чувствительные с точки зрения безопасности адреса.

## Web Content
1. В исходниках сайта можно найти много интересной информации.
1. Коментарии разработчиков
1. Версии используемых frameworks
1. Пути и директории на сервере
1. Что-либо закоментированное. Можно получить интересный результат если запустить закоментированный код.
