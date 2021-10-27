# Cisco Shortcuts

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

## Router config
1. `show ip route` - show the list of routes

1. Set IP address

    ```
    conf t
    int f0/0
    ip address 10.0.0.1 255.255.255.0
    ```

## VLAN config

### Switch
1. View VLANs

    ```
    show vlan
    show interface f0/1 switchport
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
    # set mode as access
    # alternative is trunk mode when it sends packets for all the wlans
    switchport mode access
    switchport access vlan 10
    ```


### Router

    ```
    conf t

    # create subinterface 10
    int f0/0.10

    # set IP address for a new interface
    ip address 10.0.0.1 255.255.255.0

    # set VLAN 10 for this interface
    encapsulation dot1Q 10
    ```

## Hints

1. Configure the list of interfaces

    ```
    int range f0/1-24
    ```
