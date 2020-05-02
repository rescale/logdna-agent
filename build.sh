#!/bin/bash
set -euxo pipefail

NODE_VERSION=v12.16.3

curl -O https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION-linux-x64.tar.xz

tar -xf node-$NODE_VERSION-linux-x64.tar.xz
mv node-$NODE_VERSION-linux-x64 node
rm node-$NODE_VERSION-linux-x64.tar.xz

export PATH=$PATH:node/bin

npm install --production

