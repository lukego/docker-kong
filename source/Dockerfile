# Dockerfile to build Kong from source with OpenResty 1.15.8.1 (rc)
FROM ubuntu

# Pre-install

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y \
    axel \
    build-essential \
    curl \
    git \
    gosu \
    libcap2 \
    luarocks \
    m4 \
    ssh \
    libpcre3-dev \
    perl \
    sudo \
    unzip \
    zlib1g-dev

# Install

COPY ./install-openssl.sh /install-openssl.sh
RUN /install-openssl.sh

COPY ./install-openresty.sh /install-openresty.sh
RUN /install-openresty.sh

COPY ./install-luarocks.sh /install-luarocks.sh
RUN /install-luarocks.sh

COPY ./install-kong.sh /install-kong.sh
RUN /install-kong.sh

COPY ./install-luajit.sh /install-luajit.sh
RUN /install-luajit.sh

RUN useradd --uid 1337 kong

# Post-install

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 8000 8443 8001 8444

STOPSIGNAL SIGTERM

CMD ["kong", "docker-start"]
