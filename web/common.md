## Table of Content

- [Internet](#internet)
- [Загрузка страницы](#Загрузка страницы)
- [GET and POST](#get-and-post)
- [REST](#rest)
- [Cookies](#cookies)

## Internet
1. **`Internet`** - глобальная сеть передачи данных.
1. **`www`** (World Wide Web) - множество _взаимосвязанных документов_, располагающихся на машинах подключенных к Internet.
1. **`www`**  - Набор протоколов и клиентского ПО, позволяющих получать доступ к документам.

## Загрузка страницы
1. Браузер парсит заголовок и видит что `content-type` равен `text/html`.
1. После этого браузер начинает парсить тело запроса, и как только он находит ресурсы (`css`, `js`) он начинает их загружать.
1. По мере получения `html` кода страницы браузер сразу начинает её отображать.

## URL


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
