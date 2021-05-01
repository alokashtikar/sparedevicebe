#!/usr/bin/env bash
#docker volume rm $DOT_TERRAFORM_FOLDER_VOLUME

export TERRAFORM_DOCKER_IMAGE="hashicorp/terraform:0.12.25"

function execute_terraform {
    docker run --rm \
    -v ${WORK_DIR}/terraform:/usr/src/app \
    -v ${WORK_DIR}/src:/usr/src/app/lambda-src \
    -v ${ENV_VARIABLES_FILE}:/usr/src/app/vars.tf \
    -v ${DOT_TERRAFORM_FOLDER_VOLUME}:/usr/src/app/.terraform \
    -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e ENV \
    -w /usr/src/app \
    ${TERRAFORM_DOCKER_IMAGE} $@
}

export PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && cd .. && pwd )"
export WORK_DIR=${WORK_DIR:-"${PROJECT_DIR}"}
export APPLY_TERRAFORM_CHANGES=${APPLY_TERRAFORM_CHANGES:-"false"}

export DOT_TERRAFORM_FOLDER_VOLUME="${COMPANY}-${ENV}-dot-terraform"
export ENV_VARIABLES_FILE="${WORK_DIR}/terraform/envs/${COMPANY}-${ENV}.tf"

execute_terraform init

if [ ${APPLY_TERRAFORM_CHANGES} = 'true' ]; then
    execute_terraform apply -auto-approve
else
    execute_terraform plan
fi
