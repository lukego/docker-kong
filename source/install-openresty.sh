#!/usr/bin/env bash

set -eux

WORK_DIR=$(pwd)
OPENRESTY_VER=1.15.8.1rc1
OPENRESTY_DIR=$WORK_DIR/openresty-$OPENRESTY_VER
OPENRESTY_PATCHES_DIR=$WORK_DIR/openresty-patches
OPENRESTY_INSTALL_DIR=/usr/local/opt/openresty-$OPENRESTY_VER-kong
JOBS=$(nproc 2> /dev/null || gnproc)

pushd() { builtin pushd $1 > /dev/null; }
popd() { builtin popd > /dev/null; }

if [[ ! -d "$OPENRESTY_DIR" ]]; then
    if [[ ! -f "openresty-$OPENRESTY_VER.tar.gz" ]]; then
        axel -n2 https://openresty.org/download/openresty-$OPENRESTY_VER.tar.gz
    fi

    tar -xzf openresty-$OPENRESTY_VER.tar.gz
fi

git clone -b 1.15.8.1 https://github.com/Kong/openresty-patches

pushd $OPENRESTY_DIR/bundle
    for i in $OPENRESTY_PATCHES_DIR/patches/$OPENRESTY_VER/*.patch; do
        (patch -p1 --forward <$i || \
            echo "Failed to apply patch: $i"; exit 1) \
            && echo "Applied patch: $i"
    done
popd

if [[ ! -f "$OPENRESTY_DIR/Makefile" ]]; then
    pushd $OPENRESTY_DIR
        ./configure \
            --prefix=$OPENRESTY_INSTALL_DIR \
            --with-cc-opt="-I/usr/local/opt/include" \
            --with-ld-opt="-L/usr/local/opt/lib -Wl,-rpath,/usr/local/opt/lib" \
            --with-pcre-jit \
            --with-http_realip_module \
            --with-http_ssl_module \
            --with-http_stub_status_module \
            --with-http_v2_module \
			--with-stream_ssl_preread_module \
            --with-stream_realip_module \
            -j$JOBS
    popd
fi

pushd $OPENRESTY_DIR
    make -j$JOBS
    make install
popd

ln -s $OPENRESTY_INSTALL_DIR /usr/local/opt/openresty
ln -s /usr/local/opt/openresty/bin/resty /usr/local/bin/resty
ln -s /usr/local/opt/openresty /usr/local/openresty

sudo setcap cap_net_raw=+ep $OPENRESTY_INSTALL_DIR/nginx/sbin/nginx

