# Pitfalls

## Table Of Content
- [Description](#description)
- [Static Contract](#static-contract)

## Description
**Pitfall** - something that was never a good idea, even from the start

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
