# Cisco Shortcuts

## Info
1. `show ip interface brief` - show int info from global path
1. `do <command>` - run admin commands from global config


## Global Configs
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
