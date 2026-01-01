# Behavior Interview

* TOC
{:toc}

## Questions

### Conflict at work

**VM management V2 and Ashwin**

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

### Project I've most proud of

Image Labeling Service

### Growth Mindset

1. Personal Learning Notes
2. Self-taught

### Saw a need and stepped up
1. Teaching vendor how to do proper incident handling and post-mortems
