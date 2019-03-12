#!/usr/bin/env bash

set -eux

LUAROCKS_VERSION=3.0.4

wget -c https://github.com/luarocks/luarocks/archive/v${LUAROCKS_VERSION}.tar.gz \
        -O - | tar -xzf -
cd luarocks-${LUAROCKS_VERSION}
./configure --with-lua=/usr/local/opt/openresty/luajit
make build
make install

