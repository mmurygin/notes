# Overload and Cascading Failures

  * [Causes](#causes)
    + [Resource Overload](#resource-overload)
    + [Slow Startup and Cold Cashing](#slow-startup-and-cold-cashing)
      - [Causes](#causes-1)
      - [Prevention](#prevention)
    + [Triggering Conditions for Cascading Failures](#triggering-conditions-for-cascading-failures)
  * [Preventive Actions](#preventive-actions)
    + [Client](#client)
    + [Load Balancers](#load-balancers)
    + [Server](#server)
    + [Human Actions](#human-actions)
  * [Immediate Steps to Address Cascading Failures](#immediate-steps-to-address-cascading-failures)

## Causes
### Resource Overload
1. **Cascading failure** is a failure which grows over time as a result of positive (exacerbating) feedback.
1. Overloaded CPU
    * to many requests
    * excessively long queue lengths
    * thread starvation
1. Overloaded Memory
    * dying tasks (e.g. killed by exausted resources)
    * increase rate of gargabe collection, resulting in increased CPU usage
    * reduction in hit rates
1. Not enough file descriptors
1. Not enough capacity during maintanance or rolling update

### Slow Startup and Cold Cashing
#### Causes
1. Maintanance
1. Rolling Update
1. Service Restart

#### Prevention
1. Overprovision
1. Slowly increase the load to the new cluster
1. Prevent recoursive links between services

### Triggering Conditions for Cascading Failures
1. Process Death
1. Process Updates
1. New Rollouts
1. Organic Growth
1. Planned Changes, Drains or Turndowns
1. Request Profile Changes

## Preventive Actions
### Client
1. Client-Side Throttling
    * server side throttling is not always effective, because for some queires the resources spend on handling the connection is the main part of expensive
    * reject probability = max(0, (requests - K * accepts) / (requests + 1))
1. Keep control on retries
    * per-request retry budget
    * per-client retry budget
    * prevent hierarcical retries
    * have backoff and jitter
    * use clear response code and consider how different failures should be handled.
1. Set timeouts
    * the bigger is timeout the more additional resources are spend on handling connections
    * the smaller timeout the bigger probability of false timeouted request

### Load Balancers
1. RPS limits for every client
    * e.g. limit by IP could help dealing with DoS
1. Keep into account backend utilization before sending requests (e.g. load average)
1. [Circuit bracker](https://martinfowler.com/bliki/CircuitBreaker.html)

### Server
1. Serve requests with degraded quality in case of overload
1. Drop requests in of overload
    * it's better to surve 2k rps and drop 500 extra, then drop all 2.5k requests
    * the best approach is to **priorotize requests**, and in case of overload serve only the most important
1. User request termination on server
    * to prevent cases when client do not waiting for request (timeout) but server still performs the work
1. Propogate timeout from high level services to low-level
    * 10s on load balancer
    * (10 - 1)s on the first backend
    * (10 - 1 - 5)s on the second backend and so on

### Human Actions
1. Load test the server's capacity limits
1. Test failure mode for overload
1. Perform capacity planning


## Immediate Steps to Address Cascading Failures
1. Increase Resources
1. Stop Health Check Failures/Deaths
1. Restart Servers
    * be carefull not to trigger the issue with slow startup and cold cashing
1. Enter Degraded Modes
1. Eliminate Batch Load
1. Eliminate Bad Traffic
1. Drop Traffic
