# Security

## Goals
1. Privacy
1. Protection agaist DDoS

## Network
1. Firewall for ingress
1. Lack of public API
    * Bastion host pattern
    * NAT Gateway for egress traffic
    * VPNs
        * IPsec
        * software based (openVPN)
1. Multiple subnetworks (AWS way)
    * only load balancer has public IP
    * load balancer could communicate only with web server
    * web server could only communicate with application server
    * only application servers can communicate with database
1. Multiple NIC on different networks (GCP way)
    * server A has nic1 in subnet1
    * server B has nic1 in subnet2
    * server C has nic1 in subnet1 and nic2 and subnet2
    * as a result A could not talk to B, but both of them could task to C
1. Encrypt data in transit and at rest

## DDoS
1. Types
    * Bandwidth (DNS amplification)
    * Connection
        * SYN Flood
    * Resources
        * UDP Flood
    * Application insight
1. Protection
    * minimize the attack surface area and safeguard exposed resources and prevent cascading failure.
    * autoscaling
        * if we are on premise we could route some part of the traffic to major cloud provider (AWS) which could handle it.
    * proxy traffic through 3d party provider
    * send traffic to some external provider, who has higher capacity (e.g. CDN)
    * caching


## IAM and auditing
1. Audit cloud / infrastructure API access

