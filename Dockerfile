FROM ubuntu:18.04
MAINTAINER Matt Bentley <mbentley@mbentley.net>

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update &&\
  apt-get install -y fontconfig git git-review gosu libssl-dev python3 python3-pip rsync &&\
  pip3 install tox &&\
  rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
