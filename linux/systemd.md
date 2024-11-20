# SystemD

## Documentation

1. List available systemctl types

    ```
    systemctl -t help
    ```

1. All directives

    ```
    man systemd.diretives
    ```

1. Configs for [unit,socket,timer]

    ```
    man systemd.{unit,socket,timer}
    ```

## Status

1. System status

    ```
    systemctl status
    ```

1. List available units by type

    ```
    systemctl list-unit-files -t service
    ```

## Timers

1. Timer directives

    ```
    man systemd.timer
    ```

1. Examples on how to configure timers

```
man systemd.time
```

1. Active timers

    ```
    systemctl status *timer
    ```
