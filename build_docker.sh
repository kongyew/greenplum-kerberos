#!/bin/bash
export DOCKER_LABEL="Kerberos"
export DOCKER_TAG="kochanpivotal/gpdb5.1"
export DOCKER_LATEST_TAG="kochanpivotal/gpdb5.1:latest"

#--build-arg GPDB_VERSION=${GPDB_VERSION}

# https://docs.docker.com/engine/reference/commandline/build/#specifying-target-build-stage-target
# Squash to reduce file size
#docker build --force-rm --squash -t ${DOCKER_TAG} .

# docker build --force-rm  --file ./gpdb/Dockerfile --tag test ./gpdb
docker build --force-rm  --file ./gpdb/Dockerfile -t ${DOCKER_TAG}  ./gpdb

# Build docker image
echo "Build docker image"
docker run --interactive --tty -h gpdbsne \
     ${DOCKER_TAG} /bin/bash -c "/usr/local/bin/setupGPDB.sh;/usr/local/bin/stopGPDB.sh"

echo "Commit docker image"
export DOCKER_LABEL="GPDB 5.1"
export CONTAINER_ID=`docker ps -a -n=1 -q`
docker commit -m "${DOCKER_LABEL}" -a "author" ${CONTAINER_ID} ${DOCKER_LATEST_TAG}

docker-compose build --force-rm
