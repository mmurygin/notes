# Cashing

## Common

1. **Caching** - storing the result of an operation so that future requests return faster
1. When do we cache?
    * computation is slow
    * computation will run multiple times
    * when the output is the same for a particular input
    * hosting provider charges for database access
1. Types of cashing
    * **Client-side cashing** - browser cashe data, server notify browser to update it
    * **Reverse Proxy cashing** - cashe HTTP requests with something like Apache, nginx
    * **Server-side cashing** - cashe some requests on server side, e.g. using Redis

## Techinics
1. Cache HTTP requests with `cache-control`, `ETag` and `If-None-Match` headers.
1. Put writes in some local cashe, and then implement butch write.
1. If we want to increase resilence we could implement the capability to get _stale_ data from cache if downstream service is down (in many cases it is better that returning 5xx error). In this case we should update cache periodically.

## Issues
1. **Cache Stampede** - when multiple users make query simultaneously, all of the get noting from cache, and all of them hit database forcing database to be overloaded. The solution is to **override** cache instead of cleaning it.