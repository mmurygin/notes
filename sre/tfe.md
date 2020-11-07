# Terraform Enterprise

## Monitoring
1. Infrastructure metrics
    * VM
        * uptime
        * CPU
        * RAM
        * Network
    * Docker Containers (cAdvisor)
        * CPU, RAM, Network for everyone of them
        * health for critical containers
    * Replicated
        * containers are healthy
    * PostgreSQL
    * S3
1. Business metrics
    * uptime
    * vcs connection is working (push to gitlab repo triggers a run)
    * Workspaces in error state - shows us if our CD pipeline is broken
    * Average time in the queue for a run
    * Pending runs - shows if we enought capacity
    * Plan time (based on organization) - shows us if we have (too) big workspaces


## Logging

## Alerting
