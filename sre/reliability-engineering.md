# Reliability Engineering

  * [Philosophy](#philosophy)
  * [Improving Reliability](#improving-reliability)
  * [Practices](#practices)
  * [Managing Risks](#managing-risks)
    + [Risks definitions](#risks-definitions)
    + [Downtime](#downtime)
    + [Reducing risks](#reducing-risks)

## Philosophy
1. Reliability is the most important feature.
1. Users, not monitoring decide reliability.
1. Well engineered software could get you up to the three nines (not more!)
1. There are two types of work on improving reliability
    * reactive - well trained incident response
    * proactive - removing bottlenecks, automating processes and isolating failure.
1. There is always tension between reliability and new features. The more features you release the less reliable you become.
1. **Error budget** - the amount of time that you could be unreliable, but still maintain SLO.
    * once the error budget is less than 0, you should stop releasing new features and focus on reliability.
    * by having this concept we could decrease the tension between Devs and Ops.

## Improving Reliability
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


## Practices
1. Retry.
2. Timeout.
3. Monitor dependencies.
4. rate limit.


## Managing Risks
### Risks definitions
1. Define all the SLO risks. The sources:
    * failures in the past could be a good source of data
    * analyzing all the possible hazards.
1. Prioritize risk by the following equation:
    ```
    Risk = probability * impact
    ```

    * probability => time to failure
    * impact => service downtime
1. With the above convention we could measure risk as **Bad Minutes / Year**


### Downtime
1. Consist of:
    * Time to detection
    * Time to resolution
    * Percentage of users impacted


### Reducing risks
1. Perform education
1. Perform "wheel of misfortune"
1. Train the staff by injecting real bug in production system.
