#!/bin/bash

# Build docker image
# docker-compose -f ./docker-compose-gpdb.yml build --no-cache
echo "Run docker compose "
docker-compose -f ./docker-compose-gpdb.yml up
