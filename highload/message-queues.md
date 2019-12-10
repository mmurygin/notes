# Message Queues

## Benefits
1. **Enabling Asynchronous Processing**
    * Interacting with remote servers - when you don't want to depend on the remote server availability - push message to queue and perform job when remote server is available
    * Improve the performance and availability of critical requests - we could just publish (instead of performing long-running job) to queue and immideately respond to user.
    * Resource intensive work
1. **Easier Scalability** - we could scale based on the amount of messages in the queue.
1. **Evening Out Traffic Spikes** - just postpone handling of extra messages when there is a spike of traffic and handle it later.
1. **Isolating Failures and Self-Healing**
1. **Decoupling** - the less two parts of the system know about each other the better

## Challenges
1. **No Message Ordering** - in genereal there is no order, but it could be achived using some tradeofss.
    * Limit the number of consumer to a single thread per queue. This way we could create FIFO.
    * Build the system to assume that messages can arrive in random order.
    * Use a messaging broker that supports partitial message ordering guarantee (by using message group and labels)
1. **Dublicates**
    * Implement idempotent handlers
1. **Race Conditions Become More Likely** - we completely lost the call stack and everything could happened in different order. Developers should pay a lot of attention on this.
1. **Risk of Increased Complexity** - because we add one more component.

## Anti-Patterns
1. **Threating the Message Queue as TCP Socket** - it's bad to use message queue in request => response cycle. It means do not publish message by consumer to publisher.
1. **Threating Message Queue as Database** - by deleting or updating messages in the queue
1. **Coupling Message Producers with Consumers** - e.g. by sharing common classes for data serialization\desirialization
1. **Lack of Poison Message Handling**

## Existed Solutions
1. **Amazon SQS** - the easies and cheapest way to get started. If you don't manage very highload app with a lot of customer demands it's the best option
1. **RabbitMQ**
    **+** supports routing
    **+** configuring lifetime via REST API
    **-** doesn't have scheduled message delivery
    **-** doesn't have good horizontal scaling
1. **ActiveMQ**
    **+** some queue code could be embeded into your app (if it's written in Java), by doing it you decrease coupling even more
    **+** have message groups to perform In-Order Delivery
    **-** performs badly at highload

## Scalability
1. We could easily distribute messages between different brokers just by choosing random from the brokers pool. Random distribution works well for most cases, but if you use ActiveMQ with message groups you should use message group id as a partition key.
