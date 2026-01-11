# Behavior Interview

* TOC
{:toc}

## Answers

### FaaS

This story has two parts, first part is how I led the succesful delivery of new product within Core Infrastructure. The second part is the story how I pushed back on direction from product teams related to next stages of platform development.

#### Situation

Leadership asked me to lead a project after succesful PoC because staff engineer who led it was leaving the company. The main goal of the project was to deploy and intergrate FaaS platformm (like AWS Lambda) on top of existed infrastructure. The previous team did PoC, they took knative platform and basically did kubectl apply to one of production clusters. Knative is a bunch of kubernetes operators and CRDs, from customer point of view it abstracts containers and provides autoscaling including down to zero.

#### Task
Make platform production ready and onboard first-customers. Product team identified one big new customer - a platform for llm tools.

#### Actions

At the beginning we had more or less clear WHAT needs to be done, HOW to make it was my job, but WHY to make it was also not 100% clear.

##### Why
I exlored available serverless solution (AWS Lambda) and talked with LLM tools platform on why they want to have FaaS platform and can't use Lambda. They shared that level of integration with booking for lambda is not good enough. I did research, talked with AWS team and discovered that Lambda in booking environment works well with AWS only setup, but don't work well in hybrid setup (many booking tools are not supported), and there are no plans to make it the same level as on-prem setup. Also I noticed in the design the benefit of being vendor agnostic.  So why was clear - vendor agnostic and all integration out of the box.

##### WHAT
Next was a question on what exactly do we need to do. The task was to make platform "production ready". There are some generic requirements (like multi regional deployment, observability and so on) and there could be some customer specific requirements. So I've talked with LLM tools team and we came up with min list of features: like integration with deployment pipeline, multi regional deployment, integration with service mesh and service directory.

##### HOW
Having that in the design doc, I digged into how to implement it.

But first researched through the platform internals - read source code and event found a book on o'relly. Then identified external dependencies - like integration with deployments pipeline should be done by deployment team, so I've talked with them and aligned about timeline. Then created a few tasks in team backlog and picked up the most ambiquious part - the networkig layer. The thing is knative platform has pluggable networking layer. During PoC we implemented Istio-based networking layer, which made sense because we have centralized Istio setup at booking. But the devil was in details. The thing is in company setup istio control plane is centralized (in one central cluster), but knative requires cluster local control plane. So during PoC team just deployed a separate control plane dedicated for knative, which obviously was not ideal. To get rid of this dedicated setup we had to not only teach platform on how to work with remote control plane (which was doable), but also how to avoid race conditions when many platform talk with the shared control plane. The last one turned out quite challenging, involving shared ownership and potential mess up of centralized control plane. So I went to discover some alternatives. An alternative solution was not to use istio networking plugin at all. Knative had another network plugin - called kourier. It was a simple envoy-based gateway with small controlled. So the setup was much simplier, but had some drawbacks. Centralized istio wouldn't know anything about Functions, only gateway would know about them. So it means we had to deploy every function to every cluster where gateway is present. It turned out an acceptable trade-off, because platform can scale to 0 and we will not waste a lot of resources. So I went this route, changed networkig implementation and onboarded this gateway as a regular service to centralized SM, which basically unblocked multi regional deployment.

#### Result
Platform was production ready and LLM tool platform was unblocked. They started migration of LLM tools from their monolith setup to FaaS platform.

### Knative Eventing

#### Situation
After delivering succesful MVP of knative-serving platform Product team was pushing to deploy and integrate into booking environment another part of knative platform - which is called knative-eventing. The main benefit of this platform is that it provides centralized event hub, where producers can be anything which can send HTTP request and consumer can be anything which can process HTTP request. Consumers are also autoscaled based on number of messages in progress. In general, platform abstract all of the compexity of dealing with event bus (kafka, rabit, sqs), and everything is just HTTP based.

#### Task
What: Deploy and integrate platform into booking environment. Why: to simplify adoption of event driven architecture at booking (is a bit vague, so I put a note to gather more concrete use-cases and customers before implementation)

#### Actions

How: I looked through the source code and platform docs, identified external dependencies. The major dependency was kafka (because it provided message streaming layer platform required). I didn't have deep knowledge in kafka, so took some docs, books, deployed it locally inside kind cluster and learned it. Then having this knowledge I went to kafka team with list of requirements. The main challenge was how to provide an isolated environment for platform, so that it doesn't impact other kafka customers. We found a solution both for on-prem (prefixes) and AWS (dedicated cluster). I also gathered feedback about feasibility of the platform, because we technically building an abstraction layer on top of kafka. They were a bit skeptical, the main justification was that we already have a very well written and adopted library to interract with kafka directly, and it's hard to find justification on why they need to migrate (when everybody is there it is clear, but until we reach some mass it's useless). That's where I decided to focus on why (how was clear). I arranged a series of meeting with product teams which used kafka (gather the list with help of kafka team) and gathered their feedback. The feedback was that they would prefer to interract with kafka directly (they already know how to do it and they can use all of the kafka features - like batching and replay). Together with product we prepared one-pager to understand interest from potential new customers, and there were not many. So I pushed the recommendation to not proceed with eventing platform, until we have a clear customer base and need.

#### Results

We didn't waste time on deploying and integrating platform which nobody would use.


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
[cross team conflict] [leadership]
- tbu: cloud is unreliable
- vendor: cloud is very old, upgrade
- me: let's talk with both and understand their point of view

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

## App performance optimization after migration to VM

- A/B tests
- coordinate networking, product team, vendor
- huge pages
- firmware upgrade consensus
- communicate to leadership

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

## Other cases
1. internal terraform registry when it was not a thing in Terraform Enterprise
2. Perform "history" presentation to new employees.
3. SLO based alerting in Private Cloud
4. Testing environment
5. Feedback from manager to document better and be role model: all JIRA tickets and commits have clear structure
6. Centos9 - helped the team to get up to speed with build process and dependencies, helped to structure work
7. Audit section and adaptability.
8. ARP config change
