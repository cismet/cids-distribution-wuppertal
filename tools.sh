#!/bin/bash
DIR=$(dirname $(readlink -f $0));
PARAMS=$@

docker run --rm -it \
  -e CIDS_DISTRIBUTION_DIR=${DIR} \
  -v ${DIR}:${DIR}:ro \
  -v $HOME:/root:ro \
  -v /var/run/docker.sock:/var/run/docker.sock \
  reg.cismet.de/abstract/cids-distribution-tools:21.03.1 \
  ${PARAMS}
