# Tests Common

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
