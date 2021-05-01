#!/usr/bin/env bash

export PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
export DOCKER_COMPOSE="docker-compose --log-level ERROR"

${DOCKER_COMPOSE} -f ${PROJECT_DIR}/docker-compose-tests.yml down -v