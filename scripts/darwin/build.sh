#!/bin/bash
# Assuming it is running on Darwin

# Variables
ARCH=x64
INPUT_TYPE=dir
LICENSE=MIT
NAME=logdna-agent
NODE_VERSION=12.13.0
OSX=osxpkg

# Step 1: Install Dependencies
sudo npm cache clean --force
sudo rm -rf ~/.npm/_cacache
npm install -g nexe
brew install gnu-tar
sudo gem install --no-ri --no-rdoc fpm

# Step 2: Prepare Folders and Files
mkdir -p .build/scripts
cp ./scripts/darwin/files/* .build/scripts/

# Step 3: Compile and Build Executable
nexe -i index.js -o .build/logdna-agent -t darwin-${ARCH}-${NODE_VERSION}

# Step 4: Package for OSX
fpm \
	--input-type ${INPUT_TYPE} \
	--output-type ${OSX} \
	--name ${NAME} \
	--version ${VERSION} \
	--package ${NAME}-${VERSION}-unsigned.pkg \
	--license ${LICENSE} \
	--vendor "LogDNA, Inc." \
	--description "LogDNA Agent for Darwin" \
	--url "http://logdna.com/" \
	--maintainer "LogDNA, Inc. <support@logdna.com>" \
	--before-remove ./.build/scripts/uninstall-mac-agent \
	--after-install ./.build/scripts/mac-after-install \
	--osxpkg-identifier-prefix com.logdna \
	--force \
		./.build/logdna-agent=/usr/local/bin/logdna-agent \
		./.build/scripts/com.logdna.logdna-agent.plist=/Library/LaunchDaemons/com.logdna.logdna-agent.plist

# Step 5: Sign OSX Package
wget https://${GITHUB_TOKEN}@github.com/answerbook/absecret/raw/master/abmacsigningkey.p12 -o key.p12
security import key.p12 -k ~/Library/Keychains/login.keychain -P ""
productsign \
	--sign "Developer ID Installer: Answerbook, Inc. (TT7664HMU3)" \
	${NAME}-${VERSION}-unsigned.pkg \
	${NAME}-${VERSION}.pkg