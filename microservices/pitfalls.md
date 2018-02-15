# Pitfalls

## Table Of Content
- [Description](#description)
- [Static Contract](#static-contract)

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
