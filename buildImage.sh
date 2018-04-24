#!/bin/bash
DIR=$(dirname $(readlink -f $0))
if [ -f $DIR/.env ]; then export $(cat $DIR/.env | grep -v '^#' | xargs); else echo ".env file is missing"; exit 1; fi

# ---
echo ${IMAGE_VERSION}
docker build \
  --build-arg IMAGE_VERSION=${IMAGE_VERSION} \
  -t ${IMAGE_NAME}:${IMAGE_VERSION} \
  .
