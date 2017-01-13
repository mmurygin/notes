# App Engine

## Memcache

1. To set value use

    ```python
    memcache.set("key", value)
    ````

    * where `value` is `string`, `tuple`, `dict`, `list`, datastore entities etc.

    * `value` should be pickleble value [pickle serialization](https://docs.python.org/2/library/pickle.html)

2. To get a value from memcache use

    ```python
    memcache.get("key")
    ```

## Debugging

1. Use `logging` library

    ```python
    import logging
    logging.debug(...)
    ```

2. To specify log level use

    ```
    --dev_appserver_log_level=info
    ```
