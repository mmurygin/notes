# Behavior Interview

* TOC
{:toc}

## Answers

### VM management V2 and Ashwin**

[Conflict Resolution]

#### Situation
Over previous few years we've built OpenStack based private cloud platform. OpenStack was installed by vendor, my department did integration layer between Vanilla OpenStack and Booking eco-system. Platform got big adoption for development workloads (developer workstations and integration environment), totaling more than 8k VMs. But production onboarding was slow. At the same time, a new manager came to the team, he saw the architectural issues with the platform (in particular layer which was responsible for managing Virtual Machines), and was eager to rebuild it.

#### Task
I've got a task to design platform v2 with better abstractions and TODO.

#### Actions
I had doubts that re-implementation will drastically improve adoption. So when I've started working on design, I first dedicated a lot of effort on researching why the adoption rate of the platform for PROD workload was lower than expected.

Key steps I took:
- Talked with many product teams, gathered and analyzed the feedback
- Found misalignment: management assumed adoption was low due to tooling with unfriendly UX and leaking abstractions
- My research showed: engineers haven't seen any benefits in migration
- Classical virtualization benefits (better hardware utilization, rapid provisioning, easy scaling, snapshots, fast recovery) were not applicable to Booking workload
- Main problem: we were trying to move workload from baremetal to VMs as-is, without changing development processes (deployment, provisioning, scaling, patching)
- Despite findings, management insisted on platform rebuild
- Involved another engineer to pair on design
- Setup high-level architecture together; engineer broke it down into components and actionable items
- Focused on uncovering organizational long-term vision for workload management
- Connected with production developers (about real problems), Staff Engineers, and Product owners
- Assembled document mapping Virtualization benefits vs Production problems
- Document was used to decide on the future of underlying platform for Booking workloads

#### Results
- Design improved development platform (which already had good adoption) and implemented cloud abstractions
- Later changed underlying platform from OpenStack to EC2
- Reached agreement that virtualization by itself doesn't solve development challenges
- OpenStack for production was discontinued in favor of fast migration to AWS to benefit from all AWS services

### TBU migration to MOSK
[team conflict] [leadership]
- tbu: cloud is unreliable
- vendor: cloud is very old, upgrade
- me:

### Offscript Decomissioning
- came up with data
- raised awareness
- got leadership approval, performed

### Teaching Incident Response and Postmortems to a Vendor
[cross team]

### Leading PII incident
- scale
- cross-organizational improvements after incidnet
    - security incident response
    - PII monitor

### BKS on MOSK
[unblock others]

- delivered MVP
- aligned on blockers (didn't won't to rely / depend for critical part on a separate vendor)

### Toxic Support replies and Shared Responsibility model

S: too direct on support when people ask trivial questions
A: add AI support bot, add shared responsibility model, daily doc digest

### VM provisioning with Harness
[I was wrong]

- no API
- no cloud abstraction

learning:
- think about abstractions in advance, simplicity is not always the king


### Image Labeling Service
[proud of]

- survived 100x scale
- managed to navigate ambiguity
- it brought a lot of money to outsourcing company (brought another customer) and it helped team to relocate

## Questions categories

### Conflict resolution

How can you handle disagreements with team members or stakeholders? How you navigate conflicts professionally and constructively

> You disagreed with teammate or leaders
> You dealt with interpersonal challenges
> You had to navigate competing priorities
> You faced frictions between teams
> You turned a difficult relationship around

### Perseverance

Can you push through challenges and setbacks? Demonstrate your ability to overcome obstacles and maintain focus on long term goals

* You faced significant technical obstacles
* Thinkgs didn't go as planned
* You had to push through setbacks
* The odds seemed stacked agains you
* You refused to give up despite challenges

### Adaptability

How well do you handle change? Show that you can thrive in dynamic environment and adjust to your approach when necessary

* Everything changed unexpectedly
* You had to pivot quickly
* Plans fell through
* You worked outside your comfort zone

### Growth Mindset
Continuous learning and improvement. Highligh your passion for personal and professional development.

* You made significant mistakes
* You received tough feedback
* You were initially wrong about something

1. Self-taught throuw my life
2. Personal Learning plans and notes

### Leadership

Can you guide and inspire others?

### Collaboration & Communication

How effectively do you work with others and convey ideas? Team work skills and ability to communicate complex concepts clearly.

* worked accross multiple teams
* built bridges between groups
* turned difficult collaboration around
* helped other succeed
* improved how people worked together

### Results
