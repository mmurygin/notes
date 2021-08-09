# Postmortem
**Downtime is like a present - it's good until you have the same twice.**

## Basic
1. Real incidents
    *  Real incidents are not unusual.
    *  Real incidents are not all catastrophic issues - conduct postmortems for minor issues as well.
    *  Real incidents do not have a single, simple root cause. Contributing Factors!
    *  Postmortems are to learn, not to fix.
1. **Postmortem** - taking the opportunity to learn how your system really does work, after your system acts differently from how you expect it to, in order to increase your system and team's resilience.
1. **Contributing Factor** - any factor contributing to the occurrence of or influencing a failure or hindering resolution of that failure.


## Biases
1. **Fundamental Attribution Error** - when we explain other people's actions by their personality, not the context they find themselves in, but we explain our own actions by our context, not our personality.
    * Remember everyone has good intent and did their best at the time.
1. **Confirmation Bias** - when we seek information that reinforces existing positions, and ignore alternative explanations. We interpret ambiguous information in favour of our existing assumptions.
    * Gather many viewpoints; let the facts guide your conclusions and not vice versa.
1. **Hindsight Bias** - when we recall events to form a judgment, and talk about contextualize events with knowledge of the outcome - often making ourselves look better in the process.
    * Put yourself into the viewpoint of the practitioner at the time.
1. **Negativity Bias** - even when of equal intensity, things of a more negative nature have a greater effect on one's psychological state than neutral or positive things (we magnify small errors if they lead to an incident).
    * Review what went right; don't rush to fix, learn instead.
1. **Curse of Knowledge** - when an individual communicating with other individuals unknowingly assumes the others have the background and knowledge to understand it (experts often have trouble explaining things to novices).
    * Explain or ask others to explain basics; don't assume people know things.
1. **Outcome Bias** - judging a past decision based on its outcome.

## Language
1. **~Why~** - do not use this word. As it forces people to justify their action.
1. **How** - helps to distant people from the actions they took, but also limit the scope of the inquiry, as we focus on mechanics, not the relations at play in larger system.
1. **What** - uncovers reasoning, which is important for building empathy with people in complex systems
    * What did you think was happening?
    * What did you do next?

Remember:
**People make what they consider to be the best decision given the information available to them at the time**


## Content
[Postmortem Template](https://docs.google.com/document/d/1-tKNWXPBsplAtkqXvksLUXS6VoC7D_qD80IGo2EAKbY/edit?usp=sharing)

## Analysis

### What went well
1. A way to fight `Negativity Bias` and `Fundamental Attribution Error`.
1. General questions:
    * What aspects of our system and team contributed to our success here?
    * During this incident and the events leading up to it, how did we actively create and sustain success?
    * How are we already monitoring, responding, anticipating, and learning?
    * How was the problem fixed, how did the responder figure out what was wrong, and how to remediate it?
1. Question examples
    * What safeguards were in place?
    * What went according to plan?
    * What was effective about detection, analysis and remediation?


### Contributing Factors
**There are no root cause in complex systems**
1. How did it happen?
1. What hindered detection?
1. What hindered diagnosis?
1. What hindered resolution?
1. Look at the incident response itself, as well as the other causes.

E.g. engineer updated the config wrong:
* What led him to update it in an unexpected way?
* What made that easy or likely to happen?
* How did no test catch it?
* How did no review catch it?
* How could it propagate to multiple systems undetected?




## Practices
1. Principles:
    * Blameless
        * people are never root cause
    * Should be written for all major or user-facing incidents
    * Should be reviewed
    * Should be shared withing an organization.
    * Can be used as a training material
1. Content:
    * What went wrong
    * What the impact of the issue was
    * How you tracked down the problem
    * How you fixed the problem
    * How to prevent it from happening again.
1. Conclusions:
    * what went well
    * What could have gone terribly wrong?
    * How can we do to avoid such issues in the future?
    * Follow Up Actions


## Analyzing and reducing the amount of incidents
1. Keep a History of Outages
1. Ask the Big, Even Improbable, Question: What if...?
1. Encourage Proactive Testing

