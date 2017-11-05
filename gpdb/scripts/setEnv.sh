#!/bin/bash
#
#
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Greenplum
export GREENPLUM_HOST=gpdbsne.example.com
export GREENPLUM_USER=gpadmin/kdc-kadmin
export GREENPLUM_DB=basic_db
export GREENPLUM_DB_PWD=pivotal
export PGPASSWORD=${GREENPLUM_DB_PWD}
