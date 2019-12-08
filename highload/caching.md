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

1. Non cachable objects HTTP headers

    ![Non cachable objects](./img/non-cachable-files-headers.jpg)

1. Private files cache headers

    ![Private files cache headers](./img/private-cache-headers.jpg)

1. Best Practices
    * do not use Cache-Control: max-age and Expires together, because it creates confusing behaviour
    * Do not use html caching metadags (like http-equiv="cache-control"). Again it dublicates cache logic and creates confusing behaviour

## Cache Types
1. Browsers Cache
1. Caching Proxy - setup up by enterprice companies or ISP.
    * this type of proxies loses popularity because of wide spreading of HTTPS (now proxies can not decrypt headers to examine traffic)

    ![Caching Proxy](./img/caching-proxy.jpg)

1. Reverse Proxy
    * public

        ![Public Reverse Proxy](./img/public-reverse-proxy.jpg)

    * private

        ![Private Reverse Proxy](./img/private-reverse-proxy.jpg)

1. CDN

    ![CND](./img/cdn.png)
