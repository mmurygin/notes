# Linux Throubleshooting

## Procedure
1. Define the issue
    * be specific
    * provide details
    * be aware that reported issues could be symptoms of another problem
1. Narrow down the issue.
1. Gather information
    * logs
    * monitoring
    * `strace` for syscalls
    * `tcpdump`, `ping`, `tracepath`, `traceroute` for network issues
1. Form a hypothesis
1. Test the hypothesis
    * if the hypothesis is wrong go to step 1,2 or 3
1. Fix the problem
1. Verify that test is successfull


## Gathering data
1. journalctl
    * to show only messages with specific log level:
        ```bash
        journalctl -p emerg..err
        ```

    * information from the last boot

        ```bash
        journalctl -xb
        ```

    * time filters

        ```bash
        journalctl --since '2018-04-24 17:00:00' --until '2018-04-24 18:00:00'
        ```

    * get verbose output

        ```bash
        journalctl -o verbose
        ```

1. `/var/log/messages`
1. `/var/log/audit/autid.log`
1. `/var/log/secure`
