# SRE

## SRE Tasks
![SRE Tasks](./img/sre-tasks.png)

1. **Reduce Organization Silos** - reduce the barier between developers and operation guys.
    * share the ownership of production with developers
1. Accept Failure as Normal
    * blameless postmortem
    * make sure that failure won't happend the same way second time
    * use error budget
1. Implement Gradual Change
    * small releases instead of big one
    * canary releases
1. Leverage Tooling & Automation
    * automate manual work (eliminate toil)
1. Measure Everyting
    * amount of toil we have
    * the reliability of our systems

## Reliability
1. **Reliability** - when system is able to perform it's functions.
1. Reliability is the most important feature.
1. Users, not monitoring decide reliability.
1. Well engineered software could get you up to the three nines (not more!)
1. There are two types of work on improving reliability
    * reactvie - well trained incident response
    * proactive - removing bottlenecks, automating processes and isolating failure.
1. There is always tension between reliability and new features. The more features you release the less reliabile you become.

## MTT
1. Minimal time to recovery consist of:
    * time to discover
    * time to resolution
1. It's also very important to consider the "impact" of the issue.

## SLA and SLO
1. Service Level Agreement - promise to customers, if this promise is failed there are financial (or other) consequences.
1. Service Level Objective - internal promise to meet customers objectives. Should be more strict than SLA, because usually customers are affected much earlier than the SLA breach

    ![SLA vs SLO](./img/slo-sla.png)
