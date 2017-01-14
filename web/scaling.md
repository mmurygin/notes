# Scaling

## Techniques for scaling

1. Optimize code
2. Cache complex operations
3. Upgrade machines
    * more memory
    * more disk space
    * faster CPU
4. Add more machines

## Caching

1. **Caching** - storing the result of an operation so that future requests return faster
2. When do we cache?
    * computation is slow
    * computation will run multiple times
    * when the output is the same for a particular input
    * hosting provider charges for database access
3. **Cache Stampede** - when multiple users make query simultaneously, all of the get noting from cache, and all of them hit database forcing database to be overloaded. The solution is to **override** cache instead of cleaning it.