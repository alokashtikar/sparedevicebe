#!/usr/bin/env bash

if [ ${COMPANY} = 'Bitz' ]; then
    if [ ${ENV} = 'qa' ]; then
        source ${PROJECT_DIR}/envs/bitz-dev-env-creds.sh
    elif [ ${ENV} = 'dev' ]; then
        source ${PROJECT_DIR}/envs/bitz-dev-env-creds.sh
    elif [ ${ENV} = 'uat' ]; then
        source ${PROJECT_DIR}/envs/bitz-dev-env-creds.sh
    elif [ ${ENV} = 'prod' ]; then
        source ${PROJECT_DIR}/envs/tab-prod-creds.sh
    else
        echo "Shouldn't be here. Didn't recognize env: ${ENV}"; exit 1;
    fi
else
    echo "Shouldn't be here. Didn't recognize company: ${COMPANY}"; exit 1;
fi