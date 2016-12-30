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

1. GET  
    `/users` - get users list  
    `/users/max` - get max  
2. PUT  
    `/users/max` - updates max entity  
3. POST  
    `/user/` - create new user  
4. DELETE  
    `/users/max` - delete user  

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

    `Set-Cookie: user_id=12345;`

4. If you want to set more than 1 cookie, just send multiple `Set-Cookie` header

5. Browser send cookies with `cookies` header:

    `cookie: user_id=12345;session_id=1238`
