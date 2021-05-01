#!/usr/bin/env bash

export COMMAND="plan"
source ${PROJECT_DIR}/terraform/scripts/prepare.sh

${PROJECT_DIR}/terraform/scripts/./execute-terraform.sh