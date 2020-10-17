FROM frolvlad/alpine-glibc:alpine-3.9_glibc-2.29

ARG EXE_PATH

WORKDIR /opt/app

RUN apk add --update \
  # Container utilities
  tini \
  # App dependencies
  gmp-dev \
  # Clear caches
  && rm -rf /var/cache/apk/*

COPY ${EXE_PATH} /opt/app/telemonitor-exe

ENTRYPOINT ["/sbin/tini", "--"]
CMD [ "./telemonitor-exe" ]
