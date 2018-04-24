FROM reg.cismet.de/abstract/cids-distribution:6.3-debian

ARG IMAGE_VERSION=unknown

ENV GIT_DISTRIBUTION_PROJECT=cismet/cids-distribution-wuppertal
ENV CIDS_CODEBASE http://s10221.wuppertal-intra.de/cismet/cidsDistribution
ENV CIDS_ACCOUNT_EXTENSION WuNDa
ENV UPDATE_SNAPSHOTS -U -Dmaven.clean.failOnError=false -Dmaven.test.skip=true

LABEL maintainer="Jean-Michel Ruiz <jean.ruiz@cismet.de>" \
   de.cismet.cids.distribution.name="${GIT_DISTRIBUTION_PROJECT}" \
   de.cismet.cids.distribution.version="${IMAGE_VERSION}" \
   de.cismet.cids.distribution.description="cids Wuppertal Distribution Runtime Image"
