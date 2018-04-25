FROM reg.cismet.de/abstract/cids-distribution:6.3.1-debian

ARG IMAGE_VERSION=unknown

ENV GIT_DISTRIBUTION_PROJECT=cismet/cids-distribution-wuppertal
ENV CIDS_CODEBASE http://s10221.wuppertal-intra.de/cismet/cidsDistribution
ENV CIDS_ACCOUNT_EXTENSION WuNDa
ENV UPDATE_SNAPSHOTS -U -Dmaven.clean.failOnError=false -Dmaven.test.skip=true

ENV TZ=Europe/Berlin
ENV LANG de_DE.UTF-8
ENV LANGUAGE de_DE:de
ENV LC_ALL de_DE.UTF-8

COPY volume/ext/* /cidsDistribution/lib/ext/

LABEL maintainer="Jean-Michel Ruiz <jean.ruiz@cismet.de>" \
   de.cismet.cids.distribution.name="${GIT_DISTRIBUTION_PROJECT}" \
   de.cismet.cids.distribution.version="${IMAGE_VERSION}" \
   de.cismet.cids.distribution.description="cids Wuppertal Distribution Runtime Image"
