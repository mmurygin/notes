## Get and Post

| GET | POST |
| --- | ---- |
| Add parametrs to url | Do not add parametrs to url |
| Used for fetching data | Used for updating data |
| Affected by maximum url length | No maximum length |
| ok to cache | not ok to cache |
| should not change the server | it is ok to change the server |


## REST

**REST** - REpresentation State Transfer. An Architectural style for building APIs

1. GET

    `/users` - get users list
    `/users/max` - get max

2. PUT

    `/users/max` - updates max entity

3. POST

    `/user/` - create new user

4. DELETE

    `/users/max` - delete user
    