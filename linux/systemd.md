# SystemD

## Documentation

* List available systemctl types

```
systectl -t help
```

* All directives

```
man systemd.diretives
```

* Configs for [unit,socket,timer]

```
man systemd.{unit,socket,timer}
```

## Status

* System status

```
systemctl status
```

* List available units by type

```
systemctl list-unit-files -t service
```

## Timers

* Timer directives

```
man systemd.timer
```

* Examples on how to configure timers

```
man sytemd.time
```

* Active timers

```
systemctl status *timer
```
