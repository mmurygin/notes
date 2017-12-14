# Tests Common

## Test Smells
** Before start removing some smell we need to estimate its benefits and cost**

1. Project Smells
    * Production Bugs
    * High Test Maintenance Cost
1. Behaviour Smells
    * Fragile Tests
        * _Interface Sensitivity_ - tests sensetive to changes in sut interface
        * _Behavior Sensitivity_ - tests sensetive to changes into sut behavior
        * _Data Sensetivity_ - tests sensetive to changes in data schema
        * _Context Sensitivity_ - when tests depend on environment
    * [Non-Determinism in Tests](https://martinfowler.com/articles/nonDeterminism.html)
    * Slow tests
1. Code Smells
    * Conditional Test Logic
    * Hard-to-Test Code
    * Test Code Dublication
    * Test Logic in Production

## Goals of Test Automation
1. Tests Should Help Us Improve Quality
    * Tests as Specification
    * Bug Repellent
    * Defect Localization
1. Tests Should Help Us Understand the SUT
    * Tests as Documentation
1. Tests Should Reduce (and Not Introduce) Risk
    * Tests as Safety Net
    * Do No Harm (do not modify production code)
        * a lot of mocks creates an illusion that system works, but actually it could be broken
        * if "prod" then ...`
1. Tests Should Be Easy to Run
    * Fully Automated Test (without manual work, set database connection and etc)
    * Self-Checking Test
    * Repeatable Test
1. Tests Should Be Easy to Write and Maintain
    * Simple Tests
    * Expressive Tests
    * Separation of Concerns (e.g. test UI and buiseness logic separately)
1. Tests Should Require Minimal Maintenance as the System Evolves Around Them
    * Robust Test

## Philosophy
1. Test first development
1. Test by test
    * create empty methods to have a specification
    * implement one test at a time and then implement code to pass it
1. Design outside-in
    * think as a client
    * sub dependencies on your way, then replace them with implementation
1. State verification it's preferable check test result.
1. Design minimal test fixtures

## Principles of Test Automation
1. Write the Tests First
1. Design for Testability
1. Use the Front Door First
1. Communicate Intent
1. Don't Modify the SUT (minimize usage of mocks)
1. Keep Tests Independent
1. Isolate the SUT
1. Minimize Test Overlap
1. Minimize Untestable Code
1. Keep Test Logic Out of Production Code
1. Verify One Condition per Test
