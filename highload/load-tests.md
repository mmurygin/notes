# Performance Test

## Tools
1. Infrastructure tests
    * Disks - **fio**
    * CPU - **phoronix**
        ```
        phoronix-test-suite benchmark smallpt
        ```
    * network - **iperf3**
        ```
        # server
        iperf3 -s

        # client
        iperf3 -c server-ip
        ```

1. Test static load
    * **ab** - a lot of simultaneous requests to  the same url
    * **httperf** - requests by list of urls with delay
    * **sysbench** - for MySQL
    * **pgbench** - for PostgreSQL
    * **tcpreplay** - record all tcp packages and resend them

1. Test scripts
    * write custom scripts by requesting API and recording duration

1. Requirements compliance
    * Requests at specific time with specific concurrency with analytics
    * **Apache.JMeter** - simple scripts (Groovy, Java, JavaScript)
    * **wrk** - lua
    * **Yandex.Tank** - scalabe (Go, Python)


## Types
1. Load
    * increase load sequentially or step by step
    * Detect
        * degradation points
        * downtime point
        * error rate increase
1. Stability
    * Run some load for long time (the whole day or week)
    * Detect
        * resources leaks (memory, file descriptors and so on)
1. Stress
    * Run load which is more than expectable, then some low load, then some very high load and so on
    * Detect
        * How system recovers after temporary spykes in traffic
1. Volume
    * Run some load for long time
    * Detect
        * how fast datastore grows
        * what would happend after a year, 5 years, 10 years
1. ScalabilitY
    * Check if we add clones can we increase throughput
