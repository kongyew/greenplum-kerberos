This page describes common troubleshooting procedures for Greenplum with Kerberos.
## How to enable debugging for kerberos via JDBCTest
```
export JAVA_OPTS="-Dsun.security.krb5.debug=true -Dsun.security.krb5.debug=true"
```

```
java $JAVA_OPTS -classpath ./greenplum.jar:./postgresql-42.1.4.jar:./JDBCTest-1.0.jar io.pivotal.support.JDBCTest "jdbc:postgresql://localhost:5432/testdb?kerberosServerName=postgres&jaasApplicationName=pgjdbc&user=gpadmin/kdc-kadmin&loggerLevel=TRACE&loggerFile=pgjdbctrace.log" "select count(*) from company" com.pivotal.jdbc.GreenplumDriver
```

## org.postgresql.util.PSQLException: GSS Authentication failed
```
org.postgresql.util.PSQLException: GSS Authentication failed
	at org.postgresql.gss.MakeGSS.authenticate(MakeGSS.java:66)
	at org.postgresql.core.v3.ConnectionFactoryImpl.doAuthentication(ConnectionFactoryImpl.java:594)
	at org.postgresql.core.v3.ConnectionFactoryImpl.openConnectionImpl(ConnectionFactoryImpl.java:222)
	at org.postgresql.core.ConnectionFactory.openConnection(ConnectionFactory.java:49)
	at org.postgresql.jdbc.PgConnection.<init>(PgConnection.java:194)
	at org.postgresql.Driver.makeConnection(Driver.java:450)
	at org.postgresql.Driver.connect(Driver.java:252)
	at java.sql.DriverManager.getConnection(DriverManager.java:664)
	at java.sql.DriverManager.getConnection(DriverManager.java:247)
	at io.pivotal.support.JDBCTest.performSelect(JDBCTest.java:56)
	at io.pivotal.support.JDBCTest.main(JDBCTest.java:34)
Caused by: java.lang.SecurityException: java.io.IOException: Configuration Error:
	Line 2: expected [{], found [com.sun.security.auth.module.Krb5LoginModule]
	at sun.security.provider.ConfigFile$Spi.<init>(ConfigFile.java:137)
	at sun.security.provider.ConfigFile.<init>(ConfigFile.java:102)
	at sun.reflect.NativeConstructorAccessorImpl.newInstance0(Native Method)
	at sun.reflect.NativeConstructorAccessorImpl.newInstance(NativeConstructorAccessorImpl.java:62)
	at sun.reflect.DelegatingConstructorAccessorImpl.newInstance(DelegatingConstructorAccessorImpl.java:45)
	at java.lang.reflect.Constructor.newInstance(Constructor.java:423)
	at java.lang.Class.newInstance(Class.java:442)
	at javax.security.auth.login.Configuration$2.run(Configuration.java:255)
	at javax.security.auth.login.Configuration$2.run(Configuration.java:247)
	at java.security.AccessController.doPrivileged(Native Method)
	at javax.security.auth.login.Configuration.getConfiguration(Configuration.java:246)
	at javax.security.auth.login.LoginContext$1.run(LoginContext.java:245)
	at javax.security.auth.login.LoginContext$1.run(LoginContext.java:243)
	at java.security.AccessController.doPrivileged(Native Method)
	at javax.security.auth.login.LoginContext.init(LoginContext.java:243)
	at javax.security.auth.login.LoginContext.<init>(LoginContext.java:417)
	at org.postgresql.gss.MakeGSS.authenticate(MakeGSS.java:56)
	... 10 more
Caused by: java.io.IOException: Configuration Error:
	Line 2: expected [{], found [com.sun.security.auth.module.Krb5LoginModule]
pgjdbc {
	at sun.security.provider.ConfigFile$Spi.ioException(ConfigFile.java:666)
	at sun.security.provider.ConfigFile$Spi.match(ConfigFile.java:532)
	at sun.security.provider.ConfigFile$Spi.parseLoginEntry(ConfigFile.java:445)
	at sun.security.provider.ConfigFile$Spi.readConfig(ConfigFile.java:427)
	at sun.security.provider.ConfigFile$Spi.init(ConfigFile.java:329)
	at sun.security.provider.ConfigFile$Spi.init(ConfigFile.java:316)
	at sun.security.provider.ConfigFile$Spi.<init>(ConfigFile.java:135)
	... 26 more
```
Action : Verify .java.login.config is defined correctly.

For example
```
pgjdbc {
  com.sun.security.auth.module.Krb5LoginModule required
  doNotPrompt=true
  useTicketCache=true
  debug=true
  client=true;
};

```

## Reference:
[Java Authentication and Authorization service](https://de.wikipedia.org/wiki/Java_Authentication_and_Authorization_Service)


[Krb5LoginModule](https://docs.oracle.com/javase/7/docs/jre/api/security/jaas/spec/com/sun/security/auth/module/Krb5LoginModule.html)

[Create JAAS Login Configuration File](https://docs.oracle.com/javase/7/docs/technotes/guides/security/jgss/tutorials/LoginConfigFile.html)
