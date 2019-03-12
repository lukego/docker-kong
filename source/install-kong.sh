#!/usr/bin/env bash

set -eux

git clone -b chore/bump-openresty https://github.com/Kong/kong.git
cd kong
sudo make install
cp bin/kong /usr/local/bin/

