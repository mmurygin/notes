# Package Management

- [Dpkg](#dpkg)
- [Apt](#apt)
- [RPM](#rpm)
- [Yum](#yum)
- [Links](#links)

## Dpkg
1. To list all packages installed on the system, from a terminal prompt type
    ```bash
    dpkg -l
    ```

1. To list the files installed by a package, in this case the ufw package
    ```bash
    dpkg -L ufw
    ```

1. If you are not sure which package installed a file, `dpkg -S` may be able to tell you
    ```bash
    dpkg -S /etc/host.conf
    ```


## Apt
1. To get Packet Source Lists
    ```bash
    ls /etc/apt/source.list.d/
    ```

1. To update list of latest versions of the software from Packet Source Lists
    ```bash
    sudo apt-get update
    ```

    **This command doesn't install any new versions, only updates their list**

1. To upgrade packages version
    ```bash
    sudo apt-get upgrade -y
    ```

1. To Remove unused packages
    ```bash
    sudo apt-get autoremove -y
    ```

1. To browse packages navigate to [packages.ubuntu.com](packages.ubuntu.com)

## RPM
1. List all packages installed on the system
  ```bash
  rpm -qa
  ```

1. Get package info
  ```bash
  rpm -qi package-name
  ```

1. List all files within a package
  ```bash
  rpm -ql package-name
  ```

1. List all configuration files within a package
  ```bash
  rpm -qc package-name
  ```

1. List all documentation files within a package
  ```bash
  rpm -qd package-name
  ```

1. To query data about not installed package
  ```bash
  rpm -qpi file # option p means query file
  ```

1. Get all scripts which are installed during the package installation
  ```bash
  rpm -qp --scripts pacakge-file
  ```

1. Get package name by file
  ```bash
  rpm -qf file-name
  ```
 

## Yum

## Links
1. [Ubuntu Package Management](https://help.ubuntu.com/lts/serverguide/package-management.html.en)
