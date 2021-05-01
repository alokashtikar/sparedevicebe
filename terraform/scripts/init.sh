#!/usr/bin/env bash
#docker volume rm $DOT_TERRAFORM_FOLDER_VOLUME

export COMMAND="init"

mkdir -p ${PROJECT_DIR}/terraform/out

source ${PROJECT_DIR}/terraform/scripts/prepare.sh

${PROJECT_DIR}/terraform/scripts/./execute-terraform.sh || exit 1
