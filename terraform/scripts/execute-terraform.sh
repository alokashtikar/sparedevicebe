#!/usr/bin/env bash

function execute_terraform {
    docker run -it --rm \
    -v ${ENV_VARIABLES_FILE}:/usr/src/app/vars.tf \
    -v ${DOT_TERRAFORM_FOLDER_VOLUME}:/usr/src/app/.terraform \
    -v ${PROJECT_DIR}/terraform:/usr/src/app \
    -v ${PROJECT_DIR}/src:/usr/src/app/lambda-src \
    -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e ENV \
    -w /usr/src/app \
    ${TERRAFORM_DOCKER_IMAGE} ${COMMAND} | tee ${OUT_FILE}
}
echo "PROJECT_DIR: $PROJECT_DIR"
execute_terraform