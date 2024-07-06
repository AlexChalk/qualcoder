#!/bin/bash

REPO="ccbogel/QualCoder"
VERSION="3.4"
FILENAME="$VERSION.zip"

https://github.com/ccbogel/QualCoder/archive/refs/tags/3.4.zip
URL="https://github.com/$REPO/archive/refs/tags/$FILENAME"

wget $URL
unzip $FILENAME
rm $FILENAME
