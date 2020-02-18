# Troubleshooting

  * [Definition](#definition)
  * [Incident Response](#incident-response)
    + [Structured Incident Responds includes:](#structured-incident-responds-includes)
    + [Steps](#steps)
  * [Responding to minor problems](#responding-to-minor-problems)
    + [Steps](#steps-1)
    + [Clarify the problem](#clarify-the-problem)
    + [Find the reproduction case](#find-the-reproduction-case)
    + [Dealing with intermittent issues](#dealing-with-intermittent-issues)
  * [Mitigation](#mitigation)
    + [Technics](#technics)
    + [Immediate Steps to Address Cascading Failures](#immediate-steps-to-address-cascading-failures)
  * [Root Cause](#root-cause)
    + [Finding the root cause](#finding-the-root-cause)
    + [Tools](#tools)
    + [Dealing with slowness](#dealing-with-slowness)
  * [Improving troubleshooting processes](#improving-troubleshooting-processes)
    + [Making Troubleshooint easier](#making-troubleshooint-easier)
  * [Prepare](#prepare)
    + [Troubleshooting Pitfalls](#troubleshooting-pitfalls)
  * [Postmortem](#postmortem)
    + [Practices](#practices)
    + [Analyzing and reducing the amount of incidents](#analyzing-and-reducing-the-amount-of-incidents)


## Definition
1. **Troubleshooting** is the process of identifying, analyzing and solving problems. Mostly in running application.
1. **Debugging** is the process of identifying, analyzing and removing bugs in the system. Mostly in the application code.


## Incident Response

### Structured Incident Responds includes:
1. Monitoring
1. Alerting
1. Incident Response Policy
    * on-call
    * playbooks

### Steps
1. Define the issue and gather the information
    * understand the current status of the system using monitoring
    * escalate if it's necessary
        * is incident user-facing?
        * how fast is error budget burning
    * if escalated:
        * document the incident
        * assign Incident Commander, Operation and Communication leads
        * create communication chanell
1. **Mitigate** - make the system work with current circumstances (stop the bleeding)
    * [General Techmics](#technics)
    * [Stop Cascading Failure](#immediate-steps-to-address-cascading-failures)
    * **Document what you do**
1. [Find the root cause](#finding-the-root-cause).
1. Implement / schedule long term fix
1. [Write postmortem](#postmortem)
1. Mitigate the consequences (data loss).


## Responding to minor problems

### Steps
1. [Clarify the problem](#clarify-the-problem)
1. [Find the reproduction case](#find-the-reproduction-case)
    * after finding reproduction case we could free up user
    * [Dealing with intermittent issues](#dealint-with-intermittent-issues)
1. **Mitigate** - create short term solution
1. [Find the root cause](#finding-the-root-cause)
1. Implement / schedule long term fix

### Clarify the problem
1. What are you trying to do?
1. What steps did you follow?
1. What was the exprected result?
1. What was the actual result?

### Find the reproduction case
1. Isolate
1. Segment and reduce

### Dealing with intermittent issues
1. If you could modify the running code:
    * Add more logs to understand the conditions when issue happens
1. If code modification is not an option
    * Turn on debug mode on a software
1. If above two do not work:
    * Monitor the environment
1. If reset helps it's more likely that the issue is conneted with software bug about resource management. Because when we restart the machine
    * we cleanup memory
    * we cleanup network connections
    * we cleanup opened file descriptors
    * we cleanup cache

## Mitigation
### Technics
1. Rolling back a bad software push
1. "Draining" traffic away from an affected cluster/datacenter
    * Remove the broken machine from the pool of services
1. Bringing up additional serving capacity
1. [Feature isolation]

### Immediate Steps to Address Cascading Failures
1. Bringing up additional serving capacity
1. Eliminate Bad Traffic
1. Eliminate Batch Load
1. Enter Degraded Modes
1. Restart Servers
    * be carefull not to trigger the issue with slow startup and cold cashing
1. Stop Health Check Failures/Deaths
1. Drop Traffic

## Root Cause
### Finding the root cause
1. Gather Information
    * Does all users affected or only subset of them? What is common between affected users?
    * What changed?
        * source code
        * configs
        * libraries service depends on
        * external services library depends on
    * Does it depends on the server where the app is running?
    * logs [add logs to required parts if necessary]
    * monitoring
    * tracing
    * send custom requests
1. Form a hypotheesis
    * **Start with simplier to check hypothesis**
    * Segment problem space
        * if steps number is low: just go through them one by one
        * if steps number is high: use binary search to reduce problem (git bisect)
    * simplify and reduce
    * bin search or go trough the broken response and identify which components works and which does not
1. Test the hypothesis
    * if it's possible it's better to test our hypothesis in stage/dev environment instead of produciton
        * we won't break something important
        * we won't interfere with other users
    * find evidencies
    * change the system and observe expected result
1. Fix the issue

### Tools
1. Which processes consumes CPU
    * top
        * load average
    * atop
        * can group by process name
1. What proccess is doing:
    * **`strace`**
    * **`ltrace`**
1. Disk load:
    * **`iotop`**
        * **iowait** - time spend waiting on IO events
    * **`iostat`**
    * **`vmstat`** - virtual memory stats
1. Inspect current traffic on network interfaces
    * **`iftop`**
1. Inspect network packets
    * **`tcpdump`**
    * **`wireshark`**
1. Measure the time for completenes of the programm
    * **`time`**
1. Debug programms
    * **`gdb`** - for c/c++ programs
        ```bash
        # enable core files generation
        ulimit -c unlimited

        # run programm and generate core file in case of crash
        ./my-programm
        Segmentation fault (core dumped)

        gdb -c core

        (gdb) backtrace # view call stack
        (gdb) up        # move in the call stack by one function
        (gdb) list      # show lines around the current one
        (gdb) print var # print variable value
        ```
    * **`pdb3`**
        ```bash
        pdb3 python-script.py args
        (Pdb) next              # go to next line
        (Pdb) continue          # continue until finish or crash
        (Pdb) print(var_name)   # print variable value
        ```

### Dealing with slowness
1. Determine and measure what "slow" means.
1. Find the bottleneck
1. Possible suspects:
    * overloaded CPU
    * overloaded memory
    * memory leaks
    * slow software
    * data growth (e.g. parsing to big files)
    * hardware failure - when many segments of hdd are corrupted it starts to perform slow, after this it's the matter of time when we will start losing data
    * malicious software
1. Profile the source code
    * to profile python script use `pprofile3` and `kcachegrind`

    ```bash
    pprofile3 -f callgrind -o profile.out ./my-script.py
    kcachegrind profile.out
    ```

1. Fix the issue and prove the fix with the same measurement that was done at step 1.


### Dealing with crashes


## Improving troubleshooting processes
### Making Troubleshooint easier
1. Building observability
    * logs
    * black box and white box monitoring
    * correlation id
1. Clear and simple architecture and interaction between components.
1. Track what changed (preferable available in one place)
    * which apps were released
    * which configs were updated

## Prepare
1. Create an incident response policy
    * including escalation policy
    * communication chanell
    * contact list
1. Have mitigation steps for as more outages as possible.
1. It's good to have playbooks for every alert
1. Train team and explore how the incident was handled.
    * role game
    * controlled emergency
    * hands-on exercises / labs

### Troubleshooting Pitfalls
1. Looking at symptoms that aren't relevant or misunderstanding the meaning of system metrics.
1. Misunderstanding how to change the system to test hypothesys.
1. Comming up with wildly improbable theories about what's wrong, or latching onto causes of past problems.
1. Hunting down spurious correlations that are actually coincidences or are correlated with shared causes
1. Correlation is not a causations.


## Postmortem
### Practices
**Downtime is like a present - it's good until you have the same twice.**
1. Principles:
    * Blameless
        * people are never root cause
    * Should be writen for all major or user-facing incidents
    * Should be reviewed
    * Should be shared withing an organization.
    * Can be used as a training material
1. Content:
    * What went wrong
    * What the impact of the issue was
    * How you tracked down the problem
    * How you fixed the problem
    * How to prevent it from happening again.
1. Conclusion:
    * What went well
    * What did we learned


### Analyzing and reducing the amount of incidents
1. Keep a History of Outages
1. Ask the Big, Even Improbable, Question: What if...?
1. Encourage Proactive Testing

