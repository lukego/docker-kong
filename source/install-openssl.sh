#!/usr/bin/env bash

set -eux

curl -o openssl-1.1.0j.tar.gz https://www.openssl.org/source/openssl-1.1.0j.tar.gz
tar vzxf openssl-1.1.0j.tar.gz
cd openssl-1.1.0j
./config --prefix=/usr/local/opt --openssldir=/usr/local/opt/openssl shared enable-ssl3
make -j
make install_sw


