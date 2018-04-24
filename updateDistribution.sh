#!/bin/bash
DIR=$(dirname $(readlink -f $0))
if [ -f $DIR/.env ]; then export $(cat $DIR/.env | grep -v '^#' | xargs); else echo ".env file is missing"; exit 1; fi

GIT_DISTRIBUTION_RELEASE=$1
if [ -z ${GIT_DISTRIBUTION_RELEASE} ]; then echo "argument for release-version is missing"; exit 1; fi

#---

IMAGE=${IMAGE_NAME}:${IMAGE_VERSION}

CIDS_DISTRIBUTION=cids-distribution-wuppertal
EXTENSION=WuNDa
CONTAINER_BUILD=build_${DISTRIBUTION}_${GIT_DISTRIBUTION_RELEASE}

#----

docker rm -f ${CONTAINER_BUILD} 2> /dev/null
docker run -t \
  --name ${CONTAINER_BUILD} \
  --entrypoint /entrypoint_build.sh \
  --volume $DIR/volume/private:/cidsDistribution/.private \
  --volume $DIR/volume/local:/cidsDistribution/lib/local${EXTENSION} \
  --volume $DIR/volume/local:/cidsDistribution/lib/local${EXTENSION}Internet \
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
    else
      docker tag ${IMAGE} ${IMAGE_NAME}:${GIT_DISTRIBUTION_RELEASE}
      echo "# build of ${CIDS_DISTRIBUTION} (release: ${GIT_DISTRIBUTION_RELEASE}) successful"
    fi

    echo "# you can push it to the docker registry with:"
    if [ -z "${GIT_DISTRIBUTION_RELEASE}" ]; then
      echo "#    docker push ${IMAGE}"
    else
      echo "#    docker push ${IMAGE_NAME}:${GIT_DISTRIBUTION_RELEASE}"
    fi
    echo "####"
  }
}
docker rm ${CONTAINER_BUILD} > /dev/null
