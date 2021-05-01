#!/usr/bin/env bash
export execute_terraform="docker run -v ${ENV_VARIABLES_FILE}:/usr/src/app/vars.tf -v ${PROJECT_DIR}/terraform:/usr/src/app -v ${PROJECT_DIR}/src:/usr/src/app/lambda-src -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_REGION -e ENV -w /usr/src/app hashicorp/terraform:0.13.3"
