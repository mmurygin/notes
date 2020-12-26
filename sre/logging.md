# Logging

## Five Ws of Logging
1. What happened?
1. When did it happen?
1. Where did it happen?
1. Who was involved?
1. Where did that entity come from?


## Principles
1. Don't collect log data you won't use.
1. Keep logs for as long as they can be used.
1. Alert only on what you must repond to.
1. Define log levels.
    * error is something that requires action
    * if event doesn't require action, make it a warning
1. Don't exceed businees security needs.
    * do not overcomplicate and oversecure logs, because it has it's own price.
1. Logs change (like deployments, drills, hw updates).


## Best Practices
1. Centralize logging system
1. Emit structured logs
