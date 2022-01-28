# Cisco Shortcuts

  * [General](#general)
  * [Auth](#auth)
  * [Switching](#switching)
    + [VLAN config](#vlan-config)
      - [Switch](#switch)
      - [Router](#router)
  * [Routing](#routing)
    + [Static Configs](#static-configs)
    + [OSPF](#ospf)
  * [Hints](#hints)

## General
1. `?` shows the list of available options (like tab in linux)
1. `do <command>` - run admin commands from global config
1. `show running-config` show the current configs
1. `w` - save configs
1. `no ip domain-lookup` - disable ip domain lookup



## Auth
1. Enable sync console (to avoid bad user expirience during typing)

    ```
    conf t
    line console 0
    logging syncronous
    ```

1. Configure `enable` mode password

    ```
    conf t
    # the old way to do it is `enable password <password>`, but with password command it is not encrypted
    enable secret <password>
    ```

1. Create user with password

    ```
    conf t
    username max secret <password>
    ```

1.  Secure console access

    ```
    conf t
    line console 0

    # use global password
    login
    password <password>

    # use local user/password database
    login local
    ```

1. Configure telnet access

    ```
    cont t
    line vty 0 4

    # use global password
    login
    password <password>

    # use local user/password database
    login local

    transport input all
    ```

1. Configure ssh access

    ```
    cont t

    crypto key generate rsa general-keys modulus 2048
    ip ssh version 2

    line vty 0 4
    login local
    transport input ssh
    ```

## Switching
1. `show ip interface brief` - show int info from global path

### VLAN config

#### Switch
1. View VLANs

    ```
    show vlan
    show interface f0/1 switchport
    show interface trunk
    ```

1. Create VLAN

    ```
    conf t
    vlan 10
    name "vlan-name"
    ```

1. Add interface to VLAN

    ```
    cont t
    int f0/0

    switchport mode access
    switchport access vlan 10
    ```

1. Set interace as a trunk

    ```
    int f0/1

    # required for old switches, default value for new
    switchport trunk encapsulation dot1q

    switchport mode trunk

    # disable Dynamic Trunk Protocol (DTP)
    switchport nonegotiate
    ```

#### Router on a Stick

    ```
    conf t

    # create subinterface 10
    int f0/0.10

    # set VLAN 10 for this interface
    encapsulation dot1Q 10

    # set IP address for a new interface
    ip address 10.0.0.1 255.255.255.0
    ```


## Routing

### Static Configs
1. `show ip route` - show the list of routes

1. Set IP address

    ```
    conf t
    int f0/0
    no shutdown
    ip address 10.0.0.1 255.255.255.0
    ```

1. Create loopback address

    ```
    conf t
    int loopback 1
    ip address 10.0.0.1 255.255.255.0
    ```

1. Set default route
    ```
    ip route 0.0.0.0 0.0.0.0 g0/0 10.1.0.99
    ```


### OSPF
1. View OSPF data

    ```
    show ip protocols
    show ip ospf
    show ip ospf interface brief
    show ip ospf neighbour
    ```

1. Enable OSPF

    ```
    route ospf <process-id>

    # advertise any network with 10.x.x.x
    network 10.0.0.0 0.255.255.255 area 0

    # advertise any network
    network 0.0.0.0 255.255.255.255 area 0

    # set base for cost calculation to 1Gb/s
    auto-cost reference-bandwidth 1000

    # advertize default role
    network-information originate
    ```



## Hints

1. Configure the list of interfaces

    ```
    int range f0/1-24
    ```
