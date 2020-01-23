# Alerts

## Philosophy

### Best Practices
1. Every time the pager goes off, I should be able to react with a sense of urgency. I can only react with a sense of urgency a few times a day before I become fatigued.
1. Every page should be actionable.
1. Every page response should require intelligence. If a page merely merits a robotic response, it shouldn't be a page.
1. Pages should be about a novel problem or an event that hasn't been seen before.
1. Alerts should not flap
1. One event should trigger as less alerts as possible.
    * when there are a lot of triggered alerts in case of an incident - it creates a lot of noice and complicates troubleshooting.
1. It's great when every alert have attached runbook for on-call engineer.
1. **Test your monitoring system** - as you setup your monitoring system you could not be fired by an alert for months or years, so it's very important to be sure over time that your alerts are not broken.

### Minimize the amount of alerts
1. Does this rule detect an otherwise undetected condition that is urgent, actionable, and actively or imminently user-visible?
1. Will I ever be able to ignore this alert, knowing it's beningn? When and why will I be able to ignore this alert, and how can I avoid this scenario?
1. Does this alert definitely indicate that users are being negatively affected? Are there detectable cases in which users aren't being negatively impacted, such as drained traffic or test deployments, that should be filtered out?
1. Can I take action in response to this alert? Is that action urgent, or could it wait until morning? Could the action be safely automated?
1. Does everyone from the notification list really need to be notified?


## Alerting Consideration
1. **Precision** - proportion of the alerts which correspond to the real outage
    ```
    precision = real incidents triggers / all alerts triggerd
    ```

1. **Recall** - the proportion of significant events detected
    ```
    recall = detected significant events / all significant events
    ```

1. **Detection time** - how long does it take to send notificaiton in various conditions.
1. **Reset time** - how long does alert fires after issue has been mitigated.

## Strategies
### Target Error Rate >= SLO Threshold
```yaml
record: job:slo_errors_per_request:ratio_rate10m
expr:
  sum(rate(slo_errors[10m])) by (job)
    /
  sum(rate(slo_requests[10m])) by (job)

- alert: HighErrorRate
  expr: job:slo_errors_per_request:ratio_rate10m{job="myjob"} >= 0.001
```

![Target Error Rate Pros and Cons](alert-target-error-rate.png)

