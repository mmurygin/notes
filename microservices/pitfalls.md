# Pitfalls

## Table Of Content
- [Description](#description)
- [Developer without a cause](#developer-without-a-cause)
- [Jump on the Bandwagon](#jump-on-the-bandwagon)
- [Logging Can Wait](#logging-can-wait)
- [Using Too Much ACID](#using-too-much-acid)
- [Static Contract](#static-contract)
- [Service Orphan](#service-orphan)
- [Are We There Yet](#are-we-there-yet)
- [Give it a REST](#give-it-a-rest)
- [Dare to be Diffeernt](#date-to-be-different)

## Description
**Pitfall** - something that was never a good idea, even from the start

## Grains of Sand
1. **Creating services that are too fine-grained.**
1. Service should be single purpose and have high cohision. To determine we should list all the service functions.
    * For example if we have a service which do the following:
        * Create customer
        * Update Customer
        * Delete Customer
        * Notify Customer
        * Accept Customer comment
    * It's easy to see that from above functions we could move Notify and Comment to separate services
1. If it's required to use ACID transaction in some case between two microservices - we should consider to consolidate these services.
1. We should minimize choreography between services (communication with REST)
    * we have network latency between microservices
    * the more services we coordinate withing a single request the less level of choreography we have
1. James Lewis: Application that fit in your hand
1. Sam Newman: Start out more roarse-grained and move to fine grained as you learn more about the service.
1. **Analysis**
    * Map out the communication paths between services. How much communication is there between services (especially within one request)?
    * List the operations for each services. Is there high cohesion (the degree and manner to which those operations of each service are related to one another) between operations for each service? Does the service do to much and should be split?
1. **Goal**
    * Minimize inter-service communication
    * Strive for high cohesion between operations in a service


## Developer without a cause
1. **Making programming and design decisions without taking the business drivers into account**
1. Microservices architecture style have pros and cons, as any other style. So we should take into account them when we choose the style for our applicaiton
1. **Analisys**
    * Identify and document the business drivers and reasons for using a microservices architecture.
    * Answer the following questions:
        * Why are you doing microservices?
        * What are your primary business drivers?
        * What characteristics are most important?
            * performance
            * deployment and change control
            * scaleability
            * robustness
1. **Goals**
    * Always make design and programming decisions withing the context of business drivers

## Jump on the Bandwagon
1. **Embracing microservices before analyzing capabilities, drivers and business needs.**
1. Advantages:
    * Deployment (we could deploy single service)
    * Testability (we don't need to test the whole application while deploying single service)
    * Change control (minimizing the number of people we need to coordinate to deploy service)
    * Modularity (app is moduled by default)
    * Scalability
    * Development
1. Disadvantages:
    * Performance
    * Complexity
    * Devops
    * Org change (we should change our organization according to our services)
    * Relaiability
    * Feasibility
1. Analyze your technical and business needs and goals
    * What are your goal?
    * what are you trying to accomplish?
    * What are your pain points?
    * What are your primary architecture drivers?
    * Does microservices fit these needs?
1. **Analysis**
    * List the technical and business pain points in your current application and environment
    * List the reasons why you are considering using microservices.
        * why do we use\don't use microservices
        * whe do we use\don't use event sysstem
    * Do the characteristic and advantages of microservices address your pain points and buiseness needs?
1. **Goals**
    * Make sure microservices it the right arthitecture style for your situation and business needs

## Logging Can Wait
1. **Addressing distributed logging concerns late in the development lifecycle**
1. We should generate **correlation/context id**
1. **Analysis**
    * Identify the context of each request(e.g. order number, customer id, confirmation number, etc.)
    * Create a logging API wrapper around you current logging tool
1. **Goals**
    * Consolidate logs from multiple services to identify the request flow of a specific request

## Using Too Much ACID
1. **Relying too much on ACID transactions when using a microservices architecture**
1. **Analysis**
    * Create a mapping of business requests to microservices calls.
    * Identify those requests that require multiple services. Are ACID transactions required? If so consolidate services.
    * List the services databases requiring eventual consistency. Come up with a pattern to do eventual consistency (event based, request based, batch based)
1. **Goals**
    * Identify which requests require an ACID transactions
    * Identify how and when you will do eventual consistency

## Static Contract
1. **Not versioning your service contracts from the very start (or not at all)**
1. There are two ways of doing service contract versioning:
    * Protocol-aware versioning
        * REST: we put version number in the header.
            * `Accept: application/**vnd**.service.tracev2+json`
        * Message Queue: set version in message metadata
    * Protocol-agnostic versioning
        * Add version to payload
            * must parse payload to get version number
            * payload schema can get complex
        * Add version to url or to topic name
1. Reading
    * [Consumer-Driven Contract](https://martinfowler.com/articles/consumerDrivenContracts.html)
1. **Analisys**
    * Where is the version documentation for each contract?
    * Document the procedures for communicating contract changes
    * How many versions for each contract do you support?
    * Do you have procedures defined for deprecating older versions?
1. **Goals**
    * Support backwards compatibility with your services
    * Ensure effective communication when contract changes are made

## Service Orphan
1. **Not designating a specific owner for a service (or a class of services)**
1. **Analysis**
    * Identify each service owner and the services they own (have service owners attached to a specific domain)
    * Document the communication procedures between service owners
1. **Goals**
    * Associate service with specific service owners
    * Ensure service owners effectively communicate with one another

## Are We There Yet
1. **Not accuratly knowing how long the remote access portion of the request will take**
1. In many cases remote access part of the job would take a big percent of the request time, so it's good to know how long does it take to implement and optimize between-services communication.
1. **Analysis**
    * Establish the average latency time for your remote access call
    * Deternime which requests need to be optimized based on multiple network hops
1. **Goals**
    * Understand your network latency for service access and make corresponding ajustments

## Give it a REST
1. **Using restful web services throughout your entire microservices architecture without fully analyzing your remote access needs**
1. In many cases it's better to use **Message Queues** instead of REST.
1. **Analysis**
    * Identify requests that can leverage asynchronous processing
    * Determine if you have broadcast capability needs
    * Determine if you have remote request transaction needs
1. **Goals**
    * Understand your remote processing capabilities needs
    * Improve performance through messaging capabilities

## Dare to be Diffeernt
1. **Not using a common service template or common custom base image**
1. It's great to implement service template for new service. It solve a lot of issues new developer will meet in implementing new microservice/
1. Things to put inside service template
    * call to authentication service
    * hook for authorization
    * hook for contract validation
    * common error handling
    * common logging
1. **Analysis**
    * List the operations and hooks within your service template. Are there operations that can be added to the template?
    * Are development teams using the same base image and service template?
1. **Goals**
    * Encapsulate as much common framework code as possible in your service templates and base images to increase productivity and consistency when creating services.
