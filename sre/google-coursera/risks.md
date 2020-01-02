The risks for payments journey of the example application:
1. The broken code is pushed into production and as a result our payment processing does not work
2. Client and server side of our app does not correspond to the each other (for example in case of breaking changes on the server, which client does not support)
3. Load Balancer is broken because of incorrect configuration or hardware failure.
4. Server is overloaded and we can not process new payment request
5. Database is overloaded and could not process requests
6. Database hardware was corrupted and we lost all the data.
7. VM with server or with database failed.
8. The whole region of cloud provider failed
9. Network between database and server is saturated and packets can not be transfered
10. Google payment API changed without backward compatability (it sometimes happend, but Google will always warn you at least 6 month in advance) and we do not reflect this changes.
