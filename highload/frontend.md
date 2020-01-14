# Scaling Frontend

  * [Architecture](#architecture)
  * [Load Balancing](#load-balancing)
  * [Load Balancing Methods](#load-balancing-methods)
  * [Load Balancer Tasks](#load-balancer-tasks)
  * [Load Balancing algorithms](#load-balancing-algorithms)
  * [The role of reverse proxy](#the-role-of-reverse-proxy)

## Architecture
1. CDN
1. LoadBalancer
1. Remove State from App
	* sessions => Memory Store (Redis, Memcache)
	* locks => Memory Store (Redis, Memcache)
	* uploaded files => External File Storage
1. External File Storage
	* S3
	* SAN or FTP
	* it's great when app doesn't know that it uses network file system

## Load Balancing
1. Benefits
    * Spread the load across different servers
    * Rolling updates and maintanance
1. Implementation
    * Smart Clients - not a good idea because to change infra you need to change clients.
    * DNS
        * **-** a lot of caches, some of them could ingnore TTL, as a result it's impossible to perform rolling update, or replace servers or increase capacity and so on
        * **-** restricted amount of servers in DNS response (512 bytes)
	* Hosted Solution (ELB)
	* Software Based (Nginx, HAProxy)
	* Hardwared Based (F5)
		* very good performance
		* big upfront cost
		* big cost to operate (not enough engineers with sufficient skills)
1. Types

## Load Balancing Methods
1. NAT - replace source IP to LB IP and destination IP to backend IP. Keep this mapping in memory to rewrite response IPs
    * **-** consume a lot of CPU and memory on LB in case of high load
1. IP Tunneling
    * IP tunnel is setup in advance between LB and all backends
    * LB encapsulates packet, and sets destination IP as a backend IP
    * Backend remove LB ips, process packet, and send response directly to the client
    * **+** do not have a packets rewrite, as NAT
    * **-** backend should now about ip tunneling
1. Direct routing
    * The LB sets destination MAC address as a MAC addres of choosen backend
    * **-** LB and backend should be on the same network

## Load Balancer Tasks
1. Send health check packages to backends to make sure that they are healthy.
1. Flow control
    * count the amount of pending requests for every backend and limit up to some number (e.g. if there are 100 pending requests to backend it means it's overloaded and struggling, so it's better not to send more requests to it)
1. Subsetting - every load balancer connected to some subset of backends (to remove storing all the connections in memory)

## Load Balancing algorithms
1. Random
    * **-** not even traffic distribution, especially in the case of small amount of backends
1. Round Robin
    * **+** simple to implement
    * **-** varying query cost
    * **-** different machine hardware (in big DC there is wide varyity of CPU hardware)
    * **-** unpredictable events
        * noisy neighbors
        * task restarts - which in many cases requires
1. Least Loaded Round Robin (least connections)
    * **+** spread requests based on backend load
    * **-** if backend is unhealthy it could get 100% requests, because errors are serfed very fast. As a solution, we could count recent errors as a active connection.
    * **-** no adjustment based on CPU power
    * **-** the count of the connection to the backend does not include the requests from other load balancers
1. Weighted Round Robin - backends track the amount of served requests and resource utilization (mostly CPU) and sends them to the load balancer, so that LB could choose the best client.
1. Least Bandwidth
1. IP Hash


## The role of reverse proxy
1. Handling user connections, working with slow clients, keep-alive
    1. Nginx uses async model of handling requests. It means that process is listening for multiple sockets in `epool` syscall. When some sockets have data in it the process goes to "running" stage and handle the data from this sockets
    1. Async model has very good performance - we have only one thread(excluding threads for reading files) and we don't spend time on context switches (which are very expensive, because of copying registries and cleaning up TLB
    1. That's why reverse proxy is very good for handling incoming connections, because we don't spend time on creating new thread/process for every connection and do not consume memory/cpu time.
1. SSL termination
1. Serve static - after some time we will have all the static in memory (because linux caches file which were read from disk), and if there are enough memory to remain all static files there - we will always serve them from memory.


