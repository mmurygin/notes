# RHCE

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

1. edit `/etc/sssd/sssd.conf

    ```
    ldap_tls_reqcert = never
    ```

1. test:

    ```
    su ldapuser
    kinit
    klist
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

## NFS
1. before
    1. Add principal `kadmin.local -x ipa-setup-override-restrictions`
    1. Get keytab `ipa-getkeytab -p principal -k keytabpath`
1. server
    1. Copy keytab
    1. create dir and share permissions
    1. export with `sec=krb5p`
    1. start and enable service `nfs`, `rpcbind`
    1. `firewall-cmd --permanent --add-service=nfs --add-service=rpc-bind --add-service=mountd`
    1. make sure that `nfs-secure` is started and enabled
    1. in some cases it's necessary to setup `nfs_t` selinux context
    1. pay attention on sebooleans: `nfs_export_all_rw`, `nfs_export_all_ro` they should be enabled
1. client
    1. fstab: `server:/path /mnt nfs _netdev,sec=krb5p 0 0`
    1. make sure that `nfs-secure` is started and enabled
    1. `nfs-client` is started and enabled
    1. test:
        ```
        su ldapuser
        kinit
        touch /mnt/f1
        ```

## Samba
1. `systemctl enable --now smb nmb`
1. `man mount.cifs`
1. selinux context: `samba_share_t`
1. fstype: `cifs`
1. for multiuser mount set in options: `multiuser,sec=ntlmssp`
1. do not use spaces in password files
1. if use autofs do not forget to put `:` before mount device


## DNS
1. setup interfaces, access_control, forward-zone, firewall
1. to disable DNSSEC with unbound use: `val-permissive-mode: yes` in unbound.conf
1. use forward server ip address no the hostname


## Mail
1. postfix does not use `/etc/hosts` file, so not to relay on hostname based in this file
1. view postfix params without defaults `postfix -n`
1. for null client

    ```
    inet_interfaces=loopback-only
    ```

1. `postqueue [-p] [-f]`

## Questions
1. login with ssh (without ipa-client)
