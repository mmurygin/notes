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
    dpkg --get-selections
    ```

1. To list the files installed by a package, in this case the ufw package
    ```bash
    dpkg -L ufw
    ```

1. If you are not sure which package installed a file
    ```bash
    dpkg -S /etc/host.conf
    ```

1. Get info about package
    ```bash
    dpkg -p package-name
    ```

## Apt
1. To get Packet Source Lists
    ```bash
    ls /etc/apt/source.list.d/
    ```

1. To find package by keywords in their description use
    ```bash
    apt-cache search keyword
    ```

1. To get the information about not installed package
    ```bash
    apt-cache show package-name
    ```

1. To list package dependencies
    ```bash
    apt-cache depends package-name
    ``` 

1. To update list of latest versions of the software from Packet Source Lists
    ```bash
    apt update
    ```

    **This command doesn't install any new versions, only updates their list**

1. To upgrade packages version
    ```bash
    apt upgrade -y
    ```

1. To Remove unused packages
    ```bash
    apt autoremove -y
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
1. Yum config is available at `/etc/yum.conf`
1. The list of repositories is stored at `/etc/yum.repos.d/`
1. Find which package provide executable file
    ```bash
    yum provides exec-name
    ```

1. Find if package available within installed repos
    ```bash
    yum search package-name
    ```

1. Get info about package
    ```bash
    yum info package-name
    ```

1. To only download package without installing it
    ```bash
    yumdownloader package-name
    ```

1. Check for updates
    ```bash
    yum check-update
    ```

1. Update package [all packages by default]
    ```bash
    yum update [package-name]
    ```

1. View what was installed on the system
    ```
    yum history list
    ```

1. View the info about transaction
    ```bash
    yum history info transaction-id
    ```

1. Rollback specific transaction
    ```bash
    yum history undo transaction-id
    ```  

1. Apply only security updates
    ```bash
    yum update --security
    ```


## Links
1. [Ubuntu Package Management](https://help.ubuntu.com/lts/serverguide/package-management.html.en)
