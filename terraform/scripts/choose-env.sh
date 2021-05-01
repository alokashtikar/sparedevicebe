#!/usr/bin/env bash

function ask_user_for_env {
    echo "Choose environment"
    select env in "dev" "qa" "uat"; do
        case ${env} in
            "dev" ) export ENV=${env}; break;;
            "qa" ) export ENV=${env}; break;;
            "uat" ) export ENV=${env}; break;;
        esac
    done
}

[ -z "$ENV" ] && ask_user_for_env