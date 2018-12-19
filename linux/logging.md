# Logging

## systemd-journald
1. By default logs are stored in memory.
1. `stdout` and `stderr` from units by default goes to `systemd-journald`
1. View logs
    * **`journalctl -xe`** - show errors
    * **`journalctl --list-boots`** - list all boots (the same as last)
    * **`journalctl -b -2`** - logs for last 2 boots
    * **`journalctl --since "2017-05-05 00:01" --until "2017-05-06 01:40"`** - logs for date range
    * **`journalctl --since "10 hours ago"`** - logs for last 10 hours
    * **`journalctl -u unit-name.service -f`** - logs for specific units
    * **`journalctl _UID=1001`** - logs for user with id 1001
    * **`journalctl -n 3 -p crit`** - last 3 critical logs
1. Operate with logs
    * **`journalctl --flush`** - put all log data from memory into disk
    * **`journalctl --rotate`**
    * **`journalctl --sync`**
    * **`journalctl --vacuum-size=1G`** - cleanup old logs to that log size become no more than 1G
    * **`journalctl --vacuum-time=1years`** - cleanup logs older than 1 year
    * **`journalctl --disk-usage`** - show logs disk usage
