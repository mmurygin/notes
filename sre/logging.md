# Logging

## Five Ws of Logging
1. What happened?
1. When did it happen?
1. Where did it happen?
1. Who was involved?


## Principles
1. Don't collect log data you won't use.
1. Keep logs for as long as they can be used.
1. Alert only on what you must respond to.
1. Don't exceed business security needs.
    * do not over complicate and over secure logs, because it has it's own price.
1. Remove sensitive information from logs
1. Logs change (like deployments, drills, hardware updates).


## Best Practices
1. Centralize logging system
1. Emit structured logs
1. Define and use log levels.
    * error is something that requires action
    * if event doesn't require action, make it a warning
1. Provide as many context as possible
    * call stack
    * library name
    * line number

