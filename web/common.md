## Table of Content

- [Internet](#internet)
- [Протоколы](#протоколы)
- [Загрузка страницы](#загрузка-страницы)
- [URL](#url)
- [GET and POST](#get-and-post)
- [REST](#rest)
- [Cookies](#cookies)

## Internet
1. **`Internet`** - глобальная сеть передачи данных.
1. **`www`** (World Wide Web) - множество _взаимосвязанных документов_, располагающихся на машинах подключенных к Internet.
1. **`www`**  - Набор протоколов и клиентского ПО, позволяющих получать доступ к документам.

## Протоколы
1. **`IP`** - глобальная адресация, передача в гетерогенной среде. Позволяет передавать пакеты по сети. Не гарантирует надёжную доставку.
1. **`TCP`** - обеспечивает надёжную передачу данных. Если протокол ответил что пакет доставлен, значит он реально доставлен. Данные отправляются в потоке.
1. **`DNS`** (Domain Name System) - система имён, позволяющая находить по имени хоста его _IP_ адрес.
1. **`HTTP, SSH, P2P, FTP`** - прикладные протоколы, решающие конкретные проблемы
    * **`FTP`** - протокол для загрузки и скачивания больших файлов
    * **`P2P`** - позволяет скачивать файлы с нескольких машин одновременно.
    * **`SSH`** - позволяет с помощью шифрования получить доступ к другой машине.
    * **`HTTP`** - расширенный протокол для передачи файлов, позволяет писать заголовки и т.д.


## Загрузка страницы
1. Браузер парсит заголовок и видит что `content-type` равен `text/html`.
1. После этого браузер начинает парсить тело запроса, и как только он находит ресурсы (`css`, `js`, `images`, `fonts`) он начинает их загружать.
1. По мере получения `html` кода страницы браузер сразу начинает её отображать.


## URL
1. **`URL`** - unified resouce locator
1. `http://server.org:8080/path/doc.html?a=1&b=2#part1
    * `http` - протокол
    * `server.org` - `DNS` имя сервера
    * `8080` -  TCP порт
    * `/path/doc.html` - путь к файлу
    * `a=1&b=2` - опции запроса
    * `path1` - якорь, положение на странице
1. Абсолютные и относительные URL
    * Для того чтобы получить документ с сервера, нужно знать абсолютный URL. Браузер сам разрешает преобразовывает относительные URL в соответствии с правилами ниже.
    * `http://server.org/1.html` - абсолютный URL
    * `//server.org/html` - абсолютный URL (schemeless), выбор протокола будет осуществляться относительно страницы с которой запрашивается ресурс (если страница получена по `http`, то переход будет осуществляться по протоколу `http`, если основная по `https` то переход по `https`)
    * `/another/page.html?a=1` - относительный URL (за основу берется имя домена)
    * `pictures/1.png` - относительно папки текущего документа
    * `?a=1&b=2` - этот же самый документ, полученный с другими параметрами
    * `#part2` - относительный (в пределах текущего документа)
1. Правила разрешения URL
    * `https://site.com/path/page.html`
    * + `http://wikipedia.org` = `http://wikipedia.org`
    * + `//cdn.org/jquery.js` = `https://cdn.org/jquery.js`
    * + `/admin/index.html` = `htpps://site.com/admin/index.html`
    * + `another.html` = `https://site.com/path/another.html`
    * + `?full=1` = `https://site.com/path/page.html?full=1`
    * + `#chapter2` = `https://site.com/path/page.html#chapter2`

## GET and POST

| GET | POST |
| --- | ---- |
| Add parametrs to url | Do not add parametrs to url |
| Used for fetching data | Used for updating data |
| Affected by maximum url length | No maximum length |
| ok to cache | not ok to cache |
| should not change the server | it is ok to change the server |


## REST

**REST** - REpresentation State Transfer. An Architectural style for building APIs.

1. GET
    `/users` - get users list
    `/users/max` - get max
2. PUT
    `/users/max` - updates max entity
3. POST
    `/user/` - create new user
4. DELETE
    `/users/max` - delete user
5. Urls with ended `/` and without (for example `/users/` and `/users`) should have the same handler. To implement such kind of behaviour we can use the following regex:<br>
    `/users/?`<br>

## Cookies

1. Browser Limit

    * 20 cookies per websie
    * cookie size **< 4kb**
    * only for one domain

2. Good uses

    * storing login information
    * stroing small amount of data to avoid hitting a db
    * tracking you for ads

3. To set cookie send header `Set-Cookie` from server:

    ```
    Set-Cookie: user_id=12345`
    ```

4. If you want to set more than 1 cookie, just send multiple `Set-Cookie` header

5. Browser send cookies with `cookies` header:

    ```
    cookie: user_id=12345;session_id=1238`
    ```

6. Cookie domain restriction:

    ```
    Set-Cookie: user_id=12345; domain=www.site.com
    ```
    * Browser will only set cookie if server domain is the same or subdomain of domain in header (ends with that domain in cookie).<br>
        `domain=foo.www.site.com` - this works<br>
        `domain=site.com` - this doesn't work<br>

    * Browser will only send cookie to a server if server has the same domain as in cookie, or if server has top level domain<br>
        `www.site.com` - this works<br>
        `.site.com` - this works<br>

7. By default Cookie is deleted when user closes the browser. To set expiration date use:

    ```
    Set-Cookie: user_id=12345; Expires=Tue, 1 Jan 2025 00:00:0 GMT
    ```
