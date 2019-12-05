#!/bin/bash
# Assuming it is running on Debian

# Step 1: Install Dependencies
go get -u github.com/tcnksm/ghr

# Step 2: Upload Packages
ghr -n "LogDNA Agent v${VERSION}" -draft ${VERSION} logdna-agent-${VERSION}*.pkg