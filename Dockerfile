# Dummmy docker image, that just copies binary from the host

FROM frolvlad/alpine-glibc:alpine-3.9_glibc-2.29

WORKDIR /opt/app

RUN apk add --update \
  # Container utilities
  tini \
  # App dependencies
  gmp-dev \
  # Clear caches
  && rm -rf /var/cache/apk/*

# TODO: fix path to binary
COPY .stack-work/dist/x86_64-linux-tinfo6/Cabal-2.4.0.1/build/telemonitor-exe/telemonitor-exe \
    /opt/app/telemonitor-exe

ENTRYPOINT ["/sbin/tini", "--"]
CMD [ "./telemonitor-exe" ]
