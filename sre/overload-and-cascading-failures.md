# Overload and Cascading Failures

## Prevent overload
1. Resources limit for every server
1. Client-Side Throttling
    * server side throttling is not always effective, because for some queires the resources spend on handling the connection is the main part of expensive
    * reject probability = max(0, (requests - K * accepts) / (requests + 1))
1. Priorotize requests, and in case of overload serve only the most important
1. On a load balancer keep into account the service utilization (e.g. load average)
1. Keep control on retries
    * per-request retry budget
    * per-client retry budget
    * prevent hierarcical retries
    * have backoff and jitter
    * use clear response code and consider how different failures should be handled.

## Resource exhaustion
### Causes
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

### Prevention
1. Load test the server's capacity limits
1. Test failure mode for overload
1. Serve degraded requests
1. Serve only critical requests or reject all requests above some threshold
1. Instrument higher level services not to send queires to overloaded service
    * limit by IP on reverse proxy (to prevent DoS)
    * do not send requests to overloaded services from load balancer
1. Perform capacity planning

### Latency and Deadlines
1. Pick correct deadline
    * the bigger is timeout the more additional resources are spend on handling connections
    * the smaller timeout the bigger probability of false timeouted request
1. Propogate deadline from high level services to low-level
    * 10s on load balancer
    * (10 - 1)s on the first backend
    * (10 - 1 - 5)s on the second backend and so on

## Slow Startup and Cold Cashing
### Causes
1. Maintanance
1. Rolling Update
1. Service Restart

## Prevention
1. Overprovision
1. Slowly increase the load to the new cluster
1. Prevent recoursive links between services

## Triggering Conditions for Cascading Failures
1. Process Death
1. Process Updates
1. New Rollouts
1. Organic Growth
1. Planned Changes, Drains or Turndowns
1. Request Profile Changes

## Immediate Steps to Address Cascading Failures
1. Increase Resources
1. Stop Health Check Failures/Deaths
1. Restart Servers
    * be carefull not to trigger the issue with slow startup and cold cashing
1. Enter Degraded Modes
1. Eliminate Batch Load
1. Eliminate Bad Traffic
1. Drop Traffic
