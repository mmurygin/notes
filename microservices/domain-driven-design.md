# Domain Driven Design

## Domain
1. **Problem Domain** - the specific problem the software you're working on is trying to solve
1. **Core Domain** - the key differentiator for the customer's business, sometning they must do well and cannot outsource.
1. **Sub-Domains** - separate applications of features you software must support or interact with. It's segregation of business neesgs. Works in **problem space** - what we have to implement.
1. **Bounded Context** - a specific responsibility, with explicit boundaries that separate it from other parts of the system. The segregation of sowtrare parts - workes in **solution space**.
1. **Context Mapping** - the process of identifying _bounded contexts_ and their relationships to one another.
1. **Ubiquitous Language** - a language using terms from the domain model that programmers and domain experts use to discuss the system.
    * Use throughout a bounded context in conversations, class names, mathod names, etc.

## Elements of Domain Model
1. **Amenic Domain Model** - model wit hclasses focused on state management. Good for CRUD.
1. **Rich Domain Model** - model with logic focused on behavior, not just state. Prefered for DDD.
1. **Entity** a mutable class with an identity (not tied to it's property values) used for **tracking live cycle** and **persistence**.
1. **Immutable** - refers to a type whose state cannot be changed once the object has been instantiated.
1. **Value Object** - an immutable class whose identity is dependent on the combination of its values (datetime, money). Doesn't have an id. We should put as much logic as possible into hour value objects.
1. **Services** provide a place in the model to hold behavior that doen't belongs elsewhere in the domain. Used to implement cross entities communication.

## Aggregates
1. **Aggregate** - a transactional grapth of objects.
1. ** Aggregate Root** - the entry point of an aggregate which ensures the integrity of the entire graph
1. **Invariant** - a condition that should always be true for the system to be in consistent state
1. Properties:
    * Should have a grapth structure. Should have one root.
    * Should implement _ACID_
    * Enforce invariants (some condition that should be maintained accross combination of all root children, e.g. the meeting on a schedule aggregate do not cross)
    * Saving changes can save entire aggregate
    * If we delete root we should delete all it's children
1. Tips:
    * Aggregates can connect only by the root
    * Don't overlook using FKs for non-root entities connections. To many FKs to non-root entities my suggest a problem
    * Aggregate of one are acceptable
    * "Rule of Cascading Deletes"