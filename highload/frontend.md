# Scaling Frontend

  * [Architecture](#architecture)
  * [The role of reverse proxy](#the-role-of-reverse-proxy)

## Architecture
1. CDN
1. LoadBalancer
	* Hosted Solution (ELB)
	* Software Based (Nginx, HAProxy)
	* Hardwared Based (F5)
		* very good performance
		* big upfront cost
		* big cost to operate (not enough engineers with sufficient skills)
1. Remove State from App
	* sessions => Memory Store (Redis, Memcache)
	* locks => Memory Store (Redis, Memcache)
	* uploaded files => External File Storage
1. External File Storage
	* S3
	* SAN or FTP
	* it's great when app doesn't know that it uses network file system

## The role of reverse proxy
1. Handling user connections, working with slow clients, keep-alive
    1. Nginx uses async model of handling requests. It means that process is listening for multiple sockets in `epool` syscall. When some sockets have data in it the process goes to "running" stage and handle the data from this sockets
    1. Async model has very good performance - we have only one thread(excluding threads for reading files) and we don't spend time on context switches (which are very expensive, because of copying registries and cleaning up TLB
    1. That's why reverse proxy is very good for handling incoming connections, because we don't spend time on creating new thread/process for every connection and do not consume memory/cpu time.
1. SSL termination
1. Serve static - after some time we will have all the static in memory (because linux caches file which were read from disk), and if there are enough memory to remain all static files there - we will always serve them from memory.

