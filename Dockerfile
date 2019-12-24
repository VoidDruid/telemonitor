FROM haskell:8.6.5

WORKDIR /opt/app

COPY . /opt/app

# Build app
RUN ls -a /opt/app
RUN stack build
