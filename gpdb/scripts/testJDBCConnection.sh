#!/bin/bash

export JAVA_OPTS=" -Djava.security.auth.login.config=/home/gpadmin/.java.login.config -Dsun.security.krb5.debug=true -Djavax.net.debug=all "
export JDBCTEST_FILE="JDBCTest-1.0.jar"
export POSTGRES_FILE="postgresql-42.1.4.jar"
export DATADIRECT_FILE="greenplum.jar"
export SQL_QUERY="select * from basictable"

# Example:
# java $JAVA_OPTS -classpath ./greenplum.jar:./postgresql-42.1.4.jar:./JDBCTest-1.0.jar io.pivotal.support.JDBCTest "jdbc:postgresql://localhost:5432/basic_db?kerberosServerName=gpadmin&jaasApplicationName=pgjdbc&user=gpadmin/kdc-kadmin&&loggerLevel=TRACE&loggerFile=pgjdbctrace.log" "select count(*) from basictable" com.pivotal.jdbc.GreenplumDriver
#export JAVA_OPTS=" -Djava.security.auth.login.config=/home/gpadmin/.java.login.config -Dsun.security.krb5.debug=true -Djavax.net.debug=all  -Dsun.security.krb5.principal=gpadmin/kdc-kadmin"
#export JAVA_OPTS=" -Djava.security.auth.login.config=/home/gpadmin/.java.login.config -Dsun.security.krb5.debug=true -Djavax.net.debug=all "
#java $JAVA_OPTS -classpath ./greenplum.jar:./postgresql-42.1.4.jar:./JDBCTest-1.0.jar io.pivotal.support.JDBCTest "jdbc:postgresql://localhost:5432/testdb?kerberosServerName=gpadmin&jaasApplicationName=pgjdbc&user=gpadmin/kdc-kadmin&loggerLevel=TRACE&loggerFile=pgjdbctrace.log" "select count(*) from account" com.pivotal.jdbc.GreenplumDriver
#java $JAVA_OPTS -classpath ./greenplum.jar:./postgresql-42.1.4.jar:./JDBCTest-1.0.jar io.pivotal.support.JDBCTest "jdbc:postgresql://localhost:5432/testdb?kerberosServerName=gpadmin&jaasApplicationName=pgjdbc&user=gpadmin/kdc-kadmin&&loggerLevel=TRACE&loggerFile=pgjdbctrace.log" "select count(*) from account" com.pivotal.jdbc.GreenplumDriver

if [ -f "$JDBCTEST_FILE"  ] #POSTGRES_FILE
then
  # use DataDirect driver
  if [ -f "$DATADIRECT_FILE" ]
  then
    java $JAVA_OPTS -classpath ./greenplum.jar:./postgresql-42.1.4.jar:./JDBCTest-1.0.jar io.pivotal.support.JDBCTest "jdbc:postgresql://localhost:5432/basic_db?kerberosServerName=gpadmin&jaasApplicationName=pgjdbc&user=gpadmin/kdc-kadmin&&loggerLevel=TRACE&loggerFile=pgjdbctrace.log" $SQL_QUERY com.pivotal.jdbc.GreenplumDriver
  else
    echo "$DATADIRECT_FILE not found. Using JDBC Driver: $POSTGRES_FILE "
    java $JAVA_OPTS -classpath ./greenplum.jar:./postgresql-42.1.4.jar:./JDBCTest-1.0.jar io.pivotal.support.JDBCTest "jdbc:postgresql://localhost:5432/basic_db?kerberosServerName=gpadmin&jaasApplicationName=pgjdbc&user=gpadmin/kdc-kadmin&&loggerLevel=TRACE&loggerFile=pgjdbctrace.log" $SQL_QUERY org.postgresql.Driver
    exit 0;
  fi
else
  echo "$JDBCTEST_FILE or $POSTGRES_FILE not found."
  exit 1;
fi
