#!/bin/bash

set -e
[[ ${DEBUG} == true ]] && set -x

set -x
# Including configurations
. config.sh



################################################################################
while getopts ":hc:" opt; do
  case $opt in
    c)
      echo "Command Parameter: $OPTARG" >&2
      export COMMAND=$OPTARG
      ;;

    h)me=`basename "$0"`
      echo "Usage: $me "
      echo "   " >&2
      echo "Options:   " >&2
      echo "-h \thelp  " >&2
      echo "-c \tcommand. For example -c up  or -c down  " >&2
      exit 0;
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done



if [[ -z "${COMMAND}" ]]; then
  $DOCKER_COMPOSE_SCRIPT up
else
  if [[ "${COMMAND}" == "up" ]]; then
      $DOCKER_COMPOSE_SCRIPT up
  elif [[ "${COMMAND}" == "down" ]]; then
       $DOCKER_COMPOSE_SCRIPT down
  else # default option
    $DOCKER_COMPOSE_SCRIPT up
  fi
fi
