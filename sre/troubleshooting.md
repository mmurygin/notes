# Troubleshooting

## Steps
1. Define the issue
    * understand the current status of the system
1. **Triage (mitigate)**
    * make the system work with current circumstances (stop the bleeding)
1. Gather Information
    * logs
    * monitoring
    * tracing
    * send custom requests
1. Form a hypotheesis
    * what changed
    * simplify and reduce
    * follow up the broken response and identify which components works and which does not
1. Test the hypothesis
    * find evidencies
    * change the system and observe expected result
1. Fix the problem
1. Write postmortem
1. Mitigate the consequences

## Pitfalss
1. Looking at symptoms that aren't relevant or misunderstanding the meaning of system metrics.
1. Misunderstanding how to change the system to test hypothesys.
1. Comming up with wildly improbable theories about what's wrong, or latching onto causes of past problems.
1. Hunting down spurious correlations that are actually coincidences or are correlated with shared causes
1. Correlation is not a causations.

## Making Troubleshooint easier
1. Building observability
    * logs
    * black box and white box monitoring
    * correlation id
1. Clear and simple architecture and interaction between components.
1. Track what changed (preferable available in one place)
    * which apps were released
    * which configs were updated

## Mitigation Technics
1. Rolling back a bad software push
1. "Draining" traffic away from an affected cluster/datacenter
1. Feature isolation
1. Blocking or rate-limiting unwanted traffic
1. Bringing up additional serving capacity


## Postmortem
**Downtime is like a present - it's good until you have the same twice.**
1. Principles:
    * Blameless
    * Should be writen for all major or user-facing incidents
    * Should be reviewed
    * Should be shared withing an organization.
    * Can be used as a training material
1. Content:
    * What went wrong
    * How you tracked down the problem
    * How you fixed the problem
    * How to prevent it from happening again.
1. Conclusion:
    * What went well
    * What did we learned

## Making system more reliable to outages
1. Keep a History of Outages
1. Ask the Big, Even Improbable, Question: What if...?
1. Encourage Proactive Testing
1. Train team
