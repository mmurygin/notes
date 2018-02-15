# Anti-Patterns

## Table of content
- [Description](#description)
- [Data Driven Migration](#data-driven-migration)
- [Hop on the Bus](#hop-on-the-bus)
- [Timeout](#timeout)
- [Reach in Reporting](#reach-in-reporting)
- [I was taught to share](#i-was-taught-to-share)

## Description

**Antipattern** - something that seems like a good idea when you begin, but leads you into trouble.

## Data Driven Migration
1. **Migration monolithic data to dedicated databases along with microservices.**
1. We should treat data and data migration with care.
1. It's better to split application at first, and then after some time split data. Because it's really hard, reasky and expensive to migrate data back, otherwise it's really easy to split your application into microservices wrong way at the begining.
1. **Analysys**
    1. Map services to existing data tables to identify ownership
    1. Identify data overlap and dependencies between services
    1. Develop functional migration plan for each service
    1. Develop separate data migration plan for each service.
    1. Implement migration in two steps: functional migration, then data migration.
1. **Goals**
    1. Avoid frequent data migration
    1. Identify data sharing needs to help determine service granularity

## All the World a Stage
1. **Placing too much focus on technology and infrastructure (staging iterations) and not enough on business functionality**
1. If we put a lot of effort on an infrastructure and forget to enhance buiseness functionality we will end up with good infrastructure and unhappy business. In most cases we don't need full devops environment to introduce a couple of services, because when we have couple of services we could do most of the work manually.
1. **Analysis**
    1. Identify the staging iterations in your iteration plan
    1. Identify dependencies between staging and functional iterations
    1. Identify opportunities for parallel staging tasks
1. **Goals**
    1. Reduce staging iterations
    1. Deliver business functionality faster

## Hop on the Bus
1. **Adding an integration hub to your microservices architecture.** e.g. Apache Camel, Muel, Shuttle
1. Disadvantages:
    * Creates coupling between microservices
    * Descreases performance
    * Increases complexity
    * Governance
    * Could kill deployment pipeline
    * Complicates development and testing
1. **Analysis**
    1. Identify requests requiring transformation
    1. Identify requests requiring orchestration
    1. Identify requests that access third-party systems
    1. Analyze use of messaging microservices (Adapter, Gateway, Transform, Orchestrator)
1. **Goals**
    1. Provide messaging capabilities without the use of an integration hub
    1. Favor choreography over orchestration

## Timeout
1. **Using timeout values when waiting for a response from a remote service call**
1. We want to avoid cases when server successfully processed requests, but client got request timeout.
1. To set correct timeout we could use: **timeout = (max response time under load) * 2**
1. To handle correct timeout we should use circuit breaker. The best way to implement it is to monitor real user transactions.
1. Reading
    * [Martin Fowler Circuit Breaker](https://martinfowler.com/bliki/CircuitBreaker.html)
    * [Release It](https://www.amazon.com/Release-Production-Ready-Software-Pragmatic-Programmers/dp/0978739213)
1. **Analysis**
    * Document your strategy for reacting to server responsiveness
    * Identify opportunities for using the circuit breaker pattern
    * Externalize your timeout values through configuration properties or external data driven values
1. **Goal**
    * Reduce the time to determine if a service is non-responsible
    * Avoid timing-out requests when the service has recovered

## Reach in Reporting
1. **Pulling data from each microservice or its corresponding database for reporting purposes**
1. There are the following ways to implement reporting in microservices architecture
    * **db pull** - when we pull data from directly from databases of different microservices.
        * **`-`** bounded context
        * **`+`** timeliness
    * **http pull** - when we get data from different microservices using http requests
        * **`+-`** bounded context
        * **`-`** timeliness
    * **batch pull** - when we get data from different microservices at the specific period of time (every hour, nightly)
        * **`+-`** bounded context
        * **`+-`** timeliness
    * **event push** - we publish events what happened with every microservice, reports service handle and process these events
        * **`+`** bounded context
        * **`+`** timeliness
1. **Analysis**
    * List your reporting requirements and the timeliness of reports
    * Can you maintain a separate reporting database or warehouse?
    * List the data required for reporting from each service
1. **Goals**
    * Maintain a strong bounded context for each service and its corresponding data
    * Provide timely data for reporting

## I was taught to share
1. **Sharing too many modules and custom libraries between microservices.**
1. If we have too many modules it's really tricky to stay them up to date.
1. It's better to not create modules like `common`, because this module will be changed very fast and it would be really hard to follow. It's much better to have multiple small modules. The finer the granuallity of the modules the easier to change it.
1. Sometimes we can just replicate (copy/past) some code between microservices.
    * the fewer dependencies between microservices the easier is to change, test and deploy them
    * this method is better to use for almost mutable modules
1. If we have some shared library between 2 or 3 services, and that shared library changes too fast which causes changes in services then it's worth considering to consolidate these services
1. **Analysis**
    * Identify shared library and shared module dependencies
    * Document your versioning strategy for shared libraries
    * Break apart shared libraries into smaller context-based libraries
1. **Goals**
    * Reduce the number of shared modules between services
    * Create fine-graned shared libraries to control change
