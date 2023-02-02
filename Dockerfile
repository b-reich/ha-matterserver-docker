FROM docker.io/library/debian:stable-slim

ENV DEBIAN_FRONTEND noninteractive
ENV MATTER_SERVER_VERSION 2.0.2
ENV HOME_ASSISTANT_CHIP_VERSION 2022.12.0

# RUN apt-get update && apt-get install -y ibgirepository1.0-dev gcc libcairo2-dev pkg-config python3-dev gir1.2-gtk-3.0
# RUN apk add --no-cache \
#     build-base cairo-dev cairo cairo-tools cargo

RUN \
    set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    libuv1 \
    openssl \
    zlib1g \
    libjson-c5 \
    python3-venv \
    python3-pip \
    python3-gi \
    python3-gi-cairo \
    python3-dbus \
    python3-psutil \
    unzip \
    libcairo2 \
    gdb \
    git \
    && git clone --depth 1 -b master \
    https://github.com/project-chip/connectedhomeip \
    && cp -r connectedhomeip/credentials /root/credentials \
    && rm -rf connectedhomeip \
    && apt-get purge -y --auto-remove \
    git \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /usr/src/*

WORKDIR /data

RUN pip3 install --no-cache-dir python-matter-server[server]=="${MATTER_SERVER_VERSION}"

CMD [ "python3", "-m", "matter_server.server", "--storage-path", "/data" ]

VOLUME ["/data"]
EXPOSE  5580