#!/bin/bash

#set -e

current=`pwd`

cd `dirname $0`

. ./setEnv.sh

cd $current



# Check whether rol exists
psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB}  -tAc
"SELECT 1 FROM pg_roles WHERE rolname='SPARKROLE'" | grep -q 1 || psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c  "DROP ROLE SPARKROLE;"

echo "psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c  \"DROP USER SPARKUSER;\""
psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c  "DROP USER SPARKUSER;"


echo "psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c \"DROP DATABASE IF EXISTS ${GREENPLUM_DB}\" "
psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d "gpadmin" -c "DROP DATABASE IF EXISTS ${GREENPLUM_DB}"
