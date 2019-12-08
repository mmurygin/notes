# Caching

## Hit Ratio
1. **Cache Hit Ratio** = cacheHitCount / (cacheHitCount + cacheMissCount)
1. **Relative performance** = 1 / (cacheHitCost * cacheHitRatio + cacheMissCost * (1 - cacheHitRatio))
1. Factors which affect cache hit ratio
    1. Key Space - how many possible keys do we have
    1. Cache Size - how many object can we store
    1. Key TTL

## HTTP Cache
1. [MDN HTTP Caching](https://developer.mozilla.org/en-US/docs/Web/HTTP/Caching)
1. Static files headers

    ![Static files headers](./img/static-files-headers.jpg)
