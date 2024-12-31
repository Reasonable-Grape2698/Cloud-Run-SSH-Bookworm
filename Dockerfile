FROM python:3.9.21-bookworm

# set version label
ARG BUILD_DATE
ARG VERSION
ARG OPENSSH_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

RUN apt-get update && apt-get install -y libffi-dev gcc
RUN pip install --upgrade pip
RUN pip install webssh

RUN apt-get install -y logrotate \
    nano \
    curl \
    openrc \
    openssh-server && \
  rm -rf \
    /tmp/* \
    $HOME/.cache
# add local files
COPY /root /
COPY /ssh /root/.ssh

EXPOSE 8080

VOLUME /config

RUN mkdir /var/run/sshd && chmod 0755 /var/run/sshd

RUN openrc && touch /run/openrc/softlevel
CMD ["sh", "-c", "/usr/sbin/sshd && wssh --address=0.0.0.0 --port=8080"]
