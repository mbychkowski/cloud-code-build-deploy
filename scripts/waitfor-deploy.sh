#!/bin/bash

PROMOTE_TO=$1

export _STATUS="PENDING"

echo "checking status: $_STATUS"

while [ "$_STATUS" != "SUCCEEDED" ]; do

  _STATUS=$(gcloud deploy rollouts describe \
    $_DEPLOY_PIPELINE-$SHORT_SHA-$PROMOTE_TO-0001 \
    --delivery-pipeline $_DEPLOY_PIPELINE \
    --release $_DEPLOY_PIPELINE-$SHORT_SHA \
    --region $LOCATION \
    --format "value(state)")

  if [[ "$_STATUS" == "FAILED" ]]; then
    raise error "status: $_STATUS"
  fi

done

echo "status: $_STATUS"
