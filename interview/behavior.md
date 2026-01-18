# Behavior Interview

+ [Knative Eventing](#knative-eventing)
+ [VM management V2 and Ashwin](#vm-management-v2-and-ashwin)
+ [VM provisioning with Harness](#vm-provisioning-with-harness)
+ [Teaching Incident Response and Postmortems to a Vendor](#teaching-incident-response-and-postmortems-to-a-vendor)
+ [App performance optimization after migration to VM](#app-performance-optimization-after-migration-to-vm)
+ [TBU migration to MOSK](#tbu-migration-to-mosk)
+ [Offscript Decomissioning](#offscript-decomissioning)
+ [Leading PII incident](#leading-pii-incident)
+ [BKS on MOSK](#bks-on-mosk)
+ [History presentation for new employees.](#history-presentation-for-new-employees)
+ [Actions](#actions-4)
+ [Results](#results-4)
+ [SLO based alerting in private cloud.](#slo-based-alerting-in-private-cloud)
+ [First external platform audit.](#first-external-platform-audit)
+ [ARP config change](#arp-config-change)
+ [Image Labeling Service](#image-labeling-service)
+ [Other cases](#other-cases)

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

### VM management V2 and Ashwin

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

### VM provisioning with Harness
[I was wrong]

#### Situation
- vendor deployed OpenStack in our DCs
- my team was building integration layer between vendor product and company ecosystem

#### Task
- design and implement deployment pipeline for production workload (how product engineers will create and manage VMs)
- constraint: the deployment should go through harness

#### Action
- build simple possible integration
- harness delegate talks directly with openstack
- no cloud abstractions

#### Result
- harness UI is the only abstraction
- required new harness workflow for every simple interraction with platform
- no cloud abstractions => complex migration between clouds / vendors
- later: build API to abstract having openstack and manu clouds per region

#### Learnings
- infrastructure changes are very expensive, have proper abstractions around them, simplest is not always the king
- think about product future in 5-10 years, not only how users will onboard to a platform, but also how would you decomission it
- think about who uses your product, find a way to satisfy product need but still deliver upstream requirements (implement delegate, but call API from it)

### Teaching Incident Response and Postmortems to a Vendor
[cross team] [take initiative to improve]

#### Situation
Vendor didn't have an incident response process. Engineers were sitting in zoom call, with one of them sharing screen. No IC, external communications, event logs. Post incident, they wrote RCA (root cause analysis).

#### Task
Nobody actually assigned me to improvement, but problems were obvious and I didn't event have to invent solution, just align them with our company standards.

#### Actions
The thing is that booking has pretty old and legacy setup of perl running on baremetal servers and writing it to huge cluster of MySQL dbs. To make it work over the years we build very suffisticated reliablity practices and incident response. So my task was to teach vendor these processes. I did it both by example (led some incident), by introducing some policies (there sould be IC, all commands are approve explicitly, events and actions should be tracked in dedicated slack channel, in case of P1 leadership should be updated every 30 mins). Postmortem: should include context, root cause, symptoms, detection, corrective actions, improvements: how to prevent, reduce impact, what could've gone terribly wrong, how effective was incident repsonse process. Helped to conduct postmortem reviewes.

#### Results
Vendor adopted practices, vendor managed to comply with SLA 22/24 following months => MTTR and MTTF decreased.

### App performance optimization after migration to VM

#### Situation
App was 50% slower after migration to VMs, while ~5% slowleness was acceptable.

#### Tasks
Fix performance

#### Action
Assembled SME team consiste of (vendor, production engineers, dc engineers). Basically sit and talk about specific of workload (running huge number of perl scripts, CPU intensive).

Identified different avenues to explore:
* potential virtualization optimization (numa)
* host os config differences (huge pages)
* hardware differences (cpu frequency)

I setup A/B tests and helped to troubleshoot THB:
* 1 VM vs 1 baremetal host
* compare system metrics from guest VM and baremetal => no diff
* compare system metrics from hypervisor and baremtal => a lot of page faults
* altough guest OS has enabled THB, host OS didn't have pre-allocated pages
* so guest thought that they use 2MB pages, but in reality on hypervisor we had 512 4KB pages, which ended up in a lot of page faults
* we enabled THP on hypervisor and pre-allocated required number of THP for every VM

#### Results
Together with NUMA change it did 25% of improvement, the other 20% improvement came from CPU change

### TBU migration to MOSK
[cross team conflict] [leadership]
- tbu: cloud is unreliable
- vendor: cloud is very old, upgrade
- me: let's talk with both and understand their point of view

### Offscript Decomissioning
- came up with data
- raised awareness
- got leadership approval, performed

### Leading PII incident
- scale
- cross-organizational improvements after incidnet
    - security incident response
    - PII monitor

### BKS on MOSK
[unblock others]

- delivered MVP
- aligned on blockers (didn't won't to rely / depend for critical part on a separate vendor)

### History presentation for new employees.
#### Situation
when I joined booking there was "infra overview" presentation from principal, which described how we ended up having 50k baremetal servers running perl. This presentation was extremely useful to me, after a few years this engineer left the company. I discovered that new joiners in my track have vague understanding of "big picture".

#### Task
I decided to help onboarders in my team, and started to give similar presentation.

### Actions
Got a positive feedback, expanded presentation to whole department. Gave more than 20 talks (small groups, white board).

### Results
Made a lot of friends and hopefully improved onboarding experience from new joiners.

### SLO based alerting in private cloud.
[todo]

### First external platform audit.

### ARP config change

### Image Labeling Service
[proud of]

- survived 100x scale
- managed to navigate ambiguity
- it brought a lot of money to outsourcing company (brought another customer) and it helped team to relocate

### Other cases
1. internal terraform registry when it was not a thing in Terraform Enterprise
2. Centos9 - helped the team to get up to speed with build process and dependencies, helped to structure work
