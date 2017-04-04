# Microservices

## Common
1. The goal is create fully isolated service. Which could and should be deployed independenly.
1. Do not start with microservices. Because getting bounded context wrong it's very expensive. So it's better to wait until thigs become stable
1. Health check for every service and for the whole system
1. Use **expectation** tests. When service create expectation test for every of it's consumer.
1. Handle versioning of end points. Doing this we can release a new version of service **A** `v2`, but we should support `v1`. Then if we have service **B** which use some of the API of service **A**, we don’t have to release new version of **B**, because **B** still can use version `v1`.
1. Topic for unhandled messages

## API
1. Use correct HTTP status codes
1. Use correct verbs for HTTP requests
1. Use one of the well-known style guide ([paypal](https://github.com/paypal/api-standards/blob/master/api-style-guide.md))
1. Use _Hypermedia AS the Engine of Application State_ to reduce coupling. It means send hyperlinks of next actions to a client.
1. Pass reference to the resource in message, not the resource itself. Because by the time message is handled resource my have changed.
1. Send with API only necessary fields, by doing this we can change our inner models more easyly
1. Use HTTP 202 response code, indicating that the request was accepted but has not yet been processed

## Bounded Context
1. We should split bounded context according to a buissness goals, not according to a data models.
1. Share only necessay fields of shared models

## Deployment
1. Use only necessary configuration for every service
1. Test docker images not standalone code
1. Use dedicated system for providing configuration

## Monitoring
1. Health check for whole system
1. Health check for every server
1. Log aggregation
1. Monitor downstream communications
1. Use correlation ID

## Migration from monolith
1. Identify bounded contexts
1. Move bounded contexts into separate modules
1. Remove unnecessary cross-modules interactions (e.g. if warehouse for some reasone use finance department module)
1. Put database associated code into separate modules
1. Split database schemas and reduce joins between different bounded contexts
1. Choose the most appropriate part (easy to split, need a lot of changes in the feature, necessety to change framework e.t.c) of separation and split it from the monolith
1. Start with a place where mistakes cost less

## Resources
1. [REST in Practice](http://shop.oreilly.com/product/9780596805838.do)
1. [Catastrophic Failover](https://martinfowler.com/bliki/CatastrophicFailover.html)
1. Enterprise Integration Patterns
1. Refactoring Databases
1. [Continious Delivery](https://www.amazon.com/Continuous-Delivery-Deployment-Automation-Addison-Wesley/dp/0321601912)