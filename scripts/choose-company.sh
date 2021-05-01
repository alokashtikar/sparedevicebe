#!/usr/bin/env bash

function ask_user_for_company {
    echo "Choose company"
    select company in "Bitz"; do
        case ${company} in
            "Bitz" ) export COMPANY=${company}; break;;
        esac
    done
}

[ -z "$COMPANY" ] && ask_user_for_company