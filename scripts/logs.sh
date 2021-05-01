#!/usr/bin/env bash

export PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
export DOCKER_COMPOSE="docker-compose --log-level ERROR"

function ask_user_for_service {
    echo "Choose service"
    select service in "tab-dynamodb"; do
        export SERVICE_ID=${service};
        case ${service} in
            "tab-dynamodb" ) export SERVICE_ID=${service}; break;;
        esac
    done
}

function show_logs {
    ${DOCKER_COMPOSE} logs -f ${SERVICE_ID}
}

cd ${PROJECT_DIR}

ask_user_for_service
show_logs
