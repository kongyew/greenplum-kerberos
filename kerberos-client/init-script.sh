#!/bin/bash
set -x
source `dirname $0`/configureKerberosClient.sh

# Your application

# You can use the `kadminCommand` function to perform kadmin commands. Example:
# kadminCommand "get_principal yourprincipal@$REALM"

# So that the docker does not exit.
#service ssh start &

while true; do sleep 100000; done
