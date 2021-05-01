#!/usr/bin/env bash
#docker volume rm $DOT_TERRAFORM_FOLDER_VOLUME

export PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && cd .. && pwd )"

export TERRAFORM_DOCKER_IMAGE="hashicorp/terraform:latest"

function execute_terraform {
    docker run -it --rm \
    -v ${ENV_VARIABLES_FILE}:/usr/src/app/vars.tf \
    -v ${DOT_TERRAFORM_FOLDER_VOLUME}:/usr/src/app/.terraform \
    -v ${PROJECT_DIR}/terraform:/usr/src/app \
    -v ${PROJECT_DIR}/src:/usr/src/app/lambda-src \
    -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e ENV \
    -w /usr/src/app \
     ${TERRAFORM_DOCKER_IMAGE} ${1} | tee ${OUT_FILE}
}

mkdir -p ${PROJECT_DIR}/terraform/out
source ${PROJECT_DIR}/terraform/scripts/prepare.sh

execute_terraform init || exit 1
execute_terraform plan || exit 1
execute_terraform apply || exit 1

echo "*** Important ***"
echo "Please see if the Terraform version needs to be updated in the CICD pipeline."
echo "If the version printed below is higher than that in run-on-ci.sh, please update it."
execute_terraform -version
