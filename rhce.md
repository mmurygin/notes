# RHCE

## Provide repo from disk via ftp
1. try to mount iso disk manually to get file system type:
  * `mount -o ro,loop /path/to/iso /mnt`

## Kerberous auth
1. `yum groups install -y 'Directory Client'`
1. `yum install -y nss-pam-ldapd`
1. set kerberos realm and other params manually (not via dns, this way `authconfig` will use sssd)

## NFS
1. Add principal `kadmin.local -x ipa-setup-override-restrictions`
1. Get keytab `ipa-getkeytab -p principal -k keytabpath`
1. Copy keytab to server and client
1. fstab: `server:/path /mnt nfs _netdev,sec=krb5p 0 0`

## DNS
1. to disable DNSSEC with unbound use: `val-permissive-mode: yes` in unbound.conf
1. use forward server ip address no the hostname
