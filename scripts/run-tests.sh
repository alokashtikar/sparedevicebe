#!/usr/bin/env bash

export PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
cd ${PROJECT_DIR}

export COMPOSE_FILE=docker-compose-test.yml

docker-compose up tests
docker-compose down
