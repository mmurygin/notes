# Scaling Frontend

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
