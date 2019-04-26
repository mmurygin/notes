# RHCE

## Table of contents
* [Provide repo from disk via ftp](#provide-repo-from-disk-via-ftp)
* [Kerberous auth](#kerberous-auth)
* [NFS](#nfs)
* [Samba](#samba)
* [Scripts](#scripts)
* [Networking](#networking)
* [DNS](#dns)
* [Mail](#mail)
* [HTTP](#http)
* [Mariadb](#mariadb)
* [SSH](#ssh)
* [NTP](#ntp)
* [SELinux](#selinux)
* [Questions](#questions)

## Provide repo from disk via ftp
1. try to mount iso disk manually to get file system type:
    ```bash
    mount -o ro,loop /path/to/iso /mnt
    ```

1. mount iso disk with fstab
    ```
    /root/rhel.iso /repo iso9660 loop,ro,context="system_u:object_r:public_content_t:s0" 0 0
    ```

1. install vsftpd and edit config
    ```
    anon_root=/repo
    ```

1. set yum repo
    ```
    [ftp-repo]
    name = ftp
    baseurl = ftp://server/path
    gpgcheck = 0
    ```

## Kerberous auth
1. `yum groups install -y 'Directory Client'`
1. `yum install -y nss-pam-ldapd`
1. edit `/etc/sysconfig/authconfig`
    ```
    USESSSD=yes
    FORCELEGACY=no
    USESSSDAUTH=yes
    ```

1. `authconfig-tui`

    * set kerberos realm and other params manually (not via dns, this way `authconfig` will use sssd)

1. optional: edit `/etc/sssd/sssd.conf

    ```
    ldap_tls_reqcert = never
    ```

1. test:

    ```
    su ldapuser
    kinit
    klist
    ```

## NFS
1. **before**
    1. Add principal `kadmin.local -x ipa-setup-override-restrictions`
    1. Get keytab `ipa-getkeytab -p principal -k keytabpath`
1. **server**
    1. Copy keytab
    1. create dir and share permissions
    1. export with `sec=krb5p`
    1. start and enable service `nfs`, `rpcbind`
    1. `firewall-cmd --permanent --add-service=nfs --add-service=rpc-bind --add-service=mountd`
    1. make sure that `nfs-secure` is started and enabled
    1. in some cases it's necessary to setup `nfs_t` selinux context
    1. pay attention on sebooleans: `nfs_export_all_rw`, `nfs_export_all_ro` they should be enabled
1. **client**
    1. fstab: `server:/path /mnt nfs _netdev,sec=krb5p 0 0`
    1. make sure that `nfs-secure` is started and enabled
    1. if `nfs-client` service exists, then start and enable it
    1. test:
        ```
        su ldapuser
        kinit
        touch /mnt/f1
        ```

## Samba
1. **server**
    1. `yum install -y samba`
    1. create dir, set permissions
    1. set selinux context
        ```
        semanage fcontext -a -t samba_share_t "/srv/samba(/.*)?"
        restorecon -Rv /srv/samba
        ```
    1. create samba users (linux or ldap users with the same login must exist)
        ```
        smbpasswd -a ldapuser
        ```

    1. check created users
        ```
        pdbedit -L
        ```
    1. set samba configs
        ```
        # /etc/samba/smb.conf
        [global]
        workgroup = SAMBA
        security = user

        passdb backend = tdbsam

        [sales]
        comment = sales stuff
        valid users = @sales
        write list = @sales
        path = /srv/samba/sales
        ```

    1. `systemctl enable --now smb nmb`
    1. `firewall-cmd --permanent --add-service=samba && firewall-cmd --reload`
    1. enable home dirs: set selinux var to on `samba_enable_home_dirs`
1. **client**
    1. `yum install -y samba-client cifs-utils`
    1. view available shares
        ```bash
        smbclient -L hostname
        ```

    1. setup credentials file
        ```
        # /etc/samba/creds
        username=ldapuser
        password=password
    1. setup fstab
        ```
        # single user mount
        //server/path /path-to-mount cifs _netdev,credentials=/path-to-creds

        # multiple users mount
        //server/path /path-to-mount cifs _netdev,credentials=/path-to-creds,sec=ntlmssp,multiuser
        ```
    1. autofs
        ```
        $ cat /etc/auto.master.d/samba.autofs
        /mnt/samba	/etc/auto.samba

        $ cat /etc/auto.samba
        account	-fstype=cifs,credentials=/etc/samba/account.creds ://server.home.local/account
        ```
1. **test**
    ```
    su user
    cifscreds add server.home.local
    toush /mnt/f1
    ```

1. **tips**
    1. `cifscreds` works only after `su user`. the argument `-u` for some reason does not work
    1. `man mount.cifs`
    1. fstype: `cifs`
    1. do not use spaces in password files
    1. if use autofs do not forget to put `:` before mount device
    1. view config documentation in `/etc/samba/smb.conf.example`

1. **auth with kerberos** (does not work locally)
    1. copy keytab to /etc/krb5.keytab
    1. configs
        ```
        security = ADS
        realm = KERBEROS_REALM
        encrypt passwords = yes
        kerberos method = secrets and keytab
        password server = ipaserver.home.local
        ```

## Scripts
1. to read a variable from stdin

    ```
    declare name
    read name

    declare -i number
    read number
    ```

## Networking
1. enable routing

    ```
    sysctl -a | grep forward
    echo net.ipv4.ip_forward = 0 >> /etc/sysctl.conf
    sysctl -p
    sysctl -a | grep forward
    firewall-cmd --permanent --add-masquerade
    ```

1. link aggregation
    1. config: `'{"runner": {"name": "roundrobin"}}'`

1. To create permanent static routes create file inside '/etc/sysconfig/network-scripts/route-interface`

    ```
    cat /etc/sysconfig/network-scripts/route-eth0
    10.0.10.0/24 via 10.0.10.4 dev eth0
    ```
1. IPv6 when set ipv6 address not to forget to put network mask

    ```
    nmcli c modify 'System eth1' ipv6.method manual ipv6.address fd00::210/64
    ```

## DNS
1. setup `interfaces`, `access_control`, `forward-zone`, `firewall-cmd`
1. to disable DNSSEC with unbound use: `val-permissive-mode: yes` in unbound.conf
1. use forward server ip address no the hostname

## Mail
1. **tips**
    1. postfix does not use `/etc/hosts` file, so not to relay on hostname based in this file
    1. view postfix params without defaults `postfix -n`
    1. for null client

        ```
        inet_interfaces=loopback-only
        ```

    1. `postqueue [-p] [-f]`

## HTTP
1. to generate self-signed certificate use
    ```
    genkey servername # from crypto utils package
    openssl req # man req
    ```
1. Redirect
    ```
    <VirtualHost ...>
        Redirect / https://hostname
    </VirtualHost>
    ```

## Mariadb
1. to setup root user password `mysql_secure_installation`
1. create user and grant privileges
    ```
    create user 'blabla'@'%' identified by 'password';
    grant all privileges on *.* to 'blabla'@'%';
    flush privileges;
    ```
1. pay attention on quotes in insert statement

## SSH
1. setup ssh tunnel
    ```
    ssh -fNL 10.0.10.3:2022:10.0.10.4:80 server.home.local
    ```

## NTP
1. configure ntp peer
    ```
    # /etc/chrony.conf
    server someserver.com iburst
    peer peer-hostname-or-ip
    allow 10.0.10./24
    ```

1. allow firewall and restart service
    ```
    systemctl restart chronyd
    firewall-cmd --permanent --add-service=ntp
    firewall-cmd --reload
    ```

1. server fallback
    ```
    # /etc/chrony.conf
    local stratum 10
    ```

1. check sources
    ```
    chronyc sources
    ```

## SELinux
1. install policies documentation
    ```
    yum provides sepolicy
    yum install -y policycoreutils-devel
    sepolicy manpage -p /usr/share/man/man8
    ```

## Questions
1. login with ssh (without ipa-client)
