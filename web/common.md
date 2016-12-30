## Table of Content

- [GET and POST](#get-and-post)
- [REST](#rest)
- [Cookies](#cookies)

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

1. GET<br>
    `/users` - get users list<br>
    `/users/max` - get max<br>
2. PUT<br>
    `/users/max` - updates max entity<br>
3. POST<br>
    `/user/` - create new user<br>
4. DELETE<br>
    `/users/max` - delete user<br>

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

    `Set-Cookie: user_id=12345`

4. If you want to set more than 1 cookie, just send multiple `Set-Cookie` header

5. Browser send cookies with `cookies` header:

    `cookie: user_id=12345;session_id=1238`

6. Cookie domain restriction:

    **`Set-Cookie: user_id=12345; domain=www.site.com`**

    * Browser will only set cookie if server domain is the same or subdomain of domain in header (ends with that domain in cookie).<br>
        `domain=foo.www.site.com` - this works<br>
        `domain=site.com` - this doesn't work<br>

    * Browser will only send cookie to a server if server has the same domain as in cookie, or if server has top level domain<br>
        `www.site.com` - this works<br>
        `.site.com` - this works<br>

7. 
