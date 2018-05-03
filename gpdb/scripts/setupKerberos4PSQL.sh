#!/bin/bash

# Create a Greenplum Database administrator role in the database postgres for
# the Kerberos principal that is used as the database administrator
KEYTAB_FILE="/code/gpdb-kerberos.keytab"
TARGET_KEYTAB_FILE="/home/gpadmin/gpdb-kerberos.keytab"
POSTGRES_CONF="/gpdata/master/gpseg-1/postgresql.conf"
PG_HBA_CONF="/gpdata/master/gpseg-1/pg_hba.conf"
PG_HBA_CONF_ENABLE_KERBEROS="host all all 0.0.0.0/0 gss include_realm=0 krb_realm=EXAMPLE.COM"

echo "========================================================================="
echo "Create a Greenplum Database administrator role in the database postgres "
echo "for the Kerberos principal that is used as the database administrator."
echo "psql postgres -c 'create role \"gpadmin/kdc-kadmin\" login superuser;'"
psql postgres -c 'create role "gpadmin/kdc-kadmin" login superuser;'

echo "========================================================================="
echo "Modify postgresql.conf to specify the location of the keytab file"
if [ -f "$KEYTAB_FILE" ]
then
  echo "$KEYTAB_FILE found."
  cp -f $KEYTAB_FILE $TARGET_KEYTAB_FILE
  chmod 0644 $TARGET_KEYTAB_FILE
  echo "krb_server_keyfile = $TARGET_KEYTAB_FILE"
  if [ -f "$POSTGRES_CONF" ]
  then
  	echo "$POSTGRES_CONF found."
    echo "Adding krb_server_keyfile = '/home/gpadmin/gpdb-kerberos.keytab' "
    echo "krb_server_keyfile = '$TARGET_KEYTAB_FILE'" >> $POSTGRES_CONF
  else
  	echo "$POSTGRES_CONF not found."
    exit 1;
  fi
else
  echo "$KEYTAB_FILE not found."
fi


# where:
# host = Connection attempts made using TCP/IP, (Example psql -h hawq-master-hostname)
# all = Applies to all the database (You can replace "all" with the list of database against which you want kerberos authentication to be applied)
# foo = Name of the user for which kerberos authentication is being setup
# gss/krb5 = It indicates to use GSSAPI/krb5 to authenticate the user.
# include_realm = If set to 1, the realm name from the authenticated user principal is included in the system user name that's passed through user name mapping. This is useful for handling users from multiple realms. If 0, the realm name is not included.
# krb_realm = Sets the realm to match user principal names against. If this parameter is set, only users of that realm will be accepted. If it is not set, users of any realm can connect, subject to whatever user name mapping is done.
echo "========================================================================="
echo "$PG_HBA_CONF_ENABLE_KERBEROS >> $PG_HBA_CONF"
echo $PG_HBA_CONF_ENABLE_KERBEROS >> $PG_HBA_CONF


echo "========================================================================="
echo " Replace host all all 0.0.0.0/0 md5 with #host all all 0.0.0.0/0 md5"
# sed -i -e"s/^host all all 0.0.0.0\/0 md5/#host all all 0.0.0.0\/0 md5/"  /gpdata/master/gpseg-1/pg_hba.conf
sed -i -e"s/^host all all 0.0.0.0\/0 md5/#host all all 0.0.0.0\/0 md5/" $POSTGRES_CONF
echo "========================================================================="
echo "Stop GPDB admin and Start GPDB admin"
export MASTER_DATA_DIRECTORY=/gpdata/master/gpseg-1
source /usr/local/greenplum-db/greenplum_path.sh
gpstop -a
sed -i -e"s/^host all all 0.0.0.0\/0 md5/#host all all 0.0.0.0\/0 md5/" $POSTGRES_CONF
gpstart -a
echo "========================================================================="
#su gpadmin -c "psql -U "gpadmin/kdc-kadmin" -h gpdbsne.example.com postgres"
echo "psql -U \"gpadmin/kdc-kadmin\" -h gpdbsne.example.com postgres"
psql -U "gpadmin/kdc-kadmin" -h gpdbsne.example.com postgres

#logs
#Nov 05 06:33:43 kdc-kadmin.example.com krb5kdc[36](info): TGS_REQ (4 etypes {18 17 16 23}) 172.20.0.4: ISSUE: authtime 1509863225, etypes {rep=18 tkt=18 ses=18}, gpadmin/kdc-kadmin@EXAMPLE.COM for postgres/gpdbsne.example.com@EXAMPLE.COM

exit 0;
