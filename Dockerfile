FROM docker.io/library/python:latest

RUN \
    set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    libnl-route-3-200 

RUN curl https://sh.rustup.rs -sSf | bash -s -- -y 

ENV PATH="/root/.cargo/bin:${PATH}"

ENV MATTER_SERVER_VERSION=8.0.0

RUN pip3 install --no-cache-dir python-matter-server[server]=="${MATTER_SERVER_VERSION}"

CMD [ "python3", "-m", "matter_server.server", "--storage-path", "/data" ]

VOLUME ["/data"]
EXPOSE  5580
