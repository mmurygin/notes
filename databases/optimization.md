# Optimization

## Table Of Content
- [Schema Optimization](#schema-optimization)
- [Server Profiling](#server-profiling)

## Schema Optimization
1. **Smaller is better** - use the smallest acceptable type of column
2. **Avoid using NULL** values
3. **Chart is better than varchar** in the following cases:
    * All values have almost the same length (when maximum column lenght is almost the same as average length)
    * For short strings. Because varchar allocates 1 or 2 extra bytes to record the values length.
    * When values frequently changing. Because to change varchar you often need to allocate new memory
4. **Varchar** columns should have only **necessary length**. Because MySQL often allocates fixed-size chunks of memory to hold values internally. This is especially bad for sorting or operations that use in-memory temporary tables.
5. In most cases it is better to use timestamp instead of datetime. It’s two times more space efficient
6. For boolean types you should use BIT(1).
7. For ID its better to use integer column


## Server Profiling
1. Best way to find the slow queries it’s to analize slow query log. At first you need to turn this options on, then confuge the logs destination, then restart sql server.
2. You can use pt-query-digest to analyze slow query logs