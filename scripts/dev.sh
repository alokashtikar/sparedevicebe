#!/usr/bin/env bash

export PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

docker run -it --rm --entrypoint="/bin/bash" \
-e "LOCAL_DYNAMO_DB_URL=http://tab-dynamodb:8000" \
-e "BITZ_ENV=LOCAL" \
-e "BITZ_PLATFORM=BITZ" \
-e "PLEDGE_ORDER_FEES=0.1" \
-e "PYTHONPATH=/opt/project/test:/opt/project/src" \
-v ${PROJECT_DIR}:/opt/project \
--network="tab" \
registry.ec-internal.com:5000/ec/aws-serverless
