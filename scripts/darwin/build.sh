#!/bin/bash
# Assuming it is running on Debian

# Variables
ARCH=x64
INPUT_TYPE=dir
LICENSE=MIT
NAME=logdna-agent
NODE_VERSION=12.13.0
OSX=osxpkg

# Step 1: Install Dependencies
sudo npm install -g nexe
sudo apt-get install -y ruby ruby-dev rubygems build-essential
sudo gem install --no-ri --no-rdoc fpm

# Step 2: Prepare Folders and Files
mkdir -p .build/scripts
cp ./scripts/darwin/files/* .build/scripts/

# Step 3: Compile and Build Executable
nexe -i index.js -o .build/logdna-agent -t darwin-${ARCH}-${NODE_VERSION}

# Step 4: OSX Packaging
fpm \
	--input-type ${INPUT_TYPE} \
	--output-type ${OSX} \
	--name ${NAME} \
	--version ${VERSION} \
	--license ${LICENSE} \
	--vendor "LogDNA, Inc." \
	--description "LogDNA Agent for Linux" \
	--url "http://logdna.com/" \
	--maintainer "LogDNA, Inc. <support@logdna.com>" \
	--before-remove ./.build/scripts/uninstall-mac-agent \
	--after-install ./.build/scripts/mac-after-install \
	--osxpkg-identifier-prefix com.logdna \
	--force \
		./.build/logdna-agent=/usr/local/bin/logdna-agent \
		./.build/scripts/com.logdna.logdna-agent.plist=/Library/LaunchDaemons/com.logdna.logdna-agent.plist