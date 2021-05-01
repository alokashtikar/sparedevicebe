#!/usr/bin/env bash

source ${PROJECT_DIR}/terraform/scripts/choose-company.sh
source ${PROJECT_DIR}/terraform/scripts/choose-env.sh
source ${PROJECT_DIR}/terraform/scripts/export-aws-credentials.sh

export OUT_FILE="${PROJECT_DIR}/terraform/out/${COMPANY}_${ENV}_init_$(date +%Y%m%d_%H%M).out"
export DOT_TERRAFORM_FOLDER_VOLUME="${COMPANY}-${ENV}-dot-terraform"
export ENV_VARIABLES_FILE="${PROJECT_DIR}/terraform/envs/${COMPANY}-${ENV}.tf"

# reset volume
#docker volume rm ${DOT_TERRAFORM_FOLDER_VOLUME}