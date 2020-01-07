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
1. Test the hypothesis
    * find evidencies
    * change the system and observe expected result
1. Fix the problem
1. Write postmortem
1. [Mitigate the consequences]

## Pitfalss
1. Looking at symptoms that aren't relevant or misunderstanding the meaning of system metrics.
1. Misunderstanding how to change the system to test hypothesys.
1. Comming up with wildly improbable theories about what's wrong, or latching onto causes of past problems.
1. Hunting down spurious correlations that are actually coincidences or are correlated with shared causes
1. Correlation is not a causations.
