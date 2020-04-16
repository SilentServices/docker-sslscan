# vim:set ft=dockerfile:

# VERSION 1.0
# AUTHOR:         Michael Mueller <michael.mueller@silentservices.de>
# DESCRIPTION:    static sslscan in a Docker container
# TO_BUILD:       docker build --rm -t c0rnholio/docker-sslscan .

# Pull base image.
FROM ubuntu:18.04
MAINTAINER Michael Mueller "michael.mueller@silentservices.de"

# Compile sslscan
RUN \
  sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y git build-essential zlib1g-dev && \
  apt-get build-dep -y openssl && \
  git clone https://github.com/rbsec/sslscan.git && \
  cd sslscan && \
  make clean && \
  make static && \
  make install && \
  cd / && \
  rm -rf /sslscan && \
  apt-get purge -y git build-essential && \
  apt-get -y autoremove --purge && \
  rm -rf /var/lib/apt/lists/*

RUN \
  export uid=1000 gid=1000 && \
  groupadd --gid ${gid} user && \
  useradd --uid ${uid} --gid ${gid} --create-home user

USER user
WORKDIR /home/user

ENTRYPOINT ["/usr/bin/sslscan"]

