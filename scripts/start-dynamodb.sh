#!/usr/bin/env bash

export PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
export COMPOSE_FILE="docker-compose-tests.yml"
export DOCKER_COMPOSE="docker-compose --log-level ERROR"
export WORK_DIR=${WORK_DIR:-${PROJECT_DIR}}

function cleanup {
    ${DOCKER_COMPOSE} rm -fsv dockerize tab-dynamodb-migrate
}

trap cleanup EXIT

function wait_for_dynamoDB {
    export SERVICE_HOST="tab-dynamodb"
    export SERVICE_PORT="8000"
    ${DOCKER_COMPOSE} up dockerize
}

function start_dynamo_db {
    ${DOCKER_COMPOSE} up -d tab-dynamodb
}

function perform_migrations {
    ${DOCKER_COMPOSE} up tab-dynamodb-migrate
}

cd ${PROJECT_DIR}
${DOCKER_COMPOSE} pull
${DOCKER_COMPOSE} config

start_dynamo_db
wait_for_dynamoDB
perform_migrations