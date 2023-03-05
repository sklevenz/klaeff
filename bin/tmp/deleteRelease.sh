#!/usr/bin/env bash

set -x 

git fetch --tags

git tag -d "$1"
git push --delete origin "$1"

git fetch --tags
