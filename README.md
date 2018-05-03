# Greenplum with Kerberos
This example provides docker images with Kerberos KDC, Kerberos client and GPDB single node cluster

# Table of Content

 - A KDC for your desired realm.
 - The `kadmin/admin` principal with every permission.<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Greenplum with Kerberos](#greenplum-with-kerberos)
- [What you get](#what-you-get)
	- [Running](#running)
	- [How to customize (eg. change the REALM)](#how-to-customize-eg-change-the-realm)
	- [License](#license)

<!-- /TOC -->
 - The `noPermissions` principal with no permissions. Useful for testing applications that use kerberos principals.
 - The function `kadminCommand` which performs kadmin commands using the `kadmin/admin` principal.

## Running

### Run docker-compose to initialize KDC, Kerberos client and Greenplum
To run Kerberos KDC and client
run `docker-compose up` on the root directory of this repo.

To run Greenplum with Kerberos instance
run `docker-compose -f ./docker-compose-gpdb.yml up `

### Configure KDC server
1. Login to kdc-kadmin instance
```
docker exec -it kdc-kadmin  bin/bash
```
2. Copy the keytab (gpdb-kerberos.keytab) that is generated during execution of init-script.sh to the shared folder `code` among the docker instances
```
cp /tmp/gpdb-kerberos.keytab /code
```
3. Copy the krb5.conf that is required by any Kerberos clients to the shared folder `code` among the docker instances
```
cp /etc/krb5.conf /code
```

### Configure Greenplum server with Kerberos Authentication
1. Login to Greenplum server (gpdbsne)
```
docker exec -it gpdbsne bin/bash
```
2.  As root, copy krb5.conf into etc/krb5.conf
```
[root@gpdbsne /]# cp /code/krb5.conf /etc/krb5.conf
```

3. Change user as gpadmin. Copy kerberos tab file from shared folder `code` to `home/gpadmin`
```
[root@gpdbsne /]# su gpadmin
[gpadmin@gpdbsne /]$ cp /code/gpdb-kerberos.keytab  /home/gpadmin
```
4. Copy .java.login.conf to `/home/gpadmin`. This file is required for JDBC with Kerberos
```
[gpadmin@gpdbsne /]$ cp /code/gpdb/files/.java.login.config /home/gpadmin
```
5. Verify Kerberos client settings on GPDB.  Using `gpadmin`, run kinit to initialize the kerberos tabfile with principal `gpadmin/kdc-kadmin`

```
[gpadmin@gpdbsne ~]$cd ~
[gpadmin@gpdbsne ~]$kinit -kt ./gpdb-kerberos.keytab gpadmin/kdc-kadmin
```

Use klist to verify the cache is initalized.
```
[gpadmin@gpdbsne ~]$ klist
Ticket cache: FILE:/tmp/krb5cc_500
Default principal: gpadmin/kdc-kadmin@EXAMPLE.COM

Valid starting     Expires            Service principal
11/05/17 21:01:10  11/06/17 21:01:10  krbtgt/EXAMPLE.COM@EXAMPLE.COM
```
6. Configure Kerberos settings by running this script
```
[gpadmin@gpdbsne /]$ /code/gpdb/scripts/setupKerberos4PSQL.sh
```
- Execute `psql postgres -c 'create role "gpadmin/kdc-kadmin" login superuser;'`
- Add `krb_server_keyfile = /home/gpadmin/gpdb-kerberos.keytab` to this file: postgresql.conf
- Add `host all all 0.0.0.0/0 gss include_realm=0 krb_realm=EXAMPLE.COM` to this file  /gpdata/master/gpseg-1/pg_hba.conf
- Restart GPDB
7. Verify Greenplum authenticates users with Kerberos KDC.
Next, login as `gpadmin/kdc-kadmin` to the greenplum database. No password is required.

```
[gpadmin@gpdbsne ~]$ psql -U "gpadmin/kdc-kadmin" -h gpdbsne.example.com postgres
psql (8.4.20, server 8.2.15)
WARNING: psql version 8.4, server version 8.2.
         Some psql features might not work.
Type "help" for help.

postgres=#
```
Verify this log entries in the KDC-kadmin server. The log file is `/var/log/krb5kdc.log`
```
Nov 05 21:03:26 kdc-kadmin.example.com krb5kdc[35](info): TGS_REQ (4 etypes {18 17 16 23}) 172.20.0.4: ISSUE: authtime 1509915670, etypes {rep=18 tkt=18 ses=18}, gpadmin/kdc-kadmin@EXAMPLE.COM for postgres/gpdbsne.example.com@EXAMPLE.COM
```
## How to customize (eg. change the REALM)
 1. Change the file `kerberos.env`. This way the properties will be shared between the kdc and the kerberos client.
 2. Define environment variables in `docker-compose.yml` or `docker-compose-gpdb.yml`. You will need to define them for each service that uses kerberos.


If you want to keep up with the possible changes of this repo, you can use:


## License
This example is open source and available under the [MIT license](LICENSE).

Reference:
# https://gpdb.docs.pivotal.io/43170/admin_guide/kerberos.html
# https://discuss.pivotal.io/hc/en-us/articles/218385957-How-to-provide-Single-Sign-On-to-the-Greenplum-Database-with-Microsoft-Active-Directory
