#!/bin/bash
DIR=$(dirname $(readlink -f $0))
if [ -f $DIR/.env ]; then export $(cat $DIR/.env | grep -v '^#' | xargs); else echo ".env file is missing"; exit 1; fi

GIT_DISTRIBUTION_RELEASE=$1
if [ -z ${GIT_DISTRIBUTION_RELEASE} ]; then echo "argument for release-version is missing"; exit 1; fi

#---

IMAGE=${IMAGE_NAME}:${IMAGE_VERSION}
CONTAINER_BUILD=build_${CIDS_DISTRIBUTION}_${GIT_DISTRIBUTION_RELEASE}_${IMAGE_TAG_SUFFIX}

#----

docker rm -f ${CONTAINER_BUILD} 2> /dev/null
docker run -t \
  --name ${CONTAINER_BUILD} \
  --entrypoint /entrypoint_build.sh \
  --env CIDS_CODEBASE=${CIDS_CODEBASE} \
  --volume $DIR/volume/private:/cidsDistribution/.private \
  --volume $DIR/volume/local:/cidsDistribution/lib/local${CIDS_EXTENSION} \
  --volume $DIR/volume/local:/cidsDistribution/lib/local${CIDS_EXTENSION}Internet \
  ${IMAGE} \
  ${GIT_DISTRIBUTION_RELEASE} \
&& {
  docker commit \
    -a "build.sh" \
    -m "build of branch ${GIT_DISTRIBUTION_RELEASE}" \
    ${CONTAINER_BUILD} \
    ${IMAGE} \
  && { \
    echo "####"
    if [ -z "${GIT_DISTRIBUTION_RELEASE}" ]; then
      echo "# build of ${CIDS_DISTRIBUTION} (dev branch) successful"

      IMAGE_TAG=${IMAGE_VERSION}
    else
      echo "# build of ${CIDS_DISTRIBUTION} (release: ${GIT_DISTRIBUTION_RELEASE}) successful"

      if [ -z "${IMAGE_TAG_SUFFIX}" ]; then
        IMAGE_TAG="${GIT_DISTRIBUTION_RELEASE}"
      else
        IMAGE_TAG="${GIT_DISTRIBUTION_RELEASE}-${IMAGE_TAG_SUFFIX}"
      fi
      docker tag ${IMAGE} ${IMAGE_NAME}:${IMAGE_TAG}
    fi

    echo "# you can push it to the docker registry with:"
    echo "#    docker push ${IMAGE_NAME}:${IMAGE_TAG}"
    echo "####"
  }
}
docker rm ${CONTAINER_BUILD} > /dev/null
