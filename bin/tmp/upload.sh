#!/usr/bin/env bash

GITHUB_ACCESS_TOKEN=$GITHUB_COM_TOKEN
REPO_REMOTE=$(git config --get remote.origin.url)
REPO_NAME=$(basename -s .git $REPO_REMOTE)
VERSION="0.0.1"

echo "============================================================"
set -x
API_RESPONSE_STATUS=$(curl --data-binary "@/Users/stephan/dev/github.com/sklevenz/klaeff/klaeff-service/gen/klaeff-service.zip" -H "Content-Type: application/octet-stream" -H "Authorization: token $GITHUB_ACCESS_TOKEN" -s -i https://uploads.github.com/repos/sklevenz/klaeff/releases/94558762/assets?name=klaeff-service.zip)
echo "$API_RESPONSE_STATUS"
