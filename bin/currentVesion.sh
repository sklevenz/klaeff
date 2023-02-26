#!/usr/bin/env bash

REPO_REMOTE=$(git config --get remote.origin.url)
REPO_NAME=$(basename -s .git $REPO_REMOTE)
REPO_OWNER=$GITHUB_COM_USER
GITHUB_ACCESS_TOKEN=$GITHUB_COM_TOKEN

JSON_RESPONSE=$(curl -H "Authorization: token $GITHUB_ACCESS_TOKEN" -H "Accept: application/vnd.github+json" -s https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest)

VERSION=$(echo "$JSON_RESPONSE" | jq .name)
DRAFT=$(echo "$JSON_RESPONSE" | jq .draft)
PRERELEASE=$(echo "$JSON_RESPONSE" | jq .prerelease)

echo "VERSION=$VERSION"
echo "DRAFT=$DRAFT"
echo "PRERELEASE=$PRERELEASE"
