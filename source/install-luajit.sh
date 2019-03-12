#!/usr/bin/env bash

set -eux

git clone -b v2.1-agentzh https://github.com/openresty/luajit2
cd luajit2
make -j
make install
find /usr/local -name 'liblua*'
