#!/bin/bash
# debugging
#set -x

echo "=========================================================================="
echo "==== Kerberos KDC and Kadmin ============================================="
echo "=========================================================================="
KADMIN_PRINCIPAL_FULL=$KADMIN_PRINCIPAL@$REALM
GPADMIN_PRINCIPAL_FULL=$GPADMIN_PRINCIPAL@$REALM
POSTGRES_PRINCIPAL_FULL=$POSTGRES_PRINCIPAL@$REALM
GPADMIN_ADMIN_PRINCIPAL_FULL=$GPADMIN_ADMIN_PRINCIPAL@$REALM

echo "REALM: $REALM"
echo "KADMIN_PRINCIPAL_FULL: $KADMIN_PRINCIPAL_FULL"
echo "KADMIN_PASSWORD: $KADMIN_PASSWORD"
echo ""
echo "GPADMIN_PRINCIPAL_FULL: $GPADMIN_PRINCIPAL_FULL"
echo "GPADMIN_PASSWORD: $GPADMIN_PASSWORD"
echo ""
echo "The Kerberos service principal name is formed as "
echo "<service name>/<fully qualified hostname>@KerberosRealm, and is used to verify"
echo " incoming Kerberos token requests."

echo "==================================================================================="
echo "==== /etc/krb5.conf ==============================================================="
echo "==================================================================================="
KDC_KADMIN_SERVER=$(hostname -f)
tee /etc/krb5.conf <<EOF
[libdefaults]
	default_realm = $REALM

[realms]
	$REALM = {
		kdc_ports = 88,750
		kadmind_port = 749
		kdc = $KDC_KADMIN_SERVER
		admin_server = $KDC_KADMIN_SERVER
		key_stash_file = /var/kerberos/krb5kdc/.$REALM
	}
[domain_realm]
	 .$REALM = $REALM
	 $REALM = $REALM
[logging]
   kdc = FILE:/var/log/krb5kdc.log
   admin_server = FILE:/var/log/kadmin.log
   default = FILE:/var/log/krb5lib.log
EOF
echo ""

echo "==================================================================================="
echo "==== /var/kerberos/krb5kdc/kdc.conf ==============================================="
echo "==================================================================================="
tee /var/kerberos/krb5kdc/kdc.conf <<EOF
[realms]
	$REALM = {
		acl_file =/var/kerberos/krb5kdc/kadm5.acl
		max_renewable_life = 7d 0h 0m 0s
		supported_enctypes = $SUPPORTED_ENCRYPTION_TYPES
		default_principal_flags = +preauth
		ticket_lifetime = 24h
		renew_lifetime = 7d
	}
[domain_realm]
		 .$REALM = $REALM
		 $REALM = $REALM
EOF
echo ""

echo "==================================================================================="
echo "==== /var/kerberos/krb5kdc/kadm5.acl =============================================="
echo "==================================================================================="
tee /var/kerberos/krb5kdc/kadm5.acl  <<EOF
$KADMIN_PRINCIPAL_FULL *
noPermissions@$REALM X
EOF
echo ""

echo "==================================================================================="
echo "==== Creating realm ==============================================================="
echo "==================================================================================="
MASTER_PASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1)
echo $MASTER_PASSWORD > /master_pwd.txt
echo "Creating the KDC with password : $MASTER_PASSWORD"
kdb5_util -P $MASTER_PASSWORD  -r $REALM create -s #If you specify the -s option, kdb5_util will stash a copy of the master key in a stash file
chkconfig krb5kdc on
chkconfig kadmin on
service krb5kdc start
service kadmin start
sleep 10

echo ""

echo "==================================================================================="
echo "==== Create the principals in the acl ============================================="
echo "==================================================================================="
echo "Adding [$KADMIN_PRINCIPAL] principal"
kadmin.local -q "delete_principal -force $KADMIN_PRINCIPAL_FULL"
echo ""
kadmin.local -q "addprinc -pw $KADMIN_PASSWORD $KADMIN_PRINCIPAL_FULL"
echo ""

echo "Adding noPermissions principal"
kadmin.local -q "delete_principal -force noPermissions@$REALM"
echo ""
kadmin.local -q "addprinc -pw $KADMIN_PASSWORD noPermissions@$REALM"
echo ""

echo "Adding [$GPADMIN_ADMIN_PRINCIPAL] principal"
kadmin.local -q "delete_principal -force $GPADMIN_ADMIN_PRINCIPAL_FULL"
echo ""
kadmin.local -q "addprinc -pw $GPADMIN_ADMIN_PASSWORD $GPADMIN_ADMIN_PRINCIPAL_FULL"
echo ""

echo "Adding noPermissions principal"
kadmin.local -q "delete_principal -force noPermissions@$REALM"
echo ""
kadmin.local -q "addprinc -pw $GPADMIN_ADMIN_PASSWORD noPermissions@$REALM"
echo ""


#https://gpdb.docs.pivotal.io/500/admin_guide/kerberos.html
# The first addprinc creates a Greenplum Database user as a principal, gpadmin/kerberos-gpdb.
echo "Adding [$GPADMIN_PRINCIPAL] principal for gpadmin "
kadmin.local -q "delete_principal -force $GPADMIN_PRINCIPAL_FULL"
echo ""
echo " addprinc -pw $GPADMIN_PASSWORD $GPADMIN_PRINCIPAL_FULL "
kadmin.local -q "addprinc -pw $GPADMIN_PASSWORD $GPADMIN_PRINCIPAL_FULL"
echo ""

echo "Adding noPermissions principal for gpadmin"
kadmin.local -q "delete_principal -force noPermissions@$REALM"
echo ""
kadmin.local -q "addprinc -pw $GPADMIN_PASSWORD noPermissions@$REALM"
echo ""

# The second addprinc command creates the postgres process on the Greenplum Database master host as a principal in the Kerberos KDC.
# This principal is required when using Kerberos authentication with Greenplum Database.

echo "Adding [$POSTGRES_PRINCIPAL_FULL] principal for postgres "
kadmin.local -q "delete_principal -force $POSTGRES_PRINCIPAL_FULL"
echo ""
echo " addprinc -pw $POSTGRES_PASSWORD $POSTGRES_PRINCIPAL_FULL"
kadmin.local -q "addprinc -pw $POSTGRES_PASSWORD $POSTGRES_PRINCIPAL_FULL"
echo ""

echo "Adding noPermissions principal for postgres"
kadmin.local -q "delete_principal -force noPermissions@$REALM"
echo ""
kadmin.local -q "addprinc -pw $POSTGRES_PASSWORD noPermissions@$REALM"
echo ""

echo "Adding host/gpdbsne.example.com principal  "
kadmin.local -q "delete_principal -force host/gpdbsne.example.com"
echo ""
echo " addprinc -pw $POSTGRES_PASSWORD host/gpdbsne.example.com"
kadmin.local -q "addprinc -pw $POSTGRES_PASSWORD host/gpdbsne.example.com"
echo ""

echo "Adding host/localhost principal  "
kadmin.local -q "delete_principal -force host/localhost"
echo ""
echo " addprinc -pw $POSTGRES_PASSWORD host/localhost"
kadmin.local -q "addprinc -pw $POSTGRES_PASSWORD host/localhost"
echo ""


echo "Adding gpadmin/localhost principal  "
kadmin.local -q "delete_principal -force gpadmin/localhost"
echo ""
echo " addprinc -pw $POSTGRES_PASSWORD gpadmin/localhost"
kadmin.local -q "addprinc -pw $POSTGRES_PASSWORD gpadmin/localhost"
echo ""


echo "Adding noPermissions principal for postgres"
kadmin.local -q "delete_principal -force noPermissions@$REALM"
echo ""
kadmin.local -q "addprinc -pw $POSTGRES_PASSWORD noPermissions@$REALM"
echo ""

# Create a Kerberos keytab file with kadmin.local. The following example creates a keytab file gpdb-kerberos.keytab in the current directory with authentication information for the two principals.
echo "Generate Keytab file "
echo "kadmin.local -q \"xst -k /tmp/gpdb-kerberos.keytab $GPADMIN_PRINCIPAL_FULL $POSTGRES_PRINCIPAL_FULL host/localhost host/gpdbsne.example.com\""
kadmin.local -q "xst -k /tmp/gpdb-kerberos.keytab $GPADMIN_PRINCIPAL_FULL $POSTGRES_PRINCIPAL_FULL host/localhost host/gpdbsne.example.com gpadmin/localhost"
echo ""
echo "kadmin.local -q listprincs"
kadmin.local -q listprincs
echo ""
echo "=========================================================================="
echo " Note: To restart kadmind: use service krb5-admin-server restart "
echo " To restart krb5kdc : use service krb5-kdc restart"
echo " To get principal: kinit -k -t ./gpdb-kerberos.keytab gpadmin/kdc-kadmin@EXAMPLE.COM"
echo " To list all the principals: kadmin.local -q listprincs"
echo "=========================================================================="
# We want the container to keep running until we explicitly kill it.
# So the last command cannot immediately exit. See
#   https://docs.docker.com/engine/reference/run/#detached-vs-foreground
# for a better explanation.
# /sbin/service krb5kdc start
# /sbin/service kadmin start

tail -f /var/log/krb5kdc.log &
while true; do sleep 1000; done
exit 0;
