## Introduction
This folder contains Dockerfile for Greenplum.



### About the files under `gpdb` folder
#### .java.login.config
This file is a Jaas config file that is used by gpadmin
```
pgjdbc {
    com.sun.security.auth.module.Krb5LoginModule required
    debug=true
    doNotPrompt=true
    useTicketCache=true
    renewTGT=true
    useKeyTab=true
    ;
};

```
### scripts
### testJDBCConnection.sh
This script test JDBC connection with Greenplum DataDirect JDBC driver (official version supported by Greenplum) or Postgresql JDBC driver.

You can download and setup the jar from this [site](https://discuss.pivotal.io/hc/en-us/articles/202912073-How-to-test-JDBC-and-Greenplum-Datadirect-JDBC)

####  Usage example
```
[gpadmin@pccadmin jdbc]$ java -classpath ./jdbc-pivotal-support.jar io.pivotal.support.JDBCTest

Usage: pivotal.support.JDBCTest     

JDBCTest:
java -classpath ./postgresql-8.4-701.jdbc4.jar:./jdbc-postgres.jar pivotal.support.JDBCTest "jdbc:postgresql://mdw:5432/gpadmin?protocolVersion=3&user=gpadmin&password=changeme&loglevel=2" "select * from table"

JDBCTestGreenplum:
java -classpath ./jdbc-postgres.jar:greenplum.jar pivotal.support.JDBCTestGreenplum "jdbc:pivotal:greenplum://mdw:4342;DatabaseName=gpadmin;" "select * from table"
```

#### Download the source Code and build jar file.
```
git clone https://github.com/randomtask1155/PivotalJDBCTest.git
cd PivotalJDBCTest
mvn package
```
### setupDB.sh

## Installing Kerberos Authentication with Greenplum

[Using Kerberos Authentication](https://gpdb.docs.pivotal.io/500/admin_guide/kerberos.html)


## Installing Java Cryptography Extension (JCE) Files  

Installing the JCE Unlimited Strength Jurisdiction Policy Files can ensure support for all encryption algorithms when using  Java with SSL on Greenplum with Kerberos. The files must be installed on Greenplum master node.


### Installing the JCE on RHEL-based systems
If necessary, install the EPEL repository:
```$ sudo yum install epel-release```

### Installing the JCE using the Oracle JAR files:
- Download the [Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy Files](http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html) from Oracle Java SE download page under Additional Resources.
- Unzip the downloaded file.
- Copy local_policy.jar and US_export_policy.jar to the $JAVA_HOME/jre/lib/security directory to overwrite the existing jar files.

## References:
### Postgresql
- [Postgresql - configure pg_hba.conf](https://www.postgresql.org/docs/8.2/static/auth-pg-hba-conf.html)
- [Postgresql -auth.c source code](https://doxygen.postgresql.org/auth_8c_source.html)
- [Posgresql with kerberos and GSSAPI](http://paquier.xyz/manuals/postgresql/kerberos/)

### Kerberos Error messages
- [Kerberos - Common Kerberos Error Messages (A-M) ](https://docs.oracle.com/cd/E19253-01/816-4557/trouble-6/index.html)
- [Create a host principal using MIT Kerberos](http://www.microhowto.info/howto/create_a_host_principal_using_mit_kerberos.html)
- [Add a host or service principal to a keytab using MIT Kerberos](http://www.microhowto.info/howto/add_a_host_or_service_principal_to_a_keytab_using_mit_kerberos.html)
-

### Kerberos ebooks
- [Getting started with Kerberos](https://www.safaribooksonline.com/library/view/linux-security-cookbook/0596003919/ch04s11.html)

### Knowledgebase
- [Greenplum kerberos Guide](http://dewoods.com/blog/greenplum-kerberos-guide#kerberos-testing)
- [Pivotal Kerberos Cheat Sheet](https://discuss.pivotal.io/hc/en-us/articles/203053938-Kerberos-Cheat-Sheet)
- [Greenplum - Auth.c](https://github.com/greenplum-db/gpdb/blob/53e756684bd323dd876d7a01fae091188656b21b/src/backend/libpq/auth.c)
- [Pivotal - HDP - How to configure user authentication using kerberos on HAWQ database?](https://discuss.pivotal.io/hc/en-us/articles/201872937-How-to-configure-user-authentication-using-kerberos-on-HAWQ-database-)
- [Pivotal - HDP knowledgebase -](https://discuss.pivotal.io/hc/en-us/sections/115000445988-KERBEROS)
