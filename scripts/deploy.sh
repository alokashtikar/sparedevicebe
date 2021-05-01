#!/usr/bin/env bash

export PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

function ask_user_for_executing_terraform {
    echo "Do you want to execute terraform?"
    select yn in "yes" "no"; do
        case ${yn} in
            "yes" ) (. ${PROJECT_DIR}/terraform/scripts/run.sh); break;;
            "no" ) echo "..."; break;;
        esac
    done
}

function ask_user_for_deploying_api_getaway {
    echo "Do you want to deploy api-gw changes?"
    select yn in "yes" "no"; do
        case ${yn} in
            "yes" ) (. ${PROJECT_DIR}/api-gw/run.sh); break;;
            "no" ) echo "..."; break;;
        esac
    done
}

export TAG=${TAG:-"latest"}

source ${PROJECT_DIR}/scripts/choose-company.sh
source ${PROJECT_DIR}/scripts/choose-env.sh

ask_user_for_executing_terraform
ask_user_for_deploying_api_getaway