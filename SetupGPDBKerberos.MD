psql template1 -c 'create role "gpadmin/kdc-kadmin" login superuser;'



https://gpdb.docs.pivotal.io/43170/admin_guide/kerberos.html

Configure a Greenplum Database to use Kerberos.

After you have set up Kerberos on the Greenplum Database master, you can configure Greenplum Database to use Kerberos. For information on setting up the Greenplum Database master, see Install and Configure the Kerberos Client.
Create a Greenplum Database administrator role in the database template1 for the Kerberos principal that is used as the database administrator. The following example uses gpamin/kerberos-gpdb.
```
psql template1 -c 'create role "gpadmin/kerberos-gpdb" login superuser;'
```
The role you create in the database template1 will be available in any new Greenplum Database that you create.

Modify postgresql.conf to specify the location of the keytab file. For example, adding this line to the postgresql.conf specifies the folder /home/gpadmin as the location of the keytab file gpdb-kerberos.keytab.

/gpdata/master/gpseg-1/postgresql.conf

```
krb_server_keyfile = '/home/gpadmin/gpdb-kerberos.keytab'
```

sed -i -e"s/^#krb_server_keyfile = ''.*$/krb_server_keyfile = /home/gpadmin/gpdb-kerberos.keytab/" /gpdata/master/gpseg-1/postgresql.conf


echo "krb_server_keyfile = '/home/gpadmin/gpdb-kerberos.keytab'" >> /gpdata/master/gpseg-1/postgresql.conf



Modify the Greenplum Database file pg_hba.conf to enable Kerberos support. Then restart Greenplum Database (gpstop -ar). For example, adding the following line to pg_hba.conf adds GSSAPI and Kerberos support. The value for krb_realm is the Kerberos realm that is used for authentication to Greenplum Database.
```
host all all 0.0.0.0/0 gss include_realm=0 krb_realm=EXAMPLE.COM
```
echo "host all all 0.0.0.0/0 gss include_realm=0 krb_realm=EXAMPLE.COM" >> /gpdata/master/gpseg-1/pg_hba.conf

For information about the pg_hba.conf file, see The pg_hba.conf file in the Postgres documentation.
Create a ticket using kinit and show the tickets in the Kerberos ticket cache with klist.
As a test, log in to the database as the gpadmin role with the Kerberos credentials gpadmin/kerberos-gpdb:

```
psql -U "gpadmin/kerberos-gpdb" -h master.test template1
psql -U "gpadmin/kdc-kadmin" -h master.test template1

```

A username map can be defined in the pg_ident.conf file and specified in the pg_hba.conf file to simplify logging into Greenplum Database. For example, this psql command logs into the default Greenplum Database on mdw.proddb as the Kerberos principal adminuser/mdw.proddb:
$ psql -U "adminuser/mdw.proddb" -h mdw.proddb
If the default user is adminuser, the pg_ident.conf file and the pg_hba.conf file can be configured so that the adminuser can log in to the database as the Kerberos principal adminuser/mdw.proddb without specifying the -U option:
$ psql -h mdw.proddb
The following username map is defined in the Greenplum Database file $MASTER_DATA_DIRECTORY/pg_ident.conf:
# MAPNAME   SYSTEM-USERNAME        GP-USERNAME
mymap       /^(.*)mdw\.proddb$     adminuser
The map can be specified in the pg_hba.conf file as part of the line that enables Kerberos support:
host all all 0.0.0.0/0 krb5 include_realm=0 krb_realm=proddb map=mymap
For more information about specifying username maps see Username maps in the Postgres documentation.
If a Kerberos principal is not a Greenplum Database user, a message similar to the following is displayed from the psql command line when the user attempts to log in to the database:
psql: krb5_sendauth: Bad response
The principal must be added as a Greenplum Database user.
