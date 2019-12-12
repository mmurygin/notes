# Design Principles

## Simplicity
1. **The most important principle is keeping things simple.**
    * the simplier the system the easiers is to evolve, maintain and optimize.
1. **Hide Complexity and Build Abstractions**
    * hide complexity behind simple API
    * keep modules small and understandable
1. **Avoid Overengineering** -  do not try to predict every possible case how you software will be used. Good design allows you to add more details and features later on, but does not require you to build a massive solution up front.
1. Try TDD - in addition to testability you will gain the view on your system from customer point of view

## Loose Coupling
1. Decrease the amount of connection between your modules and services.
    ![Loose Coupling](./img/loose-coupling.jpg)
1. Avoid unnecessary coupling
    * don't make anything public unless it's really required
    * prevent the necessety of having knowledge on which order your API method should be used
    * avoid circular depencencies and try to make things hierarchical

## Don't Repeat YourSelf
1. Following an inefficient process (e.g. timewasting meetings)
1. Lack of automation
1. Copy-Paste programming
1. Do not repeat someone else (try to use existed solution instead of building your own)

## Coding to Contract

## Draw Diagrams

## Single Responsibility

## Open-CLosed Principle
1. Code should be open for extension and closed for modification. It means that code should be able to support new features without extensions
1. Good example is taking compare function as an argument of sort function

## Depenency Injection

## Inversion Of Control

## Design For Scale
1. Adding more clones
1. Functional Partitioning
1. Data Partitioning

## Self Healing
1. System is never up, it's always particially down
1. Draw the system diagram and identify **Single Points of Failure**
1. Evaluate if it worths to add redundancy level to SPF
