# Monitoring
  * [Philosophy](#philosophy)
    + [Goals](#goals)
    + [Common Scheme](#common-scheme)
    + [Anti-Patterns](#anti-patterns)
    + [Design Patterns](#design-patterns)
  * [Metrics](#metrics)
    + [Types](#types)
    + [Best Practices](#best-practices)
    + [RED](#red)
    + [USE](#use)
    + [The Four Golden Signals (google)](#the-four-golden-signals-google)
    + [Additional useful metrics](#additional-useful-metrics)
  * [Metrics Examples](#metrics-examples)
    + [Virtual Machine](#virtual-machine)
    + [Database Metrics](#database-metrics)
    + [Message Queues](#message-queues)
    + [Cache](#cache)
    + [DNS](#dns)
  * [Visualization](#visualization)
  * [In Real Life](#in-real-life)

## Philosophy

### Goals
1. **Alerting**
1. **Troubleshooting**
1. **Capacity Planning**
1. **Prioritization**
    * calculate error budget and determine where to focus effort: new features or reliability.
1. **Business Analysis**
1. **Experiments** - compare before and after

### Common Scheme
![Monitoring Scheme](./img/monitoring-scheme.png)

### Anti-Patterns
1. Tool Obsession
    * Not base your decisions on tools you have
    * Try to have the minimal amount of tools to fullfil your needs, at it simplifies the system. But at the same time don't be afraid of introducing a new tool, if it brings a benefits. The general rule is: **if a need can be fulfilled with a tool which you already use - reuse this tool, other way introduce a new one**
1. Monitoring-as-a-Job
    * it's good to have observability team, which goal is to build monitoring infrastructure that developer teams will use
    * observability team should not setup metrics and alerts, because this team does not now the application insight
    * developer teams should use the monitoring tools provided by observability team to setup alerts and monitoring
1. Checkbox Monitoring - having a monitoring just to say that you have it
    * you record system load, CPU usage, memory utilization but when your service is down you don't know why.
    * you ignore alerts
    * you are checking system for metrics every five minutes or even less
    * you aren't storing historical metric data
    * **OS metrics are not useful for alerting**
1. Using Monitoring as a Crutch
    * Monitoring should be the only one solution for poorly built app problem. In addition to monitoring it's good to improve app itself.
    * Monitoring doesn't fix broken things, so don't forget to fix issue found with monitoring.
1. Manual configuration
    * Adding services / servers to the monitoring should be automated. Otherwise it takes from you unnecessary amount of time, it also complicates and slows down the monitoring process. Like if a developer needs to spend an hour trying to add server to monitoring - he will likely ignore it, on the other hand if it takes just a few minutes - he will do it.
    * If you have a runbook (readme) with a list of manual steps to make something work, consider automating this list of steps.

### Design Patterns
1. Composable monitoring - use multiple specialized tools and couple them loosely together.
    * Collect data (pull or push)
    * Storage data - usually time series database (TSDB)
    * Analysis / Reports
    * Alert - alerting is not the only goal of monitoring
1. **Start monitoring from the users perspective**. Create SLIs based on service usage by the end user. This is the most important metrics, all the web service metrics and infrastructure metrics come later and usually they are not used for alerting, only for troubleshooting.
1. **Buy, Not Build** - always start with existed monitoring solution (buy some), and only if you outgrown this tool you could consider creating your own.
1. **Continual Improvement** - don't stop when you have something working.
1. **Test your monitoring system**


## Metrics

### Types
1. Business monitoring - how well we perform as a business.
    * purchases per second (for e-commerce)
    * views per second for blog / news
1. Frontend Monitoring
    * Can be done with sending logs from frontend
    * Or by using Applicaiton Performance Monitor (APM)
1. Application (backend) monitoring
    * Requests
    * Errors
    * Duration
1. Software (platform) monitoring
    * databases
    * container platform
1. System monitoring (physical hosts)
    * CPU
    * Memory
    * Disk IO
1. Networking monitoring


### Best Practices
1. Every collected metric should have a [purpose](#goals)
1. Worry about your tail
1. Use the combination of **whitebox** and **blackbox** monitoring.
    * with white box monitoring you could analyze the internal metrics for you application
    * if the server is down or DNS is down you white box monitoring won't see it.
1. As simple as possible, no simpler
    * the rules that catch real incidents most often should be as simple, predictable, and reliable as possible
    * data collection, aggregation, and alertig configuration that is rarely exercised should be up for removal
    * signals that are collected, but not exposed in any prebacked dashboard nor used by any alert, are candidates for removal


### RED
Useful for online-serving systems (line REST API).
1. **Requests**
1. **Errors**
1. **Duration**
    * use percentiles


### USE
Useful for ofline-servicing systems and batch jobs.
1. **Utilization** - how full your service is
1. **Saturation** - the amount of queued work
1. **Errors**


### The Four Golden Signals (google)
1. **Latency**
    * use percentiles
1. **Traffic**
1. **Errors**
1. **Saturation**
    * CPU
    * Memory
    * Disk IO
    * Disk free size
    * Open file descriptors / Connections
    * Threads
    * GoRoutines
    * Queue size


### Additional useful metrics
1. **Dependencies** - you should always monitor your dependencies. So that, in case of emergency you could immediately understand that service dependency is the root cause of issue.
    * the health of dependency
    * availability, latency and errors for all requests to dependency.
1. **Intended Changes** - changes is the number one source of any issues. It's very useful to have all the change logs in one place. Type of changes:
    * release of new software version
    * configuration update
    * infrastructure update
    * hardware update
1. **External uptime checks.**
1. **Blackbox monitoring.**
1. **Number of alerts per service.**

## Metrics Examples
### Virtual Machine
1. CPU Usage
1. Memory
1. Disk Traffic
1. Network Usage
1. Clock Drift

### Database Metrics
1. Connections (threads in mysql)
1. QPS
1. Queries duration
1. Replication lag
1. IOPs
1. Disk Usage
1. The correctness of data
    * to prevent the cases when we slowly loose data

### Message Queues
1. Queue Length
1. Publish Rate
1. Consumption rate

### Cache
1. Cache evicted ratio
1. Cache hit ratio (hit / (hit + miss)

### DNS
1. Zone transfers (when slave sync with master)
1. QPS
    * at least QPS for server
    * better QPS per zone
    * the best QPS per view

## Visualization
1. Stack related graphs vertically.
1. Use the correct (and expected) scale and unit in your axes.
1. Add thresholds to graphs when relevant.
1. Enable shared crosshairs across graphs (possible in grafana).

## In Real Life
1. Google Monitoring

    ![Global monitoring](./img/global-monitoring.png)
