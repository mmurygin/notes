# Incident Management

## Definitions
1. **Incident** - unplanned disruption of service functionality

## Before an incident
1. Define a clear definition of __incident__.
1. Define what is __major__ and __major__ incident.
1. Major incident qualities:
    * Timing is surprise
    * Timing is important
    * Situation not well understood at the beginning
    * Involve many people with diffent skills
1. Define incident serverity levels.


## Timeline
![Incident Response Timeline](./img/incident-response-timeline.png)


## Challenges
1. No one responding
1. Not the right people
1. Solving the wrong problem
1. People making things worse
1. Too many people involved
1. Stackeholders left in the dark
1. Everyone stepping on each other toes.

    ![Boys playing football](./img/boys-playing-football.jpg)


## Best Practices
1. We should have two modes of operations with a clear distinction between them
    * **Normal Operations**
    * **Emergency Operations**
1. Have different **severities** for incidents
1. Practice, practice, practice, then practice some more.

## Incident Command System Principles
1. **Common terminology** - everyone in the team should use the same terms.
1. **Accountability** - everyone participating in an incident takes responsibility for resolving it as a first priority.
1. **Unity of command** - the is a single chain of commands to an incident commander.
1. **Explicity transfers of responsibility** - you should get an explicit confirmation when transfer roles.
1. **Modular organization** - [separate into roles](#incident-org-chart)
1. **Integrated communication** - haven defined common communication streams.

**If you're just learning incident response, you can go far by guessing the right thing to do based on 'what whould the fire department do in this situation?'** (c) J. Paul Reed
1. What would there on-call schedule be?
1. Would they stop everything for a press conference in the middle of an incident?
1. Would the mayor come in and take over the incident and tell the team exactly what to do?

## Incident org chart

Definitions:
* **IC** - Incident Commander
    * not any action can happened without explicit approve of IC
    * does not do the work to resolve the incident (neither gathering data nor applying fixes)
    * every decision should be after consensus (ask: "are there any strong objections?")
* **Deputy**
    * keep IC focused
    * take on any and all additional tasks as necessary
    * serves to follow up on reminder and ensure tasks aren't missed
    * acts as a 'hot standby' for IC
* **Scribe** - document what is going on
    * document incident management timeline and important event as they occur
    * key actions as they are taken
    * good to document it publicly (e.g. in slack)
    * document all follow up tasks
* **Communication Liason** - Communication Lead
    * communicate with users, stakeholders and executives
    * update every 20-30 minutes
    * track customer tickets
    * report on customer impact
* **SME** - Subject Matter Expert (firefighter)
* **TL** - Tech Lead (coordinate SME teams to aggregate data for IC in case of having too many SMEs)

Important:
    * **Focus on roles, not individuals.**

People involve as incident grows:

1. Start of an incident

    ![Incident Response Step 1](./img/incident-response-step-1.png)

    * Usually IC is an on-call person
    * IC at start fulfill all the roles, including communication and scribe
    * IC could **explicitly** transfer this role later

1. Escalate and involve more firefighters

    ![Incident Response Step 2](./img/incident-response-step-2.png)

1. Add more visibility to the users

    ![Incident Response Step 3](./img/incident-response-step-3.png)

1. Add more firefighters

    ![Incident Response Step 4](./img/incident-response-step-4.png)


## Steps in the incident
1. Don't panic or, at least, do not show that you panic.
1. Introduce yourself
    * Hello, I'm Max. I'm from private cloud team.
    * Clear communication is essential.
    * Clear is better than concise.
1. Is there an IC on the call?
    * the most obvious IC is on-call person
    * if there is no IC - take this ownership.
1. The main task is stabilize
    * ask for status
    * Decide action by gaining consensus (ask: are there any strong objections?)
        * what risks are involved?
        * making a wrong decision is better than making no decisions
    * Assign task
    * follow up on task completion
1. Clear ownership
    * do not ask: Can someone do this?
    * better to call someone by name and ask him to do this action
1. Time box every task
1. Get explicit acknowledgment

