troubleshooting.md

## Message "kinit: Cannot contact any KDC for realm 'EXAMPLE.COM' while getting initial credentials"

Solution : Make sure /etc/krb5.conf is installed

cat /etc/krb5.conf
[libdefaults]
	default_realm = EXAMPLE.COM

[realms]
	EXAMPLE.COM = {
		kdc = kdc-kadmin.example.com
		admin_server = kdc-kadmin.example.com
	}


cp /code/gpdb-kerberos.keytab  /tmp;cd /tmp;kinit -k -t ./gpdb-kerberos.keytab gpadmin/kdc-kadmin@EXAMPLE.COM;klist



##Find Kerberos libraries installed on Debian/Ubuntu
```
root@kerberos-client:/tmp# apt-cache show  krb5-user
Package: krb5-user
Source: krb5
Version: 1.12.1+dfsg-19+deb8u2
Installed-Size: 347
Maintainer: Sam Hartman <hartmans@debian.org>
Architecture: amd64
Depends: libc6 (>= 2.14), libcomerr2 (>= 1.01), libgssapi-krb5-2 (>= 1.6.dfsg.2), libgssrpc4 (>= 1.6.dfsg.2), libk5crypto3 (>= 1.9+dfsg~beta1), libkadm5clnt-mit9 (>= 1.12~alpha1+dfsg), libkadm5srv-mit9 (>= 1.12~alpha1+dfsg), libkdb5-7, libkeyutils1 (>= 1.4), libkrb5-3 (= 1.12.1+dfsg-19+deb8u2), libkrb5support0 (>= 1.12~alpha1+dfsg), libss2 (>= 1.01), krb5-config
Conflicts: heimdal-clients
Description: Basic programs to authenticate using MIT Kerberos
Description-md5: ca243064a3a71b9425feb54097e4dfd7
Homepage: http://web.mit.edu/kerberos/
Tag: admin::login, admin::user-management, implemented-in::c,
 interface::commandline, network::client, protocol::kerberos,
 role::program, security::authentication, use::login
Section: net
Priority: optional
Filename: pool/main/k/krb5/krb5-user_1.12.1+dfsg-19+deb8u2_amd64.deb
Size: 137566
MD5sum: d2a158d3560e6572263319b683884933
SHA1: 4fe4241ce71c3ca6aff624f5a0156bec5f8acd61
SHA256: fc36460863d53b97d86b5136cb4f17c72cbfc5d264fb2ed73ee1407a1b6b512d
```

## Install particular package version in Debian/Ubuntu
To install the specific version simply run run:
apt-get install <package name>=<version>

###kinit -k -t ./gpdb-kerberos.keytab gpadmin/kdc-kadmin@EXAMPLE.COM
kinit: relocation error: kinit: symbol krb5_get_init_creds_opt_set_anonymous, version krb5_3_MIT not defined in file libkrb5.so.3 with link time reference
```
 find / -name 'libkrb5.so*'
 ..
 /usr/local/greenplum-db-5.1.0/lib/libkrb5.so
/usr/local/greenplum-db-5.1.0/lib/libkrb5.so.3
/usr/local/greenplum-db-5.1.0/lib/libkrb5.so.3.3
/lib64/libkrb5.so.3
/lib64/libkrb5.so.3.3
```


[gpdbsne 27] ~ > echo $LD_LIBRARY_PATH
/usr/local/greenplum-db/./lib:/usr/local/greenplum-db/./ext/python/lib:



Reference:

https://www.cloudera.com/documentation/enterprise/5-9-x/topics/sg_kerberos_troubleshoot.html#concept_ukc_xjd_sw
