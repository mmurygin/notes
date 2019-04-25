# RHCE

## NFS
1. Add principal `kadmin.local -x ipa-setup-override-restrictions`
1. Get keytab `ipa-getkeytab -p principal -k keytabpath`

## DNS
1. to disable DNSSEC with unbound use: `val-permissive-mode: yes` in unbound.conf
