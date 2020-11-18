# SRE

* [SRE Pyramid](#sre-pyramid)
* [SRE Tasks](#sre-tasks)
* [Observability](#observability)
* [Reliability](#reliability)
    + [Improving Reliability](#improving-reliability)
* [Managing Risks](#managing-risks)
    + [Risks definitions](#risks-definitions)
    + [Dowtime](#dowtime)
    + [Reducing risks](#reducing-risks)

## SRE Pyramid
![SRE Pyramid](./img/sre-pyramid.png)

## SRE Tasks
![SRE Tasks](./img/sre-tasks.png)

1. **Reduce Organization Silos** - reduce the barier between developers and operation guys.
    * share the ownership of production with developers
1. **Accept Failure as Normal**
    * blameless postmortem
    * make sure that failure won't happend the same way second time
    * use error budget
1. **Implement Gradual Change**
    * small releases instead of big one
    * canary releases
1. **Leverage Tooling & Automation**
    * automate manual work (eliminate toil)
1. **Measure Everyting**
    * amount of toil we have
    * the reliability of our systems

## Observability
* Everything that happens with our system is events (like http request, read packet from network, allocate more memory and so on). It will be great if we could collect all the events for observability, but it's not practical. That's why there are many ways to collect data and use it in a special ways:
1. **Profiling** - we have some of the context for limited amount of time (like `tcpdump`)
1. **Tracing**  - get some proportion of events that pass through some functions of interest and store this timing. Usually used to see the request path and how much time each step took.
1. **Logging** - store almost all the context for a limited set of events. There are the following types:
    * Transaction logs - critical business records that you must keep save at all cost
    * Request logs - HTTP requests or database calls.
    * Application logs - some system level events, like backups, maintanance and so on.
    * Debug logs - detailed logs for troubleshooting., maintanance and so on.
1. **Metrics** - a lot of aggregated events, mostly without context (just a few labels).

## Reliability
1. Reliability is the most important feature.
1. Users, not monitoring decide reliability.
1. Well engineered software could get you up to the three nines (not more!)
1. There are two types of work on improving reliability
    * reactvie - well trained incident response
    * proactive - removing bottlenecks, automating processes and isolating failure.
1. There is always tension between reliability and new features. The more features you release the less reliabile you become.
1. **Error budget** - the amount of time that you could be unreliable, but still maintain SLO.
    * once the error budget is less than 0, you should stop releasing new features and focus on reliability.
    * by having this concept we could decrease the tension between Devs and Ops.

### Improving Reliability
1. Minimal time to recovery consist of:
    * time to discover
    * time to resolution
1. It's also very important to consider the "impact" of the issue.

    ![Failure Impact](./img/failure-impact.png)

1. To improve reliability we could do:
    * increase time to failure
        * reduce the amount of technical debt
        * improve test coverage
        * standardize infrastructure
        * blameless portmortems
    * reduce time to discovery
        * alerting
        * monitoring
    * reduce time to recovery
        * self-healing
        * monitoring - to help gather the information
        * improve logging - for going deeper into details
        * improve automation - automating tasks like failover
        * playbooks
        * save release and rollback systems
    * reduce impact
        * improve canary analysis
        * engineering service to work in partial failure case


## Managing Risks

### Risks definitions
1. Define all the SLO risks. The sources:
    * failures in the past could be a good source of data
    * analyzing all the possible hazards.
1. Priorize risk by the following equation:
    ```
    Risk = probability * impact
    ```

    * probability => time to failure
    * impact => service downtime
1. With the above convension we could measure risk as **Bad Minutes / Year**

### Dowtime
1. Consist of:
    * Time to detection
    * Time to resolution
    * Percentage of users impacted

### Reducing risks
1. Perform education
1. Perform "wheel of missfortune"
1. Train the staff by injecting real bug in prodution system.
