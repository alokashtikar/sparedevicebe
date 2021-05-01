#!/usr/bin/env bash

export PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
export WORK_DIR=${WORK_DIR:-"${PROJECT_DIR}"}

source ${PROJECT_DIR}/envs/bitz-dev-env-creds.sh

export IMPORT_DATA_FILE="Bitz_UAT_UserProfileTable.csv"
#export IMPORT_DATA_FILE="Bitz_DEV_AssetTable.csv"
#export IMPORT_DATA_FILE="Bitz_DEV_AccountLedgerTable.csv"
export IMPORT_TABLE="Bitz_UAT_UserProfileTable"
#export IMPORT_TABLE="panos_test"

docker run --rm \
-v ${WORK_DIR}:/opt/project \
-w "/opt/project" \
-e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_REGION -e IMPORT_DATA_FILE -e IMPORT_TABLE \
registry.ec-internal.com:5000/ec/aws-ruby-sdk scripts/import-csv-to-dynamodb.rb
